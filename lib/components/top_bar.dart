import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Barra do topo do hero: container centralizado na mesma largura do
/// conteúdo da /doc (880px), com o link 'documentação' (→ /doc) e o
/// ícone do GitHub alinhados à borda direita DO CONTEÚDO (não da tela).
///
/// Em telas estreitas (≤720px) os links colapsam num botão "hamburger"
/// (3 traços) que abre/fecha um dropdown em vidro com os mesmos itens;
/// o painel fecha ao clicar em um item. Em desktop a barra permanece
/// inline (ver `.top-bar` e `.top-bar-actions` em web/main.css).
class TopBar extends StatefulComponent {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  bool _menuOpen = false;

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);

  void _closeMenu() {
    if (_menuOpen) setState(() => _menuOpen = false);
  }

  /// Ícone/link do GitHub; quando [label] é informado (dropdown mobile)
  /// o texto aparece ao lado do ícone.
  Component _githubLink({required String classes, String? label}) {
    return a(
      classes: classes,
      href: 'https://github.com/mazieri/calculadora_aha',
      attributes: const {'aria-label': 'Repositório no GitHub'},
      [
        svg(
          viewBox: '0 0 24 24',
          width: 20.px,
          height: 20.px,
          attributes: const {
            'fill': 'currentColor',
            'aria-hidden': 'true',
            'focusable': 'false',
          },
          [
            path(
              d:
                  'M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 '
                  '11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04'
                  '-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 '
                  '17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 '
                  '1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998'
                  '.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466'
                  '-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105'
                  '-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 '
                  '1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23'
                  '.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 '
                  '0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 '
                  '1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 '
                  '22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12',
              [],
            ),
          ],
        ),
        if (label != null) .text(label),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    return nav(classes: 'top-bar', [
      // Desktop (≥721px): links inline, alinhados verticalmente.
      div(classes: 'top-bar-actions', [
        Link(
          to: '/doc',
          classes: 'top-bar-link',
          child: .text('documentação'),
        ),
        _githubLink(classes: 'top-bar-icon'),
      ]),
      // Mobile (≤720px): botão hamburger.
      button(
        classes: 'top-bar-menu-btn',
        attributes: {
          'aria-label': _menuOpen ? 'Fechar menu de navegação' : 'Abrir menu de navegação',
          'aria-expanded': _menuOpen ? 'true' : 'false',
        },
        onClick: _toggleMenu,
        [
          span(classes: 'top-bar-menu-line', []),
          span(classes: 'top-bar-menu-line', []),
          span(classes: 'top-bar-menu-line', []),
        ],
      ),
      // Dropdown mobile em vidro; o clique em qualquer item fecha o painel.
      if (_menuOpen)
        div(
          classes: 'top-bar-menu glass',
          events: {'click': (_) => _closeMenu()},
          [
            Link(
              to: '/doc',
              classes: 'top-bar-menu-link',
              child: .text('documentação'),
            ),
            _githubLink(
              classes: 'top-bar-menu-link top-bar-menu-github',
              label: 'GitHub',
            ),
          ],
        ),
    ]);
  }
}
