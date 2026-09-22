// lib/widgets/orden_modal.dart

import 'package:flutter/material.dart';
import '../models/orden_pedido.dart';

class OrdenModal extends StatefulWidget {
  final OrdenPedido? orden;
  final String idSugerido;
  final Function(OrdenPedido) onGuardar;

  const OrdenModal({
    super.key,
    this.orden,
    required this.idSugerido,
    required this.onGuardar,
  });

  @override
  State<OrdenModal> createState() => _OrdenModalState();
}

class _OrdenModalState extends State<OrdenModal> {
  late TextEditingController _idController;
  late String _remisionSeleccionada;
  late TextEditingController _fechaController;
  late String _estadoSeleccionado;

  final List<String> _remisionesDisponibles = ['REM-001', 'REM-002', 'REM-003'];

  @override
  void initState() {
    super.initState();
    final o = widget.orden;
    _idController = TextEditingController(text: o?.id ?? widget.idSugerido);
    _remisionSeleccionada = o?.idRemision ?? _remisionesDisponibles[0];
    _fechaController = TextEditingController(text: o?.fecha ?? '18/09/2026');
    _estadoSeleccionado = o?.estado ?? 'Pendiente';
  }

  Widget _buildCajaTexto(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(fontSize: 14, color: enabled ? Colors.white : Colors.white54),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.orden != null;
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: const Color(0xFFECC159).withValues(alpha: 0.3)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(esEdicion ? 'Editar Orden de Pedido' : 'Nueva Orden de Pedido', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          IconButton(icon: const Icon(Icons.close, size: 20, color: Colors.white54), onPressed: () => Navigator.pop(context))
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCajaTexto(esEdicion ? 'ID ORDEN' : 'ID (AUTO)', _idController, enabled: false),
              const SizedBox(height: 12),
              const Text('ID REMISIÓN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _remisionSeleccionada,
                dropdownColor: const Color(0xFF252525),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                items: _remisionesDisponibles.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _remisionSeleccionada = val!),
              ),
              const SizedBox(height: 12),
              _buildCajaTexto('FECHA', _fechaController),
              const SizedBox(height: 12),
              const Text('ESTADO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                dropdownColor: const Color(0xFF252525),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                items: ['Pendiente', 'Completado', 'Cancelado'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _estadoSeleccionado = val!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2A2A),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFECC159),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final ordenActualizada = OrdenPedido(
              id: _idController.text,
              idRemision: _remisionSeleccionada,
              fecha: _fechaController.text,
              estado: _estadoSeleccionado,
            );
            widget.onGuardar(ordenActualizada);
            Navigator.pop(context);
          },
          child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
