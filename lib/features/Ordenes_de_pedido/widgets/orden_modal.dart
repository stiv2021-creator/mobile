// lib/features/ordenes_pedido/widgets/orden_modal.dart

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

  Widget _buildCajaTexto(
    String label,
    TextEditingController controller,
    bool isDark, {
    bool enabled = true,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final inputBg = isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: subtitleColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          style: TextStyle(
            fontSize: 14,
            color: enabled ? textColor : subtitleColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.orden != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color inputBg = isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]!;
    final Color borderColor = isDark
        ? const Color(0xFFECC159).withOpacity(0.3)
        : const Color(0xFFECC159);
    const Color primaryGold = Color(0xFFECC159);

    return AlertDialog(
      backgroundColor: bgColor,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            esEdicion ? 'Editar Orden de Pedido' : 'Nueva Orden',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 20,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCajaTexto(
                esEdicion ? 'ID ORDEN' : 'ID (AUTO)',
                _idController,
                isDark,
                enabled: false,
              ),
              const SizedBox(height: 12),
              Text(
                'ID REMISIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _remisionSeleccionada,
                dropdownColor: isDark ? const Color(0xFF252525) : Colors.white,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: _remisionesDisponibles
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _remisionSeleccionada = val!),
              ),
              const SizedBox(height: 12),
              _buildCajaTexto('FECHA', _fechaController, isDark),
              const SizedBox(height: 12),
              Text(
                'ESTADO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _estadoSeleccionado,
                dropdownColor: isDark ? const Color(0xFF252525) : Colors.white,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputBg,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Pendiente', 'Completado', 'Cancelado']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _estadoSeleccionado = val!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF2A2A2A)
                : Colors.grey[200],
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGold,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
          child: const Text(
            'Guardar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
