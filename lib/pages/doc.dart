import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'package:calculadora_aha/components/app_footer.dart';
import 'package:calculadora_aha/components/doc_section_view.dart';
import 'package:calculadora_aha/components/doc_top_bar.dart';
import 'package:calculadora_aha/components/scroll_utils.dart';
import 'package:calculadora_aha/content/doc_content.dart';

/// Página /doc — documentação oficial da calculadora PREVENT™ da AHA,
/// com o original em inglês e tradução educacional pt-BR.
///
/// O conteúdo vem de `lib/content/doc_content.dart`; o idioma exibido é
/// controlado pelo seletor 'pt-br/original' na barra superior
/// (padrão: pt-BR).
class Doc extends StatefulComponent {
  const Doc({super.key});

  @override
  State<Doc> createState() => DocState();
}

class DocState extends State<Doc> {
  /// `false` = pt-BR (padrão); `true` = original em inglês.
  bool _showOriginal = false;

  /// `true` quando o usuário já rolou além do menu de seleção (índice).
  bool _showBackToTop = false;

  /// Cancela a observação de scroll (ver `initState`/`dispose`).
  void Function()? _cancelScrollSpy;

  String _t(DocText text) => _showOriginal ? text.en : text.pt;

  @override
  void initState() {
    super.initState();
    _cancelScrollSpy = watchScrollPast('doc-toc', (passed) {
      if (passed != _showBackToTop) {
        setState(() => _showBackToTop = passed);
      }
    });
  }

  @override
  void dispose() {
    _cancelScrollSpy?.call();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div([
      // Mesma camada de fundo da home (ver web/heart.css).
      div(
        classes: 'heart-bg',
        attributes: {'aria-hidden': 'true'},
        [
          img(classes: 'heart-bg__fallback', src: 'assets/heart.svg', alt: ''),
        ],
      ),
      div(classes: 'page-content', [
        DocTopBar(
          showOriginal: _showOriginal,
          onToggle: (value) => setState(() => _showOriginal = value),
        ),
        main_(classes: 'doc-main', [
          // ---------- Cabeçalho + aviso de tradução ----------
          header(classes: 'doc-header glass', [
            h1(classes: 'doc-title', [
              .text(
                _t(
                  const DocText(
                    'PREVENT™ Calculator — Official Documentation',
                    'Calculadora PREVENT™ — Documentação oficial',
                  ),
                ),
              ),
            ]),
            p(classes: 'doc-subtitle', [
              .text(
                _t(
                  const DocText(
                    'Explanatory content published by the American Heart '
                        'Association (AHA) about the PREVENT™ risk calculator.',
                    'Conteúdo explicativo publicado pela American Heart '
                        'Association (AHA) sobre a calculadora de risco PREVENT™.',
                  ),
                ),
              ),
            ]),
            div(classes: 'doc-disclaimer', [
              p(classes: 'doc-disclaimer-text', [
                strong([
                  .text(
                    _t(
                      const DocText(
                        'Unofficial educational translation. ',
                        'Tradução educacional não oficial. ',
                      ),
                    ),
                  ),
                ]),
                .text(_t(docAttribution)),
              ]),
              p(classes: 'doc-disclaimer-access', [
                strong([
                  .text(
                    _t(
                      const DocText(
                        'Accessed on: July 18, 2026',
                        'Acesso em: 18 de julho de 2026',
                      ),
                    ),
                  ),
                ]),
              ]),
              a(
                classes: 'doc-disclaimer-link',
                href: officialCalculatorUrl,
                target: Target.blank,
                attributes: const {'rel': 'noopener'},
                [
                  .text(
                    _t(
                      const DocText(
                        'Go to the official AHA page ↗',
                        'Acesse a página oficial da AHA ↗',
                      ),
                    ),
                  ),
                ],
              ),
            ]),
            // ---------- Índice (âncoras da própria página) ----------
            nav(id: 'doc-toc', classes: 'doc-toc', [
              for (final s in docSections)
                button(
                  classes: 'doc-toc-chip',
                  attributes: {'type': 'button', 'aria-label': _t(s.title)},
                  onClick: () => scrollToSection(s.id),
                  [.text(_t(s.title))],
                ),
              button(
                classes: 'doc-toc-chip',
                attributes: {'type': 'button', 'aria-label': _t(docTextSources)},
                onClick: () => scrollToSection('fontes'),
                [.text(_t(docTextSources))],
              ),
            ]),
          ]),

          // ---------- Seções do conteúdo ----------
          for (final s in docSections) DocSectionView(data: s, showOriginal: _showOriginal),

          // ---------- Fontes ----------
          section(id: 'fontes', classes: 'doc-section glass', [
            h2(classes: 'doc-section-title', [
              .text(_t(docTextSources)),
              // Voltar ao topo — visível só no mobile (CSS ≤720px).
              button(
                classes: 'doc-section-top-btn',
                attributes: {'type': 'button', 'aria-label': _t(docTextBackToTop)},
                onClick: scrollToTop,
                [.text('↑')],
              ),
            ]),
            ul(classes: 'doc-list doc-sources', [
              for (final source in docSources)
                li([
                  if (source.url != null)
                    a(
                      href: source.url!,
                      target: Target.blank,
                      attributes: const {'rel': 'noopener'},
                      [.text(_t(source.label))],
                    )
                  else
                    .text(_t(source.label)),
                ]),
            ]),
          ]),
        ]),
        const AppFooter(),
      ]),
      // ---------- Voltar ao topo (desktop: seta fixa à direita) ----------
      // Só aparece depois de rolar além do menu de seleção (índice);
      // no mobile o CSS o esconde — lá existem os botões "↑" nos títulos.
      if (_showBackToTop)
        button(
          classes: 'back-to-top',
          attributes: {'type': 'button', 'aria-label': _t(docTextBackToTop)},
          onClick: scrollToTop,
          [span(classes: 'chevron-icon--up', [])],
        ),
    ]);
  }
}
