import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/content/doc_content.dart';

/// Rodapé: disclaimer, fontes científicas e link para a calculadora oficial.
class AppFooter extends StatelessComponent {
  const AppFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'app-footer', [
      div(classes: 'glass footer-card', [
        p(classes: 'footer-disclaimer', [
          strong([
            .text('Ferramenta educacional e não oficial. '),
          ]),
          .text(
            'Esta página é apenas uma tradução para o português (pt-BR) '
            'da calculadora PREVENT da American Heart Association, sem '
            'qualquer afiliação com a AHA. Os resultados são estimativas '
            'validadas para pessoas de 30 a 79 anos sem doença '
            'cardiovascular prévia e não substituem a avaliação de um '
            'profissional de saúde.',
          ),
        ]),
        div(classes: 'footer-sources', [
          p(classes: 'footer-sources-title', [.text('Fontes')]),
          ul([
            li([
              .text(
                'Khan SS, et al. Development and Validation of the '
                'American Heart Association’s PREVENT Equations. ',
              ),
              em([.text('Circulation')]),
              .text(', 2024. DOI: '),
              a(
                href: 'https://doi.org/10.1161/CIRCULATIONAHA.123.067626',
                target: Target.blank,
                attributes: const {'rel': 'noopener'},
                [.text('10.1161/CIRCULATIONAHA.123.067626')],
              ),
              .text('.'),
            ]),
            li([
              .text(
                'Inker LA, et al. New Creatinine- and Cystatin C–Based '
                'Equations to Estimate GFR without Race (CKD-EPI 2021). ',
              ),
              em([.text('New England Journal of Medicine')]),
              .text(', 2021.'),
            ]),
            li([
              .text(
                'Modelo 3D do coração: Human Reference Atlas '
                '(HuBMAP Consortium / CNS, Indiana University), a partir '
                'de dados do NIH Visible Human Project — licença CC BY 4.0. ',
              ),
              a(
                href: 'https://humanatlas.io/3d-reference-library',
                target: Target.blank,
                attributes: const {'rel': 'noopener'},
                [.text('humanatlas.io/3d-reference-library')],
              ),
            ]),
          ]),
        ]),
        a(
          classes: 'footer-official-link',
          href: officialCalculatorUrl,
          target: Target.blank,
          attributes: const {'rel': 'noopener'},
          [.text('Acesse a calculadora oficial no site da AHA ↗')],
        ),
      ]),
      p(classes: 'footer-signature', [.text('feito por Felipe Mazieri | 2026')]),
    ]);
  }
}
