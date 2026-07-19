import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/content/doc_content.dart';

import 'scroll_utils.dart';
import 'top_bar.dart';

/// Seção hero em tela cheia: barra superior (documentação + GitHub),
/// título, subtítulo educacional com link oficial e chevron de scroll
/// suave até a calculadora.
class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(id: 'hero', classes: 'hero', [
      const TopBar(),
      div(classes: 'hero-inner glass', [
        h1(classes: 'hero-title', [
          .text('Calculadora Online PREVENT™ da American Heart Association'),
        ]),
        p(classes: 'hero-subtitle', [
          .text(
            'Projeto totalmente educacional e não oficial — somente uma '
            'tradução para o português (pt-BR) da calculadora original.',
          ),
        ]),
        a(
          classes: 'hero-link',
          href: officialCalculatorUrl,
          target: Target.blank,
          attributes: const {'rel': 'noopener'},
          [.text('Acesse a versão oficial no site da AHA ↗')],
        ),
      ]),
      button(
        classes: 'scroll-chevron',
        attributes: const {'aria-label': 'Rolar até a calculadora'},
        onClick: () => scrollToSection('calculadora'),
        [span(classes: 'chevron-icon', [])],
      ),
    ]);
  }
}
