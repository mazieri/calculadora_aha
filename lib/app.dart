import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/doc.dart';
import 'pages/home.dart';

/// Componente raiz da aplicação.
///
/// A anotação @client faz com que o componente seja compilado para JavaScript
/// e montado no cliente: ele é pré-renderizado no servidor (modo static) e
/// depois hidratado no navegador.
///
/// Roteamento single-page (client-side): o [Router] fica dentro da árvore
/// renderizada no cliente (abaixo do @client), conforme a documentação do
/// jaspr_router. No build estático, cada rota é pré-renderizada em seu
/// próprio HTML (`/` → index.html, `/doc` → doc/index.html).
@client
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        Route(path: '/', builder: (context, state) => const Home()),
        Route(
          path: '/doc',
          title: 'Documentação — Calculadora PREVENT™ pt-BR (educacional)',
          builder: (context, state) => const Doc(),
        ),
      ],
    );
  }
}
