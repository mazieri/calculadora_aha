/// Rola suavemente até o elemento com o [id] informado.
///
/// Implementação condicional: no servidor (pré-renderização) é uma operação
/// vazia (stub); no cliente usa `package:web`.
library;

export 'scroll_utils_stub.dart' if (dart.library.js_interop) 'scroll_utils_web.dart';
