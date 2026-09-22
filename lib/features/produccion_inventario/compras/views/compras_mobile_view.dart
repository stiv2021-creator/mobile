import 'package:flutter/material.dart';

class DetalleCompraMock {
  final String idDetalle;
  String nombreInsumo;
  int cantidad;
  double valorUnitario;

  DetalleCompraMock({
    required this.idDetalle,
    required this.nombreInsumo,
    required this.cantidad,
    required this.valorUnitario,
  });

  double get subtotal => cantidad * valorUnitario;
}

class CompraMasterMock {
  final String idCompra;
  String idProveedor;
  String fecha;
  String descripcion;
  final List<DetalleCompraMock> detalles;

  CompraMasterMock({
    required this.idCompra,
    required this.idProveedor,
    required this.fecha,
    required this.descripcion,
    required this.detalles,
  });

  double get total => detalles.fold(0, (sum, item) => sum + item.subtotal);
}

class ComprasMobileView extends StatefulWidget {
  const ComprasMobileView({super.key});

  @override
  State<ComprasMobileView> createState() => _ComprasMobileViewState();
}

class _ComprasMobileViewState extends State<ComprasMobileView> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroBusqueda = '';

  // --- MOCKS DE LISTADOS (PROVEEDORES E INSUMOS) ---
  final List<Map<String, String>> _proveedores = [
    {'id': 'PROV-001', 'nombre': 'TextilsCOL'},
    {'id': 'PROV-002', 'nombre': 'Botones y Herrajes SAS'},
    {'id': 'PROV-003', 'nombre': 'Telas e Insumos del Centro'},
    {'id': 'PROV-004', 'nombre': 'Hilos Medellín'},
  ];

  final List<Map<String, String>> _insumosDisponibles = [
    {'id': 'INS-001', 'nombre': 'Hilo'},
    {'id': 'INS-002', 'nombre': 'Botones Metálicos'},
    {'id': 'INS-003', 'nombre': 'Marquillas'},
    {'id': 'INS-004', 'nombre': 'Cremallera 20cm'},
  ];

  final List<CompraMasterMock> _compras = [
    CompraMasterMock(
      idCompra: 'COM-001',
      idProveedor: 'PROV-001',
      fecha: '2026-05-22',
      descripcion: 'Compra de hilos y marquillas',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Hilo', cantidad: 50, valorUnitario: 4000),
        DetalleCompraMock(idDetalle: 'DC-002', nombreInsumo: 'Marquillas', cantidad: 12, valorUnitario: 8000),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-002',
      idProveedor: 'PROV-002',
      fecha: '2026-05-20',
      descripcion: 'Compra de botones metálicos',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Botones Metálicos', cantidad: 60, valorUnitario: 6000),
      ],
    ),
  ];

  final Set<String> _expandidas = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }

  void _mostrarConfirmacion({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    required VoidCallback onConfirmar,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
    const Color goldColor = Color(0xFFC9A227);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: goldColor.withValues(alpha: 0.3)),
        ),
        title: Text(
          titulo,
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
        ),
        content: Text(
          mensaje,
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(fontFamily: 'Montserrat', color: textColor.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirmar();
            },
            child: const Text('Eliminar', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
    final Color subtleColor = isDarkMode ? const Color(0xFF9A9A9A) : const Color(0xFF6B6B6B);
    const Color goldColor = Color(0xFFC9A227);

    final comprasFiltradas = _compras.where((c) {
      final query = _filtroBusqueda.toLowerCase();
      return c.idCompra.toLowerCase().contains(query) ||
          c.idProveedor.toLowerCase().contains(query) ||
          c.descripcion.toLowerCase().contains(query);
    }).toList();

    int totalDetallesCount = comprasFiltradas.fold(0, (sum, c) => sum + c.detalles.length);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        title: Text(
          'Compras',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 20, color: textColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _filtroBusqueda = value),
              decoration: InputDecoration(
                hintText: 'Buscar por ID, proveedor o descripción...',
                hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: subtleColor),
                prefixIcon: const Icon(Icons.search, color: goldColor),
                suffixIcon: _filtroBusqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filtroBusqueda = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: goldColor)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: textColor),
            ),
          ),
          Expanded(
            child: comprasFiltradas.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron compras',
                      style: TextStyle(fontFamily: 'Montserrat', color: subtleColor, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comprasFiltradas.length,
                    itemBuilder: (context, index) {
                      final compra = comprasFiltradas[index];
                      final isExpanded = _expandidas.contains(compra.idCompra);
                      return _buildCompraCard(compra, isExpanded, cardBg, textColor, subtleColor, goldColor);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: cardBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${comprasFiltradas.length} compras · $totalDetallesCount detalles',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: subtleColor, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.info_outline, size: 16, color: goldColor),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarModalNuevaCompra(context),
        backgroundColor: goldColor,
        icon: const Icon(Icons.add, color: Color(0xFF121212)),
        label: const Text(
          'Nueva Compra',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: Color(0xFF121212)),
        ),
      ),
    );
  }

  Widget _buildCompraCard(
    CompraMasterMock compra,
    bool isExpanded,
    Color cardBg,
    Color textColor,
    Color subtleColor,
    Color goldColor,
  ) {
    final provInfo = _proveedores.where((p) => p['id'] == compra.idProveedor).firstOrNull;
    final nombreProv = provInfo != null ? provInfo['nombre'] : compra.idProveedor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: goldColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            compra.idCompra,
                            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 11, color: goldColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: goldColor.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${compra.detalles.length} ${compra.detalles.length == 1 ? 'ítem' : 'ítems'}',
                            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 10, color: goldColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCircleIconButton(
                          icon: Icons.visibility_outlined,
                          color: const Color(0xFF007BFF),
                          tooltip: 'Ver Detalle',
                          onPressed: () {
                            setState(() {
                              if (isExpanded) {
                                _expandidas.remove(compra.idCompra);
                              } else {
                                _expandidas.add(compra.idCompra);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 6),
                        _buildCircleIconButton(
                          icon: Icons.edit_outlined,
                          color: goldColor,
                          tooltip: 'Editar Compra',
                          onPressed: () => _mostrarModalEditarCompra(context, compra),
                        ),
                        const SizedBox(width: 6),
                        _buildCircleIconButton(
                          icon: Icons.delete_outline,
                          color: const Color(0xFFDC3545),
                          tooltip: 'Eliminar Compra',
                          onPressed: () {
                            _mostrarConfirmacion(
                              context: context,
                              titulo: 'Eliminar Compra',
                              mensaje: '¿Deseas confirmar la eliminación de la orden ${compra.idCompra}?',
                              onConfirmar: () {
                                setState(() {
                                  _compras.removeWhere((c) => c.idCompra == compra.idCompra);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Proveedor: $nombreProv',
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 13, color: textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      compra.fecha,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: subtleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  compra.descripcion,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: subtleColor),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      compra.detalles.isEmpty ? '—' : '\$${compra.total.toStringAsFixed(0)}',
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 15, color: goldColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: goldColor.withValues(alpha: 0.04),
                border: Border(top: BorderSide(color: goldColor.withValues(alpha: 0.2))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DETALLE_COMPRA — ${compra.idCompra}',
                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 11, color: goldColor, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  if (compra.detalles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'No hay insumos registrados en esta compra.',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: subtleColor, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  else
                    ...compra.detalles.map((det) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: goldColor.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(det.idDetalle, style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 10, color: goldColor)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(det.nombreInsumo, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: textColor), overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text('Cant: ${det.cantidad} x \$${det.valorUnitario.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: subtleColor)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${det.subtotal.toStringAsFixed(0)}',
                                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: goldColor),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCircleIconButton(
                                    icon: Icons.edit_outlined,
                                    color: goldColor,
                                    tooltip: 'Editar Ítem',
                                    onPressed: () => _mostrarModalEditarDetalle(context, compra, det),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildCircleIconButton(
                                    icon: Icons.delete_outline,
                                    color: const Color(0xFFDC3545),
                                    tooltip: 'Eliminar Ítem',
                                    onPressed: () {
                                      _mostrarConfirmacion(
                                        context: context,
                                        titulo: 'Eliminar Ítem',
                                        mensaje: '¿Deseas confirmar la eliminación de "${det.nombreInsumo}"?',
                                        onConfirmar: () {
                                          setState(() {
                                            compra.detalles.removeWhere((d) => d.idDetalle == det.idDetalle);
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  if (compra.detalles.isNotEmpty) ...[
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL COMPRA', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: subtleColor)),
                        Text('\$${compra.total.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 14, color: goldColor)),
                      ],
                    ),
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _mostrarModalNuevaCompra(BuildContext context) {
    String? proveedorSeleccionado;
    final TextEditingController descController = TextEditingController();
    List<Map<String, dynamic>> filasDetalle = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);
        final Color inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);
        final Color subtleColor = isDarkMode ? const Color(0xFF9A9A9A) : const Color(0xFF6B6B6B);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void agregarFila() {
              final cantCtrl = TextEditingController(text: '1');
              final valCtrl = TextEditingController(text: '0');
              cantCtrl.addListener(() => setModalState(() {}));
              valCtrl.addListener(() => setModalState(() {}));

              filasDetalle.add({
                'idInsumo': null,
                'cantController': cantCtrl,
                'valorController': valCtrl,
              });
            }

            if (filasDetalle.isEmpty) {
              agregarFila();
            }

            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: goldColor.withValues(alpha: 0.4)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 10,
              ),
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92), 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white24 : Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Nueva Compra', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 18, color: textColor), overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                    ],
                  ),
                  const Divider(color: Color(0x40C9A227)),
                  
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Text('PROVEEDOR', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A))),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: proveedorSeleccionado,
                            dropdownColor: cardBg,
                            isExpanded: true, 
                            hint: Text('— Seleccionar proveedor —', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]), overflow: TextOverflow.ellipsis),
                            items: _proveedores.map((p) => DropdownMenuItem(
                              value: p['id'], 
                              child: Text('${p['id']} — ${p['nombre']}', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor), overflow: TextOverflow.ellipsis)
                            )).toList(),
                            onChanged: (val) => setModalState(() => proveedorSeleccionado = val),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: inputBg,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: goldColor)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildModalField('DESCRIPCIÓN', 'Descripción general de la compra', descController),
                          const SizedBox(height: 24),
                          
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 10,
                            children: [
                              Text('INSUMOS DE LA COMPRA', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 11, color: goldColor, letterSpacing: 0.5)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      minimumSize: const Size(0, 32),
                                      side: BorderSide(color: goldColor.withValues(alpha: 0.5), style: BorderStyle.solid),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () => _mostrarModalCrearInsumoRapido(context, setModalState),
                                    icon: Icon(Icons.add_box_outlined, size: 14, color: goldColor),
                                    label: Text('Crear insumo', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: goldColor)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: goldColor,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                      minimumSize: const Size(0, 32),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () => setModalState(() => agregarFila()),
                                    icon: const Icon(Icons.add, size: 14),
                                    label: const Text('Añadir fila', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ...filasDetalle.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var fila = entry.value;
                            double subtotal = (int.tryParse(fila['cantController'].text) ?? 0) * (double.tryParse(fila['valorController'].text) ?? 0.0);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      height: 40, 
                                      child: DropdownButtonFormField<String>(
                                        value: fila['idInsumo'],
                                        isExpanded: true,
                                        dropdownColor: cardBg,
                                        hint: Text('Seleccionar insumo...', style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]), overflow: TextOverflow.ellipsis),
                                        items: _insumosDisponibles.map((i) => DropdownMenuItem(
                                          value: i['id'], 
                                          child: Text('${i['id']} - ${i['nombre']}', style: TextStyle(fontSize: 12, color: textColor), overflow: TextOverflow.ellipsis)
                                        )).toList(),
                                        onChanged: (val) => setModalState(() => fila['idInsumo'] = val),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputBg,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: fila['cantController'],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 13, color: textColor),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputBg,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: fila['valorController'],
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: 13, color: textColor),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: inputBg,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text('\$${subtotal.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: goldColor), overflow: TextOverflow.ellipsis),
                                        ),
                                        InkWell(
                                          onTap: () => setModalState(() => filasDetalle.removeAt(idx)),
                                          child: Icon(Icons.delete_outline, size: 18, color: subtleColor),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (proveedorSeleccionado == null) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, selecciona un proveedor.')));
                           return;
                        }
                        
                        setState(() {
                          String nuevoId = 'COM-00${_compras.length + 1}';
                          
                          List<DetalleCompraMock> nuevosDetalles = filasDetalle
                              .where((f) => f['idInsumo'] != null)
                              .map((f) {
                                String idInsumo = f['idInsumo'];
                                String nombreInsumo = _insumosDisponibles.firstWhere((i) => i['id'] == idInsumo)['nombre']!;
                                int index = filasDetalle.indexOf(f) + 1;
                                return DetalleCompraMock(
                                  idDetalle: 'DC-00$index',
                                  nombreInsumo: nombreInsumo,
                                  cantidad: int.tryParse(f['cantController'].text) ?? 1,
                                  valorUnitario: double.tryParse(f['valorController'].text) ?? 0.0,
                                );
                              }).toList();

                          _compras.add(CompraMasterMock(
                            idCompra: nuevoId,
                            idProveedor: proveedorSeleccionado!,
                            fecha: DateTime.now().toString().substring(0, 10),
                            descripcion: descController.text.isEmpty ? 'Compra general' : descController.text,
                            detalles: nuevosDetalles,
                          ));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Guardar Compra', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarModalCrearInsumoRapido(BuildContext parentContext, StateSetter setParentModalState) {
    final TextEditingController nombreInsumoCtrl = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);
        final Color inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);

        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: goldColor, size: 20),
              const SizedBox(width: 8),
              Text('Registrar Insumo', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NOMBRE DEL INSUMO', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A))),
              const SizedBox(height: 6),
              TextField(
                controller: nombreInsumoCtrl,
                decoration: InputDecoration(
                  hintText: 'Ej. Cinta reflectiva',
                  hintStyle: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
                  filled: true,
                  fillColor: inputBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: goldColor)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: textColor),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.black26),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (nombreInsumoCtrl.text.isNotEmpty) {
                        setState(() {
                           String newId = 'INS-00${_insumosDisponibles.length + 1}';
                           _insumosDisponibles.add({'id': newId, 'nombre': nombreInsumoCtrl.text});
                        });
                        setParentModalState((){}); 
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _mostrarModalEditarCompra(BuildContext context, CompraMasterMock compra) {
    String proveedorSeleccionado = compra.idProveedor;
    final TextEditingController descController = TextEditingController(text: compra.descripcion);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);
        final Color inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5); 

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: goldColor.withValues(alpha: 0.4)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white24 : Colors.black26,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Editar Compra (${compra.idCompra})', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 18, color: textColor), overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                      ],
                    ),
                    const Divider(color: Color(0x40C9A227)),
                    const SizedBox(height: 12),
                    Text('PROVEEDOR', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _proveedores.any((p) => p['id'] == proveedorSeleccionado) ? proveedorSeleccionado : null,
                      dropdownColor: cardBg,
                      isExpanded: true,
                      hint: Text('— Seleccionar proveedor —', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]), overflow: TextOverflow.ellipsis),
                      items: _proveedores.map((p) => DropdownMenuItem(
                        value: p['id'], 
                        child: Text('${p['id']} — ${p['nombre']}', style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor), overflow: TextOverflow.ellipsis)
                      )).toList(),
                      onChanged: (val) => setModalState(() => proveedorSeleccionado = val!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: inputBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: goldColor)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildModalField('DESCRIPCIÓN', 'Descripción', descController),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            compra.idProveedor = proveedorSeleccionado;
                            compra.descripcion = descController.text;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar Cambios', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarModalEditarDetalle(BuildContext context, CompraMasterMock compra, DetalleCompraMock detalle) {
    final TextEditingController insumoController = TextEditingController(text: detalle.nombreInsumo);
    final TextEditingController cantController = TextEditingController(text: detalle.cantidad.toString());
    final TextEditingController valorController = TextEditingController(text: detalle.valorUnitario.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);

        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: goldColor.withValues(alpha: 0.4)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Editar Ítem (${detalle.idDetalle})', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor)),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                  ],
                ),
                const Divider(color: Color(0x40C9A227)),
                const SizedBox(height: 12),
                _buildModalField('NOMBRE DEL INSUMO', 'Nombre', insumoController), 
                const SizedBox(height: 12),
                _buildModalField('CANTIDAD', 'Cantidad', cantController, isNumber: true),
                const SizedBox(height: 12),
                _buildModalField('VALOR UNITARIO', 'Valor unitario', valorController, isNumber: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {
                        detalle.nombreInsumo = insumoController.text;
                        detalle.cantidad = int.tryParse(cantController.text) ?? detalle.cantidad;
                        detalle.valorUnitario = double.tryParse(valorController.text) ?? detalle.valorUnitario;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Actualizar Ítem', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalField(String label, String hint, TextEditingController controller, {bool isNumber = false}) {
    return Builder(
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);
        final Color textInputColor = isDarkMode ? Colors.white : Colors.black87; 
        final Color hintColor = isDarkMode ? Colors.grey[500]! : Colors.grey[600]!; 
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              keyboardType: isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 13, color: hintColor), 
                filled: true,
                fillColor: inputBg, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFC9A227))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: textInputColor),
            ),
          ],
        );
      }
    );
  }
}