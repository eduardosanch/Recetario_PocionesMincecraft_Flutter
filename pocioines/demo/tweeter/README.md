# tweeter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Refactorización aplicada

La carpeta `lib/` fue reorganizada para separar responsabilidades y reducir el acoplamiento entre UI, servicios y parseo de respuestas.

Patrones usados:

- Factory: `AppServiceFactory` centraliza la creación de dependencias de la app.
- Facade: `LibraryFacade` unifica autenticación y operaciones sobre libros detrás de una sola interfaz.
- Adapter: `BookResponseAdapter` normaliza respuestas del backend antes de convertirlas a modelos de dominio.

Cambios principales:

- `main.dart` quedó solo como punto de arranque y configuración de rutas.
- `HomeScreen` pasó a su propio archivo y contiene la lógica visual de libros.
- `LoginScreen` usa la fachada en lugar de instanciar servicios directamente.
- `BookService` y `BookPostResponse` delegan el parseo de respuestas al adaptador.
