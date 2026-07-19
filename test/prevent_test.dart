/// Testes do motor de cálculo PREVENT.
///
/// Gabarito: vetores publicados do pacote CRAN `preventr`
/// (https://github.com/martingmayer/preventr, tests/testthat/test-estimate_risk.R),
/// que são validados contra a calculadora oficial da AHA. Os valores
/// esperados abaixo estão em percentual (0-100), computados com os
/// coeficientes oficiais em precisão total e conferidos contra os valores
/// arredondados publicados (ex.: 0.147 -> 14.7%).
///
/// Inputs-base dos vetores (idênticos aos do helper `estimate_risk_partial`
/// do preventr): idade 50, PAS 160, em uso de anti-hipertensivo, CT 200,
/// HDL 45, sem estatina, com diabetes, não fumante, eGFR 90, IMC 35.
///
/// Tolerância: ±0.1 p.p. — as diferenças reais ficam < 0.01 p.p.
library;

import 'package:calculadora_aha/engine/prevent.dart';
import 'package:test/test.dart';

/// Tolerância de ±0.1 p.p. em torno do valor esperado.
Matcher closePercent(double expected) => closeTo(expected, 0.1);

PreventInput baseInput({
  Sex sex = Sex.female,
  int age = 50,
  double? hba1c,
  double? uacr,
}) {
  return PreventInput(
    age: age,
    sex: sex,
    sbp: 160,
    totalChol: 200,
    hdl: 45,
    egfr: 90,
    bmi: 35,
    diabetes: true,
    smoker: false,
    onBpMed: true,
    onStatin: false,
    hba1c: hba1c,
    uacr: uacr,
  );
}

void expectEstimate(
  RiskEstimate estimate,
  double expectedPercent,
  RiskCategory? expectedCategory,
) {
  expect(estimate.percent, closePercent(expectedPercent));
  expect(estimate.category, expectedCategory);
}

