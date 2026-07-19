import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/engine/prevent.dart';

/// Formulário da calculadora PREVENT.
///
/// Fluxo: pergunta de elegibilidade (DCV prévia) → formulário principal com
/// validação inline → mini-calculadoras de IMC e eGFR → bloco avançado
/// colapsável → botão "Calcular risco" → [onResult] com o [PreventResult].
class CalculatorForm extends StatefulComponent {
  const CalculatorForm({required this.onResult, super.key});

  /// Chamado quando o cálculo é concluído com sucesso.
  final void Function(PreventResult result) onResult;

  @override
  State<CalculatorForm> createState() => CalculatorFormState();
}

class CalculatorFormState extends State<CalculatorForm> {
  // --- Elegibilidade ---
  bool? _priorCvd; // null = não respondido

  // --- Obrigatórios (texto para aceitar vírgula decimal pt-BR) ---
  String _age = '';
  Sex? _sex;
  String _sbp = '';
  String _totalChol = '';
  String _hdl = '';
  String _egfr = '';
  String _bmi = '';

  // --- Comorbidades / tratamentos ---
  bool _diabetes = false;
  bool _smoker = false;
  bool _onBpMed = false;
  bool _onStatin = false;

  // --- Mini-calculadoras ---
  bool _bmiUnknown = false;
  String _weightKg = '';
  String _heightCm = '';
  bool _egfrUnknown = false;
  String _creatinine = '';

  // --- Avançado (opcionais) ---
  bool _advancedOpen = false;
  String _hba1c = '';
  String _uacr = '';

  // --- Validação ---
  Map<String, String> _errors = const {};
  bool _showErrors = false;

  // ---------------------------------------------------------------------------
  // Helpers de parsing / validação
  // ---------------------------------------------------------------------------

  double? _parseNum(String s) {
    final t = s.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  /// Idade como inteiro, aceitando vírgula/ponto decimal
  /// ('55', '55,0', '55.0' → 55). Null quando vazia ou inválida.
  int? get _parsedAge => _parseNum(_age)?.round();

  String? _range(String? raw, double min, double max, String label, {bool integer = false}) {
    if (raw == null || raw.trim().isEmpty) return 'Informe $label.';
    final v = _parseNum(raw);
    if (v == null) return 'Valor inválido. Use apenas números.';
    if (integer && v != v.roundToDouble()) return 'Use um número inteiro.';
    if (v < min || v > max) {
      return '$label deve estar entre ${_fmt(min)} e ${_fmt(max)}.';
    }
    return null;
  }

  static String _fmt(num v) => v == v.roundToDouble() ? '${v.toInt()}' : v.toStringAsFixed(1).replaceAll('.', ',');

  /// IMC calculado a partir de peso/altura (null se incompleto/inválido).
  double? get _computedBmi {
    final w = _parseNum(_weightKg);
    final h = _parseNum(_heightCm);
    if (w == null || h == null || w <= 0 || h <= 0) return null;
    return PreventCalculator.bmi(weightKg: w, heightCm: h);
  }

  /// eGFR calculado a partir de creatinina + idade/sexo do formulário.
  double? get _computedEgfr {
    final cr = _parseNum(_creatinine);
    final age = _parsedAge;
    final sex = _sex;
    if (cr == null || cr <= 0 || age == null || sex == null) return null;
    return PreventCalculator.egfrCkdEpi2021(creatinine: cr, age: age, sex: sex);
  }

  Map<String, String> _validate() {
    final errors = <String, String>{};

    void check(String key, String? error) {
      if (error != null) errors[key] = error;
    }

    check('age', _range(_age, 30, 79, 'A idade', integer: true));
    if (_sex == null) errors['sex'] = 'Selecione o sexo biológico.';
    check('sbp', _range(_sbp, 90, 200, 'A pressão arterial sistólica'));
    check('totalChol', _range(_totalChol, 130, 320, 'O colesterol total'));
    check('hdl', _range(_hdl, 20, 100, 'O HDL-colesterol'));

    if (_bmiUnknown) {
      check('weight', _range(_weightKg, 30, 300, 'O peso'));
      check('height', _range(_heightCm, 100, 230, 'A altura'));
      if (!errors.containsKey('weight') && !errors.containsKey('height')) {
        final bmi = _computedBmi;
        if (bmi == null || bmi < 15 || bmi > 60) {
          errors['bmi'] =
              'O IMC calculado deve estar entre 15 e 60 kg/m². '
              'Confira peso e altura.';
        }
      }
    } else {
      check('bmi', _range(_bmi, 15, 60, 'O IMC'));
    }

    if (_egfrUnknown) {
      check('creatinine', _range(_creatinine, 0.2, 15, 'A creatinina'));
      if (!errors.containsKey('creatinine')) {
        if (_parsedAge == null || _sex == null) {
          errors['egfr'] = 'Informe idade e sexo biológico para calcular o eGFR.';
        } else {
          final egfr = _computedEgfr;
          if (egfr == null || egfr < 15 || egfr > 140) {
            errors['egfr'] = 'O eGFR calculado deve estar entre 15 e 140 mL/min/1,73 m².';
          }
        }
      }
    } else {
      check('egfr', _range(_egfr, 15, 140, 'O eGFR'));
    }

    if (_hba1c.trim().isNotEmpty) {
      check('hba1c', _range(_hba1c, 3, 20, 'A HbA1c'));
    }
    if (_uacr.trim().isNotEmpty) {
      check('uacr', _range(_uacr, 1, 25000, 'A relação albumina/creatinina'));
    }

    return errors;
  }

  void _revalidate() {
    if (_showErrors) {
      _errors = _validate();
    }
  }

  void _submit() {
    final errors = _validate();
    setState(() {
      _errors = errors;
      _showErrors = true;
    });
    if (errors.isNotEmpty) return;

    final bmi = _bmiUnknown ? _computedBmi! : _parseNum(_bmi)!;
    final egfr = _egfrUnknown ? _computedEgfr! : _parseNum(_egfr)!;

    final input = PreventInput(
      age: _parsedAge!,
      sex: _sex!,
      sbp: _parseNum(_sbp)!,
      totalChol: _parseNum(_totalChol)!,
      hdl: _parseNum(_hdl)!,
      egfr: egfr,
      bmi: bmi,
      diabetes: _diabetes,
      smoker: _smoker,
      onBpMed: _onBpMed,
      onStatin: _onStatin,
      hba1c: _hba1c.trim().isEmpty ? null : _parseNum(_hba1c),
      uacr: _uacr.trim().isEmpty ? null : _parseNum(_uacr),
    );

    component.onResult(PreventCalculator.calculate(input));
  }

  // ---------------------------------------------------------------------------
  // Builders de UI
  // ---------------------------------------------------------------------------

  Component _numField({
    required String key,
    required String labelText,
    required String unit,
    required String value,
    required void Function(String) onChanged,
    String? placeholder,
  }) {
    final error = _showErrors ? _errors[key] : null;
    final inputId = 'field-$key';
    return div(classes: 'field${error != null ? ' field-invalid' : ''}', [
      label(
        classes: 'field-label',
        attributes: {'for': inputId},
        [
          .text(labelText),
          span(classes: 'field-unit', [.text(unit)]),
        ],
      ),
      input<String>(
        classes: 'field-input',
        id: inputId,
        type: InputType.text,
        value: value,
        attributes: {
          'inputmode': 'decimal',
          if (placeholder != null) 'placeholder': placeholder,
        },
        onInput: (v) => setState(() {
          onChanged(v);
          _revalidate();
        }),
      ),
      if (error != null) div(classes: 'field-error', [.text(error)]),
    ]);
  }

  Component _switch({
    required String text,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return label(classes: 'switch', [
      input<bool>(
        type: InputType.checkbox,
        checked: value,
        onChange: (v) => setState(() {
          onChanged(v);
          _revalidate();
        }),
      ),
      span(classes: 'switch-slider', []),
      span(classes: 'switch-label', [.text(text)]),
    ]);
  }

  Component _buildEligibility() {
    return div(classes: 'eligibility', [
      p(classes: 'eligibility-question', [
        .text('Você já teve infarto, AVC (derrame) ou insuficiência cardíaca?'),
      ]),
      div(classes: 'choice-row', [
        button(
          classes: 'choice-btn${_priorCvd == true ? ' selected' : ''}',
          attributes: {'type': 'button', 'aria-pressed': '${_priorCvd == true}'},
          onClick: () => setState(() => _priorCvd = true),
          [.text('Sim')],
        ),
        button(
          classes: 'choice-btn${_priorCvd == false ? ' selected' : ''}',
          attributes: {'type': 'button', 'aria-pressed': '${_priorCvd == false}'},
          onClick: () => setState(() => _priorCvd = false),
          [.text('Não')],
        ),
      ]),
      if (_priorCvd == true)
        div(classes: 'alert-card', [
          p(classes: 'alert-title', [
            .text('O PREVENT não é indicado para o seu caso.'),
          ]),
          p([
            .text(
              'A calculadora PREVENT foi desenvolvida e validada para '
              'prevenção primária — ou seja, para pessoas que ainda não '
              'tiveram infarto, AVC ou insuficiência cardíaca. Para quem já '
              'teve algum desses eventos (prevenção secundária), as '
              'recomendações de cuidado são outras.',
            ),
          ]),
          p([
            .text(
              'Procure um médico para uma avaliação individualizada do '
              'seu risco cardiovascular e do seu plano de tratamento.',
            ),
          ]),
        ]),
    ]);
  }

  Component _buildBmiBlock() {
    final computed = _bmiUnknown ? _computedBmi : null;
    final error = _showErrors ? _errors['bmi'] : null;
    return div(classes: 'field span-2', [
      div(classes: 'field-label-row', [
        span(classes: 'field-label', [
          .text('IMC'),
          span(classes: 'field-unit', [.text('kg/m²')]),
        ]),
        _miniToggle(
          text: 'Não sei meu IMC',
          value: _bmiUnknown,
          onChanged: (v) => setState(() {
            _bmiUnknown = v;
            _revalidate();
          }),
        ),
      ]),
      if (!_bmiUnknown)
        input<String>(
          classes: 'field-input',
          type: InputType.text,
          value: _bmi,
          attributes: const {'inputmode': 'decimal', 'placeholder': 'ex.: 27,5'},
          onInput: (v) => setState(() {
            _bmi = v;
            _revalidate();
          }),
        )
      else
        div(classes: 'mini-calc', [
          _numField(
            key: 'weight',
            labelText: 'Peso',
            unit: 'kg',
            value: _weightKg,
            placeholder: 'ex.: 78',
            onChanged: (v) => _weightKg = v,
          ),
          _numField(
            key: 'height',
            labelText: 'Altura',
            unit: 'cm',
            value: _heightCm,
            placeholder: 'ex.: 170',
            onChanged: (v) => _heightCm = v,
          ),
          if (computed != null)
            div(classes: 'mini-calc-result', [
              .text('IMC calculado: ${_fmt(computed)} kg/m²'),
            ]),
        ]),
      if (error != null) div(classes: 'field-error', [.text(error)]),
    ]);
  }

  Component _buildEgfrBlock() {
    final computed = _egfrUnknown ? _computedEgfr : null;
    final error = _showErrors ? _errors['egfr'] : null;
    final missingAgeOrSex = _parsedAge == null || _sex == null;
    return div(classes: 'field span-2', [
      div(classes: 'field-label-row', [
        span(classes: 'field-label', [
          .text('eGFR (taxa de filtração glomerular)'),
          span(classes: 'field-unit', [.text('mL/min/1,73 m²')]),
        ]),
        _miniToggle(
          text: 'Não sei meu eGFR',
          value: _egfrUnknown,
          onChanged: (v) => setState(() {
            _egfrUnknown = v;
            _revalidate();
          }),
        ),
      ]),
      if (!_egfrUnknown)
        input<String>(
          classes: 'field-input',
          type: InputType.text,
          value: _egfr,
          attributes: const {'inputmode': 'decimal', 'placeholder': 'ex.: 90'},
          onInput: (v) => setState(() {
            _egfr = v;
            _revalidate();
          }),
        )
      else
        div(classes: 'mini-calc', [
          _numField(
            key: 'creatinine',
            labelText: 'Creatinina sérica',
            unit: 'mg/dL',
            value: _creatinine,
            placeholder: 'ex.: 0,9',
            onChanged: (v) => _creatinine = v,
          ),
          if (missingAgeOrSex)
            div(classes: 'mini-calc-hint', [
              .text(
                'Informe a idade e o sexo biológico acima para '
                'calcular o eGFR (equação CKD-EPI 2021).',
              ),
            ])
          else if (computed != null)
            div(classes: 'mini-calc-result', [
              .text(
                'eGFR calculado: ${_fmt(computed)} mL/min/1,73 m² '
                '(CKD-EPI 2021)',
              ),
            ]),
        ]),
      if (error != null) div(classes: 'field-error', [.text(error)]),
    ]);
  }

  Component _miniToggle({
    required String text,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return label(classes: 'mini-toggle', [
      input<bool>(
        type: InputType.checkbox,
        checked: value,
        onChange: (v) => onChanged(v),
      ),
      span(classes: 'mini-toggle-track', []),
      span(classes: 'mini-toggle-label', [.text(text)]),
    ]);
  }

  Component _buildAdvanced() {
    return div(classes: 'advanced span-2', [
      button(
        classes: 'advanced-toggle${_advancedOpen ? ' open' : ''}',
        attributes: {'aria-expanded': '$_advancedOpen'},
        onClick: () => setState(() => _advancedOpen = !_advancedOpen),
        [
          span(classes: 'advanced-chevron', []),
          .text('Dados opcionais (refinam o cálculo)'),
        ],
      ),
      if (_advancedOpen)
        div(classes: 'advanced-body', [
          _numField(
            key: 'hba1c',
            labelText: 'HbA1c (hemoglobina glicada)',
            unit: '%',
            value: _hba1c,
            placeholder: 'ex.: 5,7',
            onChanged: (v) => _hba1c = v,
          ),
          _numField(
            key: 'uacr',
            labelText: 'Relação albumina/creatinina urinária (UACR)',
            unit: 'mg/g',
            value: _uacr,
            placeholder: 'ex.: 12',
            onChanged: (v) => _uacr = v,
          ),
          p(classes: 'advanced-note', [
            .text(
              'O SDI (índice de privação social) não se aplica fora dos '
              'EUA e por isso não é usado aqui.',
            ),
          ]),
        ]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    final sexError = _showErrors ? _errors['sex'] : null;
    return section(id: 'calculadora', classes: 'calculator-section', [
      div(classes: 'glass calculator-card', [
        h2(classes: 'section-title', [.text('Calculadora')]),
        _buildEligibility(),
        if (_priorCvd == false) ...[
          div(classes: 'form-grid', [
            _numField(
              key: 'age',
              labelText: 'Idade',
              unit: 'anos (30–79)',
              value: _age,
              placeholder: 'ex.: 55',
              onChanged: (v) => _age = v,
            ),
            div(classes: 'field${sexError != null ? ' field-invalid' : ''}', [
              label(
                classes: 'field-label',
                attributes: const {'for': 'field-sex'},
                [.text('Sexo biológico')],
              ),
              select(
                classes: 'field-input',
                id: 'field-sex',
                value: switch (_sex) {
                  Sex.female => 'female',
                  Sex.male => 'male',
                  null => '',
                },
                onChange: (values) => setState(() {
                  _sex = switch (values.firstOrNull) {
                    'female' => Sex.female,
                    'male' => Sex.male,
                    _ => null,
                  };
                  _revalidate();
                }),
                [
                  option(value: '', disabled: true, [.text('Selecione…')]),
                  option(value: 'female', [.text('Feminino')]),
                  option(value: 'male', [.text('Masculino')]),
                ],
              ),
              if (sexError != null) div(classes: 'field-error', [.text(sexError)]),
            ]),
            _numField(
              key: 'sbp',
              labelText: 'Pressão arterial sistólica (PAS)',
              unit: 'mmHg (90–200)',
              value: _sbp,
              placeholder: 'ex.: 128',
              onChanged: (v) => _sbp = v,
            ),
            _numField(
              key: 'totalChol',
              labelText: 'Colesterol total',
              unit: 'mg/dL (130–320)',
              value: _totalChol,
              placeholder: 'ex.: 190',
              onChanged: (v) => _totalChol = v,
            ),
            _numField(
              key: 'hdl',
              labelText: 'HDL-colesterol',
              unit: 'mg/dL (20–100)',
              value: _hdl,
              placeholder: 'ex.: 50',
              onChanged: (v) => _hdl = v,
            ),
            _buildBmiBlock(),
            _buildEgfrBlock(),
            div(classes: 'switch-grid span-2', [
              _switch(
                text: 'Diabetes',
                value: _diabetes,
                onChanged: (v) => _diabetes = v,
              ),
              _switch(
                text: 'Tabagismo atual',
                value: _smoker,
                onChanged: (v) => _smoker = v,
              ),
              _switch(
                text: 'Uso de anti-hipertensivo',
                value: _onBpMed,
                onChanged: (v) => _onBpMed = v,
              ),
              _switch(
                text: 'Uso de estatina',
                value: _onStatin,
                onChanged: (v) => _onStatin = v,
              ),
            ]),
            _buildAdvanced(),
          ]),
          div(classes: 'submit-row', [
            button(
              classes: 'btn-primary',
              onClick: _submit,
              [.text('Calcular risco')],
            ),
          ]),
        ],
      ]),
    ]);
  }
}
