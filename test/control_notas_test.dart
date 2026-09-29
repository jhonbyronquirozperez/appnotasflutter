import 'package:flutter_test/flutter_test.dart';

import 'package:control_notas/models/control_notas.dart';
import 'package:control_notas/models/estudiante.dart';
import 'package:control_notas/utils/validador_notas.dart';

void main() {
  group('Estudiante', () {
    test('calcula la definitiva con los cuatro porcentajes', () {
      final estudiante = Estudiante(nombre: 'Ana', notas: [4, 3, 5, 2]);

      expect(Estudiante.porcentajes.reduce((a, b) => a + b), 1.0);
      expect(estudiante.calcularDefinitiva(), closeTo(3.4, 0.0001));
      expect(estudiante.aprobo, isTrue);
    });
  });

  group('ControlNotas', () {
    test('cuenta las definitivas menores que 3.0', () {
      final control = ControlNotas()
        ..agregarEstudiante(Estudiante(nombre: 'Aprobó', notas: [4, 4, 4, 4]))
        ..agregarEstudiante(Estudiante(nombre: 'Reprobó', notas: [2, 2, 2, 2]))
        ..agregarEstudiante(Estudiante(nombre: 'Límite', notas: [3, 3, 3, 3]));

      expect(control.totalEstudiantes, 3);
      expect(control.contadorReprobados, 1);
      expect(control.aprobados, 2);
      expect(control.promedioGrupo, closeTo(3, 0.0001));
    });
  });

  group('ValidadorNotas', () {
    test('acepta los límites 0 y 5', () {
      expect(ValidadorNotas.validar('0'), isNull);
      expect(ValidadorNotas.validar('5'), isNull);
    });

    test('rechaza valores fuera del rango', () {
      expect(ValidadorNotas.validar('-1'), isNotNull);
      expect(ValidadorNotas.validar('5.1'), isNotNull);
    });

    test('rechaza vacío y texto no numérico', () {
      expect(ValidadorNotas.validar(''), isNotNull);
      expect(ValidadorNotas.validar('   '), isNotNull);
      expect(ValidadorNotas.validar('hola'), isNotNull);
    });

    test('acepta decimales con punto o coma', () {
      expect(ValidadorNotas.validar('3.5'), isNull);
      expect(ValidadorNotas.validar('3,5'), isNull);
      expect(ValidadorNotas.convertir('3,5'), 3.5);
    });
  });
}