/// Versão servidor (pré-renderização): operação vazia.
void scrollToSection(String id) {}

/// Versão servidor (pré-renderização): operação vazia.
void scrollToTop() {}

/// Versão servidor (pré-renderização): não há scroll; devolve cancelador vazio.
void Function() watchScrollPast(String elementId, void Function(bool passed) onChange) {
  return () {};
}