void main() {
  group('Vetores gabarito do preventr (modelo base)', () {
    test('mulher, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput());
      expect(r.modelUsed, 'base');
      expectEstimate(r.cvd10, 14.7, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 9.2, RiskCategory.intermediate);
      expectEstimate(r.hf10, 8.1, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 53.0, null);
      expectEstimate(r.ascvd30!, 35.4, null);
      expectEstimate(r.hf30!, 39.0, null);
    });

    test('homem, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(sex: Sex.male));
      expect(r.modelUsed, 'base');
      expectEstimate(r.cvd10, 16.3, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 10.2, RiskCategory.intermediate);
      expectEstimate(r.hf10, 10.6, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 51.4, null);
      expectEstimate(r.ascvd30!, 34.9, null);
      expectEstimate(r.hf30!, 42.4, null);
    });
  });

  group('Vetores gabarito do preventr (modelo +HbA1c)', () {
    test('mulher, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(hba1c: 9.2));
      expect(r.modelUsed, 'hba1c');
      expectEstimate(r.cvd10, 16.5, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 10.3, RiskCategory.intermediate);
      expectEstimate(r.hf10, 10.7, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 54.1, null);
      expectEstimate(r.ascvd30!, 35.6, null);
      expectEstimate(r.hf30!, 44.9, null);
    });

    test('homem, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(sex: Sex.male, hba1c: 9.2));
      expect(r.modelUsed, 'hba1c');
      expectEstimate(r.cvd10, 18.7, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 11.2, RiskCategory.intermediate);
      expectEstimate(r.hf10, 13.0, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 52.4, null);
      expectEstimate(r.ascvd30!, 34.0, null);
      expectEstimate(r.hf30!, 45.7, null);
    });
  });

  group('Vetores gabarito do preventr (modelo +UACR)', () {
    test('mulher, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(uacr: 92));
      expect(r.modelUsed, 'uacr');
      expectEstimate(r.cvd10, 18.1, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 11.1, RiskCategory.intermediate);
      expectEstimate(r.hf10, 10.5, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 56.5, null);
      expectEstimate(r.ascvd30!, 38.1, null);
      expectEstimate(r.hf30!, 43.7, null);
    });

    test('homem, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(sex: Sex.male, uacr: 92));
      expect(r.modelUsed, 'uacr');
      expectEstimate(r.cvd10, 19.5, RiskCategory.intermediate);
      expectEstimate(r.ascvd10, 12.3, RiskCategory.intermediate);
      expectEstimate(r.hf10, 13.0, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 53.5, null);
      expectEstimate(r.ascvd30!, 36.8, null);
      expectEstimate(r.hf30!, 44.8, null);
    });
  });

  group('Vetores gabarito (modelo completo HbA1c+UACR, SDI ausente)', () {
    // O app não coleta CEP/SDI: no modelo completo o SDI entra como
    // "ausente" (termo missing SDI = 1). Valores gerados com os
    // coeficientes oficiais após validação integral do pipeline contra
    // todos os vetores publicados do preventr (base/hba1c/uacr/full).
    test('mulher, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(baseInput(hba1c: 9.2, uacr: 92));
      expect(r.modelUsed, 'full');
      expectEstimate(r.cvd10, 20.2, RiskCategory.high);
      expectEstimate(r.ascvd10, 12.1, RiskCategory.intermediate);
      expectEstimate(r.hf10, 13.4, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 57.3, null);
      expectEstimate(r.ascvd30!, 37.8, null);
      expectEstimate(r.hf30!, 48.0, null);
    });

    test('homem, 10 e 30 anos', () {
      final r = PreventCalculator.calculate(
        baseInput(sex: Sex.male, hba1c: 9.2, uacr: 92),
      );
      expect(r.modelUsed, 'full');
      expectEstimate(r.cvd10, 21.5, RiskCategory.high);
      expectEstimate(r.ascvd10, 12.6, RiskCategory.intermediate);
      expectEstimate(r.hf10, 15.2, RiskCategory.intermediate);
      expectEstimate(r.cvd30!, 53.5, null);
      expectEstimate(r.ascvd30!, 34.4, null);
      expectEstimate(r.hf30!, 46.4, null);
    });
  });

  group('Seleção de modelo', () {
    test('sem opcionais -> base', () {
      expect(PreventCalculator.calculate(baseInput()).modelUsed, 'base');
    });

    test('somente HbA1c -> hba1c', () {
      expect(PreventCalculator.calculate(baseInput(hba1c: 7.0)).modelUsed, 'hba1c');
    });

    test('somente UACR -> uacr', () {
      expect(PreventCalculator.calculate(baseInput(uacr: 30)).modelUsed, 'uacr');
    });

    test('HbA1c + UACR -> full', () {
      expect(PreventCalculator.calculate(baseInput(hba1c: 7.0, uacr: 30)).modelUsed, 'full');
    });

    test('HbA1c fora da faixa (4.5-15) é descartada -> base', () {
      expect(PreventCalculator.calculate(baseInput(hba1c: 20)).modelUsed, 'base');
      expect(PreventCalculator.calculate(baseInput(hba1c: 4.0)).modelUsed, 'base');
    });

    test('UACR fora da faixa (0.1-25000) é descartada -> hba1c', () {
      expect(PreventCalculator.calculate(baseInput(hba1c: 7.0, uacr: 0)).modelUsed, 'hba1c');
      expect(PreventCalculator.calculate(baseInput(hba1c: 7.0, uacr: 30000)).modelUsed, 'hba1c');
    });
  });

  group('Regra do horizonte de 30 anos (somente idade <= 59)', () {
    test('idade 59 -> estimativas de 30 anos presentes', () {
      final r = PreventCalculator.calculate(baseInput(age: 59));
      expect(r.cvd30, isNotNull);
      expect(r.ascvd30, isNotNull);
      expect(r.hf30, isNotNull);
    });

    test('idade 60 -> estimativas de 30 anos nulas', () {
      final r = PreventCalculator.calculate(baseInput(age: 60));
      expect(r.cvd30, isNull);
      expect(r.ascvd30, isNull);
      expect(r.hf30, isNull);
    });

    test('idade 79 -> estimativas de 30 anos nulas', () {
      final r = PreventCalculator.calculate(baseInput(age: 79));
      expect(r.cvd30, isNull);
    });
  });

  group('Clamping dos inputs nos ranges oficiais', () {
    double cvd10(PreventInput i) => PreventCalculator.calculate(i).cvd10.percent;

    test('idade abaixo de 30 é clampada para 30', () {
      expect(cvd10(baseInput(age: 25)), closeTo(cvd10(baseInput(age: 30)), 1e-9));
    });

    test('PAS acima de 200 é clampada para 200', () {
      final a = baseInput();
      final b = PreventInput(
        age: 50,
        sex: Sex.female,
        sbp: 250,
        totalChol: 200,
        hdl: 45,
        egfr: 90,
        bmi: 35,
        diabetes: true,
        onBpMed: true,
      );
      final c = PreventInput(
        age: 50,
        sex: Sex.female,
        sbp: 200,
        totalChol: 200,
        hdl: 45,
        egfr: 90,
        bmi: 35,
        diabetes: true,
        onBpMed: true,
      );
      expect(cvd10(a), isNotNaN);
      expect(cvd10(b), closeTo(cvd10(c), 1e-9));
    });

    test('CT, HDL, eGFR e IMC fora da faixa são clampados', () {
      final clamped = PreventInput(
        age: 50,
        sex: Sex.male,
        sbp: 130,
        totalChol: 130,
        hdl: 20,
        egfr: 15,
        bmi: 15,
      );
      final beyond = PreventInput(
        age: 50,
        sex: Sex.male,
        sbp: 130,
        totalChol: 100,
        hdl: 10,
        egfr: 5,
        bmi: 5,
      );
      final clampedHigh = PreventInput(
        age: 50,
        sex: Sex.male,
        sbp: 130,
        totalChol: 320,
        hdl: 100,
        egfr: 140,
        bmi: 60,
      );
      final beyondHigh = PreventInput(
        age: 50,
        sex: Sex.male,
        sbp: 130,
        totalChol: 400,
        hdl: 150,
        egfr: 200,
        bmi: 90,
      );
      expect(cvd10(beyond), closeTo(cvd10(clamped), 1e-9));
      expect(cvd10(beyondHigh), closeTo(cvd10(clampedHigh), 1e-9));
    });
  });

  group('Categorias de risco (somente 10 anos)', () {
    test('perfil de baixo risco -> low em todos os desfechos', () {
      final r = PreventCalculator.calculate(
        const PreventInput(
          age: 35,
          sex: Sex.female,
          sbp: 110,
          totalChol: 170,
          hdl: 60,
          egfr: 100,
          bmi: 22,
        ),
      );
      expect(r.cvd10.percent, lessThan(5));
      expect(r.cvd10.category, RiskCategory.low);
      expect(r.ascvd10.category, RiskCategory.low);
      expect(r.hf10.category, RiskCategory.low);
    });

    test('perfil borderline (cvd10 ~5.2%)', () {
      final r = PreventCalculator.calculate(
        const PreventInput(
          age: 60,
          sex: Sex.female,
          sbp: 130,
          totalChol: 200,
          hdl: 50,
          egfr: 90,
          bmi: 27,
        ),
      );
      expect(r.cvd10.percent, closePercent(5.2));
      expect(r.cvd10.category, RiskCategory.borderline);
      expect(r.ascvd10.category, RiskCategory.low);
    });

    test('perfil de alto risco -> high', () {
      final r = PreventCalculator.calculate(
        const PreventInput(
          age: 70,
          sex: Sex.male,
          sbp: 170,
          totalChol: 260,
          hdl: 35,
          egfr: 45,
          bmi: 33,
          diabetes: true,
          smoker: true,
          onBpMed: true,
        ),
      );
      expect(r.cvd10.percent, greaterThan(20));
      expect(r.cvd10.category, RiskCategory.high);
    });
  });

  group('eGFR CKD-EPI 2021 (creatinina, race-free)', () {
    test('valores de referência', () {
      expect(
        PreventCalculator.egfrCkdEpi2021(creatinine: 1.0, age: 60, sex: Sex.female),
        closeTo(64.50, 0.1),
      );
      expect(
        PreventCalculator.egfrCkdEpi2021(creatinine: 1.0, age: 60, sex: Sex.male),
        closeTo(86.16, 0.1),
      );
      expect(
        PreventCalculator.egfrCkdEpi2021(creatinine: 0.7, age: 40, sex: Sex.female),
        closeTo(112.05, 0.1),
      );
      expect(
        PreventCalculator.egfrCkdEpi2021(creatinine: 1.5, age: 70, sex: Sex.male),
        closeTo(49.77, 0.1),
      );
      expect(
        PreventCalculator.egfrCkdEpi2021(creatinine: 0.5, age: 30, sex: Sex.female),
        closeTo(129.32, 0.1),
      );
    });
  });

  group('IMC', () {
    test('70 kg / 175 cm = 22.86 kg/m²', () {
      expect(
        PreventCalculator.bmi(weightKg: 70, heightCm: 175),
        closeTo(22.857, 0.01),
      );
    });

    test('100 kg / 180 cm = 30.86 kg/m²', () {
      expect(
        PreventCalculator.bmi(weightKg: 100, heightCm: 180),
        closeTo(30.864, 0.01),
      );
    });
  });
}
