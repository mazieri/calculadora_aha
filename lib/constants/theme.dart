import 'package:jaspr/dom.dart';

/// Estilos globais injetados via Jaspr.
///
/// Intencionalmente vazio: a tipografia e o reset de `html`/`body` vivem em
/// `web/main.css`. Este getter existe apenas porque o arquivo gerado
/// `main.server.options.dart` referencia `_theme.styles`.
@css
List<StyleRule> get styles => const [];
