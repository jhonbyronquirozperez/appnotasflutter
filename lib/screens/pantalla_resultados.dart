import 'package:flutter/material.dart';

import '../models/control_notas.dart';

class PantallaResultados extends StatelessWidget {
  const PantallaResultados({super.key, required this.controlNotas});

  final ControlNotas controlNotas;

  @override
  Widget build(BuildContext context) {
    final estadisticas = [
      _Estadistica(
        etiqueta: 'Estudiantes',
        valor: '${controlNotas.totalEstudiantes}',
        icono: Icons.groups_outlined,
        color: const Color(0xFF176B62),
      ),
      _Estadistica(
        etiqueta: 'Aprobados',
        valor: '${controlNotas.aprobados}',
        icono: Icons.check_circle_outline,
        color: const Color(0xFF247A50),
      ),
      _Estadistica(
        etiqueta: 'Reprobados',
        valor: '${controlNotas.contadorReprobados}',
        icono: Icons.highlight_off,
        color: Colors.red.shade700,
      ),
      _Estadistica(
        etiqueta: 'Promedio del grupo',
        valor: controlNotas.promedioGrupo.toStringAsFixed(2),
        icono: Icons.insights_outlined,
        color: const Color(0xFF9A5B18),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados del curso')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columnas = constraints.maxWidth >= 600 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: columnas,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: columnas == 2 ? 2.6 : 3.2,
                  children: estadisticas
                      .map((dato) => _TarjetaEstadistica(dato: dato))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Estadistica {
  const _Estadistica({
    required this.etiqueta,
    required this.valor,
    required this.icono,
    required this.color,
  });

  final String etiqueta;
  final String valor;
  final IconData icono;
  final Color color;
}

class _TarjetaEstadistica extends StatelessWidget {
  const _TarjetaEstadistica({required this.dato});

  final _Estadistica dato;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(dato.icono, color: dato.color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dato.etiqueta),
                  Text(
                    dato.valor,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: dato.color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}