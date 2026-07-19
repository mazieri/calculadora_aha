import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/components/app_footer.dart';
import 'package:calculadora_aha/components/calculator_form.dart';
import 'package:calculadora_aha/components/hero_section.dart';
import 'package:calculadora_aha/components/results_section.dart';
import 'package:calculadora_aha/components/scroll_utils.dart';
import 'package:calculadora_aha/engine/prevent.dart';

/// Página única: hero + calculadora + resultados + rodapé.
///
/// O estado do resultado flui assim:
/// - [CalculatorForm] valida as entradas, chama `PreventCalculator.calculate`
///   e devolve o [PreventResult] via callback `onResult`;
/// - [Home] guarda o resultado no próprio estado e o repassa a
///   [ResultsSection], que só é renderizada quando há resultado;
/// - após cada cálculo a página rola suavemente até a seção de resultados.
class Home extends StatefulComponent {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  PreventResult? _result;

  void _onResult(PreventResult result) {
    setState(() => _result = result);
    // Espera o frame com os resultados ser renderizado antes de rolar.
    Future.delayed(const Duration(milliseconds: 80), () {
      scrollToSection('resultados');
    });
  }

  @override
  Component build(BuildContext context) {
    // A camada .heart-bg é fixa e fica atrás do conteúdo (ver web/heart.css);
    // .page-content tem z-index: 1 (ver web/main.css).
    return div([
      div(
        classes: 'heart-bg',
        attributes: {'aria-hidden': 'true'},
        [
          // Fallback SVG — nasce escondido (display:none em web/heart.css)
          // e só reaparece se o heart3d.js sinalizar falha no WebGL,
          // adicionando a classe 'heart3d-failed' ao <body>.
          img(classes: 'heart-bg__fallback', src: 'assets/heart.svg', alt: ''),
        ],
      ),
      div(classes: 'page-content', [
        const HeroSection(),
        CalculatorForm(onResult: _onResult),
        if (_result != null) ResultsSection(result: _result!),
        const AppFooter(),
      ]),
    ]);
  }
}
