/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [Document] renders the root document structure (<html>, <head> and <body>)
  // with the provided parameters and components.
  runApp(
    Document(
      title: 'CALC AHA PT-BR',
      lang: 'pt-BR',
      base: Platform.environment['BASE_HREF'] ?? '/',
      meta: const {
        'description':
            'Projeto educacional e não oficial: tradução para o português da '
            'calculadora PREVENT™ da American Heart Association — estimativa de '
            'risco cardiovascular em 10 e 30 anos.',
      },
      head: [
        link(rel: 'stylesheet', href: 'main.css'),
        link(rel: 'stylesheet', href: 'heart.css'),
        link(rel: 'icon', type: 'image/svg+xml', href: 'images/coracao.svg'),
        // Import map do three.js
        const script(
          attributes: {'type': 'importmap'},
          content: '{"imports":{"three":"./assets/3d/three.module.min.js"}}',
        ),
        // Coração 3D de fundo (fallback para o SVG é automático).
        const script(
          src: 'heart3d.js',
          attributes: {'type': 'module'},
        ),
      ],
      body: App(),
    ),
  );
}
