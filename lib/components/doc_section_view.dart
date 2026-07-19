import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/components/scroll_utils.dart';
import 'package:calculadora_aha/content/doc_content.dart';

/// Renderiza uma [DocSection] no idioma escolhido (pt-BR ou original).
class DocSectionView extends StatelessComponent {
  const DocSectionView({
    required this.data,
    required this.showOriginal,
    super.key,
  });

  final DocSection data;

  /// `true` exibe o original em inglês; `false` exibe a tradução pt-BR.
  final bool showOriginal;

  String _t(DocText text) => showOriginal ? text.en : text.pt;

  @override
  Component build(BuildContext context) {
    return section(id: data.id, classes: 'doc-section glass', [
      h2(classes: 'doc-section-title', [
        .text(_t(data.title)),
        // Voltar ao topo — visível só no mobile (CSS ≤720px), na borda
        // oposta ao título.
        button(
          classes: 'doc-section-top-btn',
          attributes: {'type': 'button', 'aria-label': _t(docTextBackToTop)},
          onClick: scrollToTop,
          [.text('↑')],
        ),
      ]),
      for (final block in data.blocks)
        if (block.isBullets)
          ul(classes: 'doc-list', [
            for (final item in block.bullets) li([.text(_t(item))]),
          ])
        else
          p(classes: 'doc-paragraph', [.text(_t(block.paragraph!))]),
    ]);
  }
}
