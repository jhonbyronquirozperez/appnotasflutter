/// Representa a un estudiante y sus cuatro notas parciales.
class Estudiante {
  Estudiante({required String nombre, required List<double> notas})
    : _nombre = nombre.trim(),
      _notas = List<double>.unmodifiable(notas) {
    if (_notas.length != porcentajes.length) {
      throw ArgumentError('Un estudiante debe tener exactamente 4 notas.');
    }
  }

  final String _nombre;
  final List<double> _notas;

  /// Pesos de cada nota: 20% + 25% + 25% + 30% = 100%.
  static const List<double> porcentajes = [0.20, 0.25, 0.25, 0.30];
  static const double notaMinimaAprobacion = 3.0;

  String get nombre => _nombre;
  List<double> get notas => _notas;

  /// Multiplica cada nota por su peso y acumula el resultado en [acumulador].
  double calcularDefinitiva() {
    double acumulador = 0;
    for (var indice = 0; indice < _notas.length; indice++) {
      acumulador += _notas[indice] * porcentajes[indice];
    }
    return acumulador;
  }

  /// Una definitiva de 3.0 o más se considera aprobada.
  bool get aprobo => calcularDefinitiva() >= notaMinimaAprobacion;

  @override
  String toString() =>
      'Estudiante(nombre: $_nombre, definitiva: '
      '${calcularDefinitiva().toStringAsFixed(2)})';
}