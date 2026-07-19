import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Barra superior da página /doc: link 'calculadora' (→ /) à esquerda e
/// seletor de idioma 'pt-br/original' à direita.
class DocTopBar extends StatelessComponent {
  const DocTopBar({
    required this.showOriginal,
    required this.onToggle,
    super.key,
  });

  /// `true` quando o idioma exibido é o original em inglês.
  final bool showOriginal;

  /// Chamado quando o usuário escolhe outro idioma.
  final void Function(bool showOriginal) onToggle;

  @override
  Component build(BuildContext context) {
    return header(classes: 'doc-topbar', [
      div(classes: 'doc-topbar-inner', [
        Link(
          to: '/',
          classes: 'doc-topbar-home',
          child: .text('← calculadora'),
        ),
        div(
          classes: 'lang-toggle',
          attributes: const {'role': 'group', 'aria-label': 'Idioma do conteúdo'},
          [
            button(
              classes: 'lang-option${showOriginal ? '' : ' active'}',
              attributes: const {'type': 'button', 'aria-label': 'Ver em português (pt-BR)'},
              onClick: () => onToggle(false),
              [.text('pt-br')],
            ),
            button(
              classes: 'lang-option${showOriginal ? ' active' : ''}',
              attributes: const {'type': 'button', 'aria-label': 'Ver original em inglês'},
              onClick: () => onToggle(true),
              [.text('original')],
            ),
          ],
        ),
      ]),
    ]);
  }
}
