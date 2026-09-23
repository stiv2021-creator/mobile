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

  Widget _buildCajaTexto(
    String label,
    TextEditingController controller,
    bool isDark, {
    bool enabled = true,
    String? hint,
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
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white30 : Colors.black38,
              fontSize: 13,
            ),
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
    final esEdicion = widget.proveedor != null;
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
            esEdicion ? 'Editar Proveedor' : 'Nuevo Proveedor',
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
                esEdicion ? 'ID PROVEEDOR' : 'ID (AUTO)',
                _idController,
                isDark,
                enabled: false,
              ),
              const SizedBox(height: 12),
              _buildCajaTexto(
                'NIT',
                _nitController,
                isDark,
                hint: 'Ej: 1923091231',
              ),
              const SizedBox(height: 12),
              _buildCajaTexto(
                'NOMBRE',
                _nombreController,
                isDark,
                hint: 'Nombre del proveedor',
              ),
              const SizedBox(height: 12),
              _buildCajaTexto(
                'CONTACTO',
                _contactoController,
                isDark,
                hint: 'Nombre del contacto',
              ),
              const SizedBox(height: 12),
              _buildCajaTexto(
                'TELÉFONO',
                _telefonoController,
                isDark,
                hint: '300 000 0000',
              ),
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

              // AQUI ESTÁ LA CORRECCIÓN CLAVE: usamos "value" en lugar de "initialValue"
              DropdownButtonFormField<String>(
                value: _estadoSeleccionado,
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
                items: ['Activo', 'Inactivo']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _estadoSeleccionado = val!;
                  });
                },
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
            if (_nombreController.text.isNotEmpty &&
                _nitController.text.isNotEmpty) {
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
          child: const Text(
            'Guardar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
