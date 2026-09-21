import 'package:flutter/material.dart';
import '../models/proveedor.dart';
import '../widgets/proveedor_modal.dart';
import '../widgets/eliminar_modal.dart';

class ProveedoresView extends StatefulWidget {
  const ProveedoresView({super.key});

  @override
  State<ProveedoresView> createState() => _ProveedoresViewState();
}

class _ProveedoresViewState extends State<ProveedoresView> {
  final List<Proveedor> _proveedores = [
    Proveedor(id: 'PROV-001', nit: '1923091231', nombre: 'TextilsCOL', contacto: 'Andres Cadavid', telefono: '23032193', estado: 'Activo'),
    Proveedor(id: 'PROV-002', nit: '1923091231', nombre: 'INSUMOMED', contacto: 'Axebiel Gayvils', telefono: '31239903', estado: 'Activo'),
    Proveedor(id: 'PROV-003', nit: '1923091231', nombre: 'HILOSAS', contacto: 'Emerson Aguemaya', telefono: '39138913', estado: 'Inactivo'),
  ];

  late List<Proveedor> _proveedoresFiltrados;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _proveedoresFiltrados = List.from(_proveedores);
  }

  void _filtrar(String query) {
    setState(() {
      _proveedoresFiltrados = _proveedores.where((p) =>
        p.nombre.toLowerCase().contains(query.toLowerCase()) ||
        p.nit.contains(query) ||
        p.id.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  void _abrirModalNuevo() {
    showDialog(
      context: context,
      builder: (context) => ProveedorModal(
        idSugerido: 'PROV-00${_proveedores.length + 1}',
        onGuardar: (nuevoProveedor) {
          setState(() {
            _proveedores.add(nuevoProveedor);
            _proveedoresFiltrados = List.from(_proveedores);
          });
        },
      ),
    );
  }

  void _abrirModalEditar(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => ProveedorModal(
        proveedor: proveedor,
        idSugerido: proveedor.id,
        onGuardar: (proveedorActualizado) {
          setState(() {
            proveedor.nit = proveedorActualizado.nit;
            proveedor.nombre = proveedorActualizado.nombre;
            proveedor.contacto = proveedorActualizado.contacto;
            proveedor.telefono = proveedorActualizado.telefono;
            proveedor.estado = proveedorActualizado.estado;
            _proveedoresFiltrados = List.from(_proveedores);
          });
        },
      ),
    );
  }

  void _abrirModalEliminar(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => EliminarModal(
        onConfirmar: () {
          setState(() {
            _proveedores.removeWhere((item) => item.id == proveedor.id);
            _proveedoresFiltrados = List.from(_proveedores);
          });
        },
      ),
    );
  }

  Widget _buildBadgeEstado(String estado) {
    final activo = estado == 'Activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo ? const Color(0xFF13381F) : const Color(0xFF3B1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estado.toUpperCase(),
            style: TextStyle(
              color: activo ? const Color(0xFF81C995) : const Color(0xFFF28B82),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: activo ? const Color(0xFF81C995) : const Color(0xFFF28B82),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera y Botón Nuevo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Proveedores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 2),
                  Text('Insumos y materiales del taller', style: TextStyle(fontSize: 12, color: Colors.white54)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECC159),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _abrirModalNuevo,
                icon: const Icon(Icons.add, size: 14, color: Colors.black),
                label: const Text('Nuevo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Buscador
          SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: _filtrar,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 18),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFECC159).withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFECC159).withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFECC159))),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Lista en Tarjetas Adaptadas para Móvil (Sin scroll lateral)
          Expanded(
            child: ListView.builder(
              itemCount: _proveedoresFiltrados.length,
              itemBuilder: (context, index) {
                final p = _proveedoresFiltrados[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila superior: ID y Estado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF2A2518), borderRadius: BorderRadius.circular(4)),
                            child: Text(p.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFECC159))),
                          ),
                          _buildBadgeEstado(p.estado),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Nombre de la Empresa
                      Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      const SizedBox(height: 6),
                      // Detalles en texto
                      Row(
                        children: [
                          const Text('NIT: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(p.nit, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(width: 16),
                          const Text('Tel: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(p.telefono, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Contacto: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(p.contacto, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const Divider(color: Color(0xFF2A2A2A), height: 16),
                      // Botones de Acción abajo a la derecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFECC159))),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFFECC159), size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              tooltip: 'Editar',
                              onPressed: () => _abrirModalEditar(p),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFECC159))),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFECC159), size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              tooltip: 'Eliminar',
                              onPressed: () => _abrirModalEliminar(p),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text('${_proveedoresFiltrados.length} registros', style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}
