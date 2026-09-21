import 'package:flutter/material.dart';
import '../models/proveedor.dart';

class ProveedorModal extends StatefulWidget {
  final Proveedor? proveedor;
  final String idSugerido;
  final Function(Proveedor) onGuardar;

  const ProveedorModal({
    super.key,
    this.proveedor,
    required this.idSugerido,
    required this.onGuardar,
  });

  @override
  State<ProveedorModal> createState() => _ProveedorModalState();
}

class _ProveedorModalState extends State<ProveedorModal> {
  late TextEditingController _idController;
  late TextEditingController _nitController;
  late TextEditingController _nombreController;
  late TextEditingController _contactoController;
  late TextEditingController _telefonoController;
  late String _estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    _idController = TextEditingController(text: p?.id ?? widget.idSugerido);
    _nitController = TextEditingController(text: p?.nit ?? '');
    _nombreController = TextEditingController(text: p?.nombre ?? '');
    _contactoController = TextEditingController(text: p?.contacto ?? '');
    _telefonoController = TextEditingController(text: p?.telefono ?? '');
    _estadoSeleccionado = p?.estado ?? 'Activo';
  }

  Widget _buildCajaTexto(String label, TextEditingController controller, {bool enabled = true, String? hint}) {
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
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
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
    final esEdicion = widget.proveedor != null;
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
          Text(esEdicion ? 'Editar Proveedor' : 'Nuevo Proveedor', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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
              _buildCajaTexto(esEdicion ? 'ID PROVEEDOR' : 'ID (AUTO)', _idController, enabled: false),
              const SizedBox(height: 12),
              _buildCajaTexto('NIT', _nitController, hint: 'Ej: 1923091231'),
              const SizedBox(height: 12),
              _buildCajaTexto('NOMBRE', _nombreController, hint: 'Nombre del proveedor'),
              const SizedBox(height: 12),
              _buildCajaTexto('CONTACTO', _contactoController, hint: 'Nombre del contacto'),
              const SizedBox(height: 12),
              _buildCajaTexto('TELÉFONO', _telefonoController, hint: '300 000 0000'),
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
                items: ['Activo', 'Inactivo'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
            if (_nombreController.text.isNotEmpty && _nitController.text.isNotEmpty) {
              final proveedorActualizado = Proveedor(
                id: _idController.text,
                nit: _nitController.text,
                nombre: _nombreController.text,
                contacto: _contactoController.text,
                telefono: _telefonoController.text,
                estado: _estadoSeleccionado,
              );
              widget.onGuardar(proveedorActualizado);
              Navigator.pop(context);
            }
          },
          child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
