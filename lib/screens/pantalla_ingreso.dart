import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/control_notas.dart';
import '../models/estudiante.dart';
import '../utils/validador_notas.dart';
import 'pantalla_resultados.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _notaControllers = List.generate(4, (_) => TextEditingController());
  final _controlNotas = ControlNotas();

  @override
  void dispose() {
    _nombreController.dispose();
    for (final controller in _notaControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _agregarEstudiante() {
    if (!_formKey.currentState!.validate()) return;

    final notas = _notaControllers
        .map((controller) => ValidadorNotas.convertir(controller.text)!)
        .toList();
    setState(() {
      _controlNotas.agregarEstudiante(
        Estudiante(nombre: _nombreController.text, notas: notas),
      );
      _nombreController.clear();
      for (final controller in _notaControllers) {
        controller.clear();
      }
      _formKey.currentState!.reset();
    });
  }

  Future<void> _mostrarResultados() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PantallaResultados(controlNotas: _controlNotas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final esAmplia = ancho >= 850;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de notas'),
        actions: [
          TextButton.icon(
            onPressed: _mostrarResultados,
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Resultados'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Registro del curso',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'Ingresa las notas parciales para calcular cada definitiva.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (esAmplia)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _construirFormulario(context)),
                      const SizedBox(width: 24),
                      Expanded(child: _construirLista(context)),
                    ],
                  )
                else ...[
                  _construirFormulario(context),
                  const SizedBox(height: 24),
                  _construirLista(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirFormulario(BuildContext context) {
    return _Panel(
      titulo: 'Nuevo estudiante',
      hijo: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre del estudiante',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (valor) => valor == null || valor.trim().isEmpty
                  ? 'Ingresa el nombre del estudiante.'
                  : null,
            ),
            const SizedBox(height: 12),
            ...List.generate(4, (indice) {
              final porcentaje = Estudiante.porcentajes[indice] * 100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: _notaControllers[indice],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    labelText:
                        'Nota ${indice + 1} (${porcentaje.toStringAsFixed(0)}%)',
                    prefixIcon: const Icon(Icons.edit_note),
                  ),
                  validator: ValidadorNotas.validar,
                ),
              );
            }),
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: _agregarEstudiante,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Agregar estudiante'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(BuildContext context) {
    return _Panel(
      titulo: 'Estudiantes registrados (${_controlNotas.totalEstudiantes})',
      hijo: _controlNotas.estudiantes.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Todavía no hay estudiantes.')),
            )
          : Column(
              children: _controlNotas.estudiantes
                  .map((estudiante) => _FilaEstudiante(
                        estudiante: estudiante,
                        alEliminar: () {
                          setState(() {
                            _controlNotas.eliminarEstudiante(estudiante);
                          });
                        },
                      ))
                  .toList(),
            ),
    );
  }
}

class _FilaEstudiante extends StatelessWidget {
  const _FilaEstudiante({required this.estudiante, required this.alEliminar});

  final Estudiante estudiante;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final color = estudiante.aprobo
        ? const Color(0xFF247A50)
        : Colors.red.shade700;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(
          estudiante.aprobo ? Icons.check : Icons.close,
          color: color,
        ),
      ),
      title: Text(estudiante.nombre),
      subtitle: Text(estudiante.aprobo ? 'Aprobó' : 'Reprobó'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estudiante.calcularDefinitiva().toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          IconButton(
            tooltip: 'Eliminar estudiante',
            onPressed: alEliminar,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.titulo, required this.hijo});

  final String titulo;
  final Widget hijo;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 18),
            hijo,
          ],
        ),
      ),
    );
  }
}