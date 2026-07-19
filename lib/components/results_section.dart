import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/engine/prevent.dart';

/// Seção de resultados: destaque para DCV total em 10 anos, cards menores
/// para ASCVD e IC (10 anos) e bloco separado com os horizontes de 30 anos
/// (somente quando presentes no resultado — idade ≤ 59).
class ResultsSection extends StatelessComponent {
  const ResultsSection({required this.result, super.key});

  final PreventResult result;

  static String _fmtPercent(double v) => '${v.toStringAsFixed(1).replaceAll('.', ',')}%';

  static String _categoryLabel(RiskCategory? category) {
    return switch (category) {
      RiskCategory.low => 'Baixo',
      RiskCategory.borderline => 'Limítrofe',
      RiskCategory.intermediate => 'Intermediário',
      RiskCategory.high => 'Alto',
      null => '',
    };
  }

  static String _categoryClass(RiskCategory? category) {
    return switch (category) {
      RiskCategory.low => 'cat-low',
      RiskCategory.borderline => 'cat-borderline',
      RiskCategory.intermediate => 'cat-intermediate',
      RiskCategory.high => 'cat-high',
      null => '',
    };
  }

  Component _riskCard({
    required String title,
    required RiskEstimate estimate,
    required String description,
    bool highlight = false,
  }) {
    final catClass = _categoryClass(estimate.category);
    final catLabel = _categoryLabel(estimate.category);
    return div(classes: 'risk-card${highlight ? ' risk-highlight' : ''}', [
      h3(classes: 'risk-title', [.text(title)]),
      div(classes: 'risk-percent $catClass', [.text(_fmtPercent(estimate.percent))]),
      if (estimate.category != null) span(classes: 'risk-category $catClass', [.text(catLabel)]),
      p(classes: 'risk-desc', [.text(description)]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return section(id: 'resultados', classes: 'results-section', [
      div(classes: 'glass results-card', [
        h2(classes: 'section-title', [.text('Seus resultados')]),
        p(classes: 'results-intro', [
          .text(
            'Estimativas de risco calculadas pelas equações PREVENT da '
            'American Heart Association.',
          ),
        ]),

        // --- Horizonte de 10 anos ---
        div(classes: 'risk-grid', [
          _riskCard(
            title: 'Risco de DCV total em 10 anos',
            estimate: result.cvd10,
            description:
                'Probabilidade de doença cardiovascular total '
                '(infarto, AVC ou insuficiência cardíaca) nos próximos 10 anos.',
            highlight: true,
          ),
          _riskCard(
            title: 'ASCVD em 10 anos',
            estimate: result.ascvd10,
            description:
                'Probabilidade de doença cardiovascular '
                'aterosclerótica (infarto ou AVC) nos próximos 10 anos.',
          ),
          _riskCard(
            title: 'Insuficiência cardíaca em 10 anos',
            estimate: result.hf10,
            description:
                'Probabilidade de desenvolver insuficiência '
                'cardíaca nos próximos 10 anos.',
          ),
        ]),

        p(classes: 'results-note', [
          .text(
            'A guideline de hipertensão 2025 AHA/ACC considera risco '
            'aumentado quando DCV total em 10 anos ≥ 7,5%.',
          ),
        ]),

        // --- Horizonte de 30 anos (só quando disponível) ---
        if (result.cvd30 != null && result.ascvd30 != null && result.hf30 != null) ...[
          h3(classes: 'section-subtitle', [
            .text('Horizonte de 30 anos'),
          ]),
          div(classes: 'risk-grid', [
            _riskCard(
              title: 'DCV total em 30 anos',
              estimate: result.cvd30!,
              description:
                  'Probabilidade de doença cardiovascular total '
                  'nos próximos 30 anos.',
            ),
            _riskCard(
              title: 'ASCVD em 30 anos',
              estimate: result.ascvd30!,
              description:
                  'Probabilidade de doença cardiovascular '
                  'aterosclerótica nos próximos 30 anos.',
            ),
            _riskCard(
              title: 'Insuficiência cardíaca em 30 anos',
              estimate: result.hf30!,
              description:
                  'Probabilidade de desenvolver insuficiência '
                  'cardíaca nos próximos 30 anos.',
            ),
          ]),
        ],

        // --- Disclaimer ---
        div(classes: 'results-disclaimer', [
          p([
            .text(
              'Ferramenta educacional. Não substitui avaliação médica. '
              'As equações PREVENT foram validadas para pessoas de 30 a 79 '
              'anos sem doença cardiovascular prévia.',
            ),
          ]),
          p([
            .text(
              'Os resultados são estimativas populacionais e não '
              'representam um diagnóstico individual. Qualquer decisão '
              'sobre prevenção ou tratamento deve ser tomada em conjunto '
              'com um profissional de saúde.',
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
