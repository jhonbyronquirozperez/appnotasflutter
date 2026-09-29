import 'estudiante.dart';

/// Administra el grupo y ofrece sus estadísticas académicas.
class ControlNotas {
  final List<Estudiante> _estudiantes = [];

  List<Estudiante> get estudiantes => List.unmodifiable(_estudiantes);
  int get totalEstudiantes => _estudiantes.length;

  void agregarEstudiante(Estudiante estudiante) {
    _estudiantes.add(estudiante);
  }

  void eliminarEstudiante(Estudiante estudiante) {
    _estudiantes.remove(estudiante);
  }

  /// El contador aumenta una vez por cada definitiva menor que 3.0.
  int get contadorReprobados {
    var contador = 0;
    for (final estudiante in _estudiantes) {
      if (!estudiante.aprobo) {
        contador++;
      }
    }
    return contador;
  }

  int get aprobados => totalEstudiantes - contadorReprobados;

  double get promedioGrupo {
    if (_estudiantes.isEmpty) return 0;
    var acumulador = 0.0;
    for (final estudiante in _estudiantes) {
      acumulador += estudiante.calcularDefinitiva();
    }
    return acumulador / _estudiantes.length;
  }
}