# Práctica Desarrollo de Aplicaciones Básicas - Control de notas

Aplicación Flutter para registrar estudiantes, calcular su nota definitiva con cuatro porcentajes y consultar el resumen del grupo. Está construida con Material 3, funciona en Android y web, y no requiere paquetes externos de estado.

## Cómo ejecutar

Requisitos: Flutter instalado y configurado para Android o web.

```bash
flutter pub get
flutter run
```

Para elegir un destino, por ejemplo, ejecuta `flutter run -d chrome` para web o `flutter run -d <id_dispositivo>` para Android. Las verificaciones automatizadas se ejecutan con:

```bash
flutter analyze
flutter test
```

## Arquitectura

- `lib/main.dart`: configura Material 3, el tema y la pantalla inicial.
- `lib/models/estudiante.dart`: clase `Estudiante`; encapsula el nombre y las notas, expone getters, calcula la definitiva con un ciclo `for` y la variable `acumulador`, y ofrece el getter `aprobo`. Los pesos están en `porcentajes` y suman 100%.
- `lib/models/control_notas.dart`: clase `ControlNotas`; mantiene encapsulada la lista, permite agregar y eliminar estudiantes y expone total, aprobados, promedio y contador de reprobados. El getter `contadorReprobados` aumenta explícitamente `contador` por cada definitiva menor que 3.0.
- `lib/utils/validador_notas.dart`: clase `ValidadorNotas`; valida campos vacíos, texto no numérico y el rango inclusivo de 0 a 5. Convierte coma decimal a punto.
- `lib/screens/pantalla_ingreso.dart`: formulario validado con `Form` y `TextFormField`, captura de notas, lista y eliminación de estudiantes. El estado de la pantalla se actualiza con `setState`.
- `lib/screens/pantalla_resultados.dart`: resumen con total, aprobados, reprobados y promedio del grupo.
- `test/control_notas_test.dart`: pruebas de cálculo ponderado, clasificación y estadísticas, límites de validación y formatos decimales.

La definitiva se calcula como `nota1 × 0.20 + nota2 × 0.25 + nota3 × 0.25 + nota4 × 0.30`. La aprobación comienza en 3.0.

## Guion para la sustentación

1. **Modelos y POO:** presentar `Estudiante` y `ControlNotas`, sus constructores, atributos privados, getters y responsabilidades. Mostrar que las notas quedan protegidas con una lista inmutable.
2. **Lógica de acumulador y contador:** recorrer `Estudiante.calcularDefinitiva()` para explicar el ciclo `for`, los pesos y `acumulador`; después mostrar cómo `ControlNotas.contadorReprobados` usa `contador` cuando la definitiva es menor que 3.0.
3. **Validación:** enseñar cómo `ValidadorNotas` diferencia un campo vacío, texto inválido y una nota fuera de rango, y cómo admite punto y coma decimal.
4. **Interfaz:** explicar el formulario, la validación antes de agregar, la limpieza de campos, el indicador de aprobado/reprobado, la eliminación y la pantalla de resultados responsiva.
5. **Pruebas:** ejecutar `flutter test` y recorrer las pruebas de definitiva, contador y casos límite 0, 5, -1, 5.1, vacío y texto.# control_notas

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
