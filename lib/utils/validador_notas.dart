/// Centraliza la conversión y validación de notas en escala de 0 a 5.
class ValidadorNotas {
  static String? validar(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa una nota.';
    }

    final nota = convertir(valor);
    if (nota == null) {
      return 'Ingresa un número válido (usa punto o coma decimal).';
    }
    if (nota < 0 || nota > 5) {
      return 'La nota debe estar entre 0 y 5.';
    }
    return null;
  }

  /// Convierte tanto "3.5" como "3,5"; devuelve null si no es numérico.
  static double? convertir(String? valor) {
    if (valor == null) return null;
    return double.tryParse(valor.trim().replaceAll(',', '.'));
  }
}