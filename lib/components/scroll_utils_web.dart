import 'dart:js_interop';

import 'package:web/web.dart';

/// Versão cliente: rola suavemente até o elemento com o [id] informado.
void scrollToSection(String id) {
  document.getElementById(id)?.scrollIntoView(ScrollIntoViewOptions(behavior: 'smooth', block: 'start'));
}

/// Versão cliente: rola suavemente de volta ao topo da página.
void scrollToTop() {
  window.scrollTo(ScrollToOptions(top: 0, behavior: 'smooth'));
}

/// Observa o scroll e dispara [onChange] sempre que o estado "já rolei
/// além do fim do elemento [elementId]" mudar. Retorna a função que
/// cancela a observação (chamar em `dispose`).
///
/// Se o elemento não existir, considera que nunca foi ultrapassado.
void Function() watchScrollPast(String elementId, void Function(bool passed) onChange) {
  bool? last;

  void check() {
    final el = document.getElementById(elementId);
    // bottom < 0 => a base do elemento já saiu pelo topo da viewport.
    final passed = el != null && el.getBoundingClientRect().bottom < 0;
    if (passed != last) {
      last = passed;
      onChange(passed);
    }
  }

  final listener = ((Event _) => check()).toJS;
  window.addEventListener('scroll', listener);
  check(); // estado inicial (ex.: recarregar com a página já rolada)

  return () => window.removeEventListener('scroll', listener);
}
