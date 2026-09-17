import 'package:flutter/material.dart';

class InsumosMobileView extends StatefulWidget {
  const InsumosMobileView({super.key});

  @override
  State<InsumosMobileView> createState() => _InsumosMobileViewState();
}

class _InsumosMobileViewState extends State<InsumosMobileView> {
  final List<Map<String, dynamic>> _insumos = [
    {
      'codigo': 'INS-001',
      'nombre': 'Hilo Algodón Blanco',
      'categoria': 'Hilos',
      'unidad': 'Carretes',
      'cantidad': '12',
      'stockMinimo': '5',
      'activo': true,
      'stockBajo': false,
      'notas': 'Proveedor principal: Hilos y más...',
      'icon': Icons.hourglass_empty_rounded,
    },
    {
      'codigo': 'INS-002',
      'nombre': 'Botones Nácar 20mm',
      'categoria': 'Botones',
      'unidad': 'Docenas',
      'cantidad': '3',
      'stockMinimo': '5',
      'activo': false,
      'stockBajo': true,
      'notas': 'Color perlado brillante',
      'icon': Icons.radio_button_checked_rounded,
    },
    {
      'codigo': 'INS-003',
      'nombre': 'Cierre Metálico 15cm',
      'categoria': 'Cierres',
      'unidad': 'Unidades',
      'cantidad': '25',
      'stockMinimo': '10',
      'activo': true,
      'stockBajo': false,
      'notas': 'Cierres metálicos resistentes',
      'icon': Icons.view_stream_rounded,
    },
    {
      'codigo': 'INS-004',
      'nombre': 'Tela Lino Natural',
      'categoria': 'Telas',
      'unidad': 'Metros',
      'cantidad': '45',
      'stockMinimo': '15',
      'activo': true,
      'stockBajo': false,
      'notas': 'Ideal para camisas',
      'icon': Icons.texture_rounded,
    },
    {
      'codigo': 'INS-005',
      'nombre': 'Elástico Reforzado 1cm',
      'categoria': 'Elásticos',
      'unidad': 'Rolos',
      'cantidad': '5',
      'stockMinimo': '8',
      'activo': false,
      'stockBajo': true,
      'notas': 'Color negro y blanco',
      'icon': Icons.all_inclusive_rounded,
    },
    {
      'codigo': 'INS-006',
      'nombre': 'Agujas de Máquina 90/14',
      'categoria': 'Mercería',
      'unidad': 'Paquetes',
      'cantidad': '8',
      'stockMinimo': '4',
      'activo': true,
      'stockBajo': false,
      'icon': Icons.fiber_manual_record_rounded,
    },
    {
      'codigo': 'INS-007',
      'nombre': 'Sesgo de Algodón',
      'categoria': 'Cintas',
      'unidad': 'Metros',
      'cantidad': '10',
      'stockMinimo': '12',
      'activo': true,
      'stockBajo': true,
      'notas': 'Sesgo doblado de 2cm',
      'icon': Icons.linear_scale_rounded,
    },
    {
      'codigo': 'INS-008',
      'nombre': 'Hilo Nylon Transparente',
      'categoria': 'Hilos',
      'unidad': 'Carretes',
      'cantidad': '15',
      'stockMinimo': '5',
      'activo': true,
      'stockBajo': false,
      'icon': Icons.hourglass_empty_rounded,
    },
    {
      'codigo': 'INS-009',
      'nombre': 'Broches de Presión',
      'categoria': 'Botones',
      'unidad': 'Unidades',
      'cantidad': '50',
      'stockMinimo': '20',
      'activo': false,
      'stockBajo': false,
      'notas': 'Broches metálicos de 10mm',
      'icon': Icons.radio_button_checked_rounded,
    },
    {
      'codigo': 'INS-010',
      'nombre': 'Fieltro Estampado',
      'categoria': 'Telas',
      'unidad': 'Metros',
      'cantidad': '20',
      'stockMinimo': '10',
      'activo': true,
      'stockBajo': false,
      'notas': 'Diseños infantiles',
      'icon': Icons.texture_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final doradoColor = const Color(0xFFD4AF37);
    final circleBackgroundColor = isDarkMode ? doradoColor.withValues(alpha: 0.08) : doradoColor.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Insumos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 2),
                      Text('${_insumos.length} de 24 registros', style: TextStyle(fontSize: 12, color: subTextColor)),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doradoColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      _mostrarModalAgregar(context, isDarkMode, doradoColor, (nuevoInsumo) {
                        setState(() {
                          _insumos.insert(0, nuevoInsumo);
                        });
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, código o categoría...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF252525) : const Color(0xFFF1F3F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _insumos.length,
                  itemBuilder: (context, index) {
                    final item = _insumos[index];
                    return _buildInsumoCard(
                      cardColor: cardColor,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      doradoColor: doradoColor,
                      circleBackgroundColor: circleBackgroundColor,
                      item: item,
                      isDarkMode: isDarkMode,
                      onEstadoChanged: (nuevoEstado) {
                        setState(() {
                          _insumos[index]['activo'] = nuevoEstado;
                        });
                      },
                      onEditPressed: () {
                        _mostrarModalEditar(context, item, isDarkMode, doradoColor, (datosActualizados) {
                          setState(() {
                            _insumos[index] = datosActualizados;
                          });
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsumoCard({
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color doradoColor,
    required Color circleBackgroundColor,
    required Map<String, dynamic> item,
    required bool isDarkMode,
    required ValueChanged<bool> onEstadoChanged,
    required VoidCallback onEditPressed,
  }) {
    final String codigo = item['codigo'];
    final String nombre = item['nombre'];
    final String categoria = item['categoria'];
    final String cantidad = '${item['cantidad']} ${item['unidad']}';
    final bool activo = item['activo'];
    final bool stockBajo = item['stockBajo'];
    final IconData icon = item['icon'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: doradoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(codigo, style: TextStyle(color: doradoColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activo ? Colors.green.withValues(alpha: 0.12) : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activo ? 'ACTIVO' : 'INACTIVO',
                  style: TextStyle(color: activo ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(shape: BoxShape.circle, color: circleBackgroundColor),
                child: Icon(icon, color: doradoColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('$categoria · ', style: TextStyle(fontSize: 12, color: subTextColor)),
                        Text(
                          cantidad,
                          style: TextStyle(
                            fontSize: 12,
                            color: stockBajo ? Colors.red : subTextColor,
                            fontWeight: stockBajo ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (stockBajo) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange),
                          const Text(' stock bajo', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDarkMode ? Colors.grey[800] : Colors.black12),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<bool>(
                onSelected: onEstadoChanged,
                color: isDarkMode ? const Color(0xFF252525) : Colors.white,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: true,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text('Activo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: false,
                    child: Row(
                      children: [
                        Icon(Icons.remove_circle_outline, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text('Inactivo', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: activo ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: activo ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(activo ? 'activo' : 'inactivo', style: TextStyle(color: activo ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 16, color: activo ? Colors.green : Colors.red),
                    ],
                  ),
                ),
              ),
              // Botón de editar integrado con el estilo flotante / hover dorado
              _HoverActionButton(
                icon: Icons.edit_outlined,
                doradoColor: doradoColor,
                onTap: onEditPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MODAL AGREGAR INSUMO CON ESTILOS DORADOS Y SOPORTE DE TEMA
  void _mostrarModalAgregar(BuildContext context, bool isDarkMode, Color doradoColor, ValueChanged<Map<String, dynamic>> onAgregar) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController stockActualController = TextEditingController(text: '0');
    final TextEditingController stockMinimoController = TextEditingController(text: '0');
    final TextEditingController notasController = TextEditingController();

    String? categoriaSeleccionada;
    String? unidadSeleccionada;
    bool estadoSeleccionado = true;

    final List<String> categorias = ['Hilos', 'Botones', 'Cierres', 'Telas', 'Elásticos', 'Mercería', 'Cintas'];
    final List<String> unidades = ['Carretes', 'Docenas', 'Unidades', 'Metros', 'Rolos', 'Paquetes'];

    final dialogBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Agregar Insumo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('NOMBRE DEL INSUMO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Ej: Hilo Algodón Blanco',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CATEGORÍA *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: categoriaSeleccionada != null ? doradoColor : Colors.transparent, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: categoriaSeleccionada,
                                      hint: const Text('Seleccionar...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: categorias.map((cat) => DropdownMenuItem(
                                        value: cat, 
                                        child: _buildDropdownItemText(cat, categoriaSeleccionada == cat, doradoColor, textColor),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => categoriaSeleccionada = val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('UNIDAD *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: unidadSeleccionada != null ? doradoColor : Colors.transparent, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: unidadSeleccionada,
                                      hint: const Text('Seleccionar...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: unidades.map((uni) => DropdownMenuItem(
                                        value: uni, 
                                        child: _buildDropdownItemText(uni, unidadSeleccionada == uni, doradoColor, textColor),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => unidadSeleccionada = val),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK ACTUAL *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockActualController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK MÍNIMO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockMinimoController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('ESTADO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: doradoColor, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<bool>(
                            value: estadoSeleccionado,
                            isExpanded: true,
                            dropdownColor: dialogBg,
                            style: TextStyle(color: textColor, fontSize: 13),
                            items: [
                              DropdownMenuItem(value: true, child: Text('Activo', style: TextStyle(color: textColor, fontSize: 13))),
                              DropdownMenuItem(value: false, child: Text('Inactivo', style: TextStyle(color: textColor, fontSize: 13))),
                            ],
                            onChanged: (val) => setStateModal(() => estadoSeleccionado = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('NOTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notasController,
                        maxLines: 2,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Proveedor, color, observaciones...',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: doradoColor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (nombreController.text.isEmpty || categoriaSeleccionada == null || unidadSeleccionada == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor completa los campos obligatorios (*)')),
                            );
                            return;
                          }

                          int actual = int.tryParse(stockActualController.text) ?? 0;
                          int minimo = int.tryParse(stockMinimoController.text) ?? 0;
                          bool stockBajoNuevo = actual <= minimo;

                          final nuevoInsumo = {
                            'codigo': 'INS-${(_insumos.length + 1).toString().padLeft(3, '0')}',
                            'nombre': nombreController.text,
                            'categoria': categoriaSeleccionada!,
                            'unidad': unidadSeleccionada!,
                            'cantidad': stockActualController.text,
                            'stockMinimo': stockMinimoController.text,
                            'activo': estadoSeleccionado,
                            'stockBajo': stockBajoNuevo,
                            'notas': notasController.text,
                            'icon': Icons.inventory_2_outlined,
                          };

                          onAgregar(nuevoInsumo);
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // MODAL EDITAR INSUMO CON ESTILOS DORADOS Y SOPORTE DE TEMA
  void _mostrarModalEditar(BuildContext context, Map<String, dynamic> itemActual, bool isDarkMode, Color doradoColor, ValueChanged<Map<String, dynamic>> onGuardar) {
    final TextEditingController nombreController = TextEditingController(text: itemActual['nombre']);
    final TextEditingController stockActualController = TextEditingController(text: itemActual['cantidad']);
    final TextEditingController stockMinimoController = TextEditingController(text: itemActual['stockMinimo']);
    final TextEditingController notasController = TextEditingController(text: itemActual['notas'] ?? '');

    String categoriaSeleccionada = itemActual['categoria'];
    String unidadSeleccionada = itemActual['unidad'];
    bool estadoSeleccionado = itemActual['activo'];

    final List<String> categorias = ['Hilos', 'Botones', 'Cierres', 'Telas', 'Elásticos', 'Mercería', 'Cintas'];
    final List<String> unidades = ['Carretes', 'Docenas', 'Unidades', 'Metros', 'Rolos', 'Paquetes'];

    final dialogBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Editar Insumo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('NOMBRE DEL INSUMO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CATEGORÍA *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: doradoColor, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: categoriaSeleccionada,
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: categorias.map((cat) => DropdownMenuItem(
                                        value: cat, 
                                        child: _buildDropdownItemText(cat, categoriaSeleccionada == cat, doradoColor, textColor),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => categoriaSeleccionada = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('UNIDAD *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: doradoColor, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: unidadSeleccionada,
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: unidades.map((uni) => DropdownMenuItem(
                                        value: uni, 
                                        child: _buildDropdownItemText(uni, unidadSeleccionada == uni, doradoColor, textColor),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => unidadSeleccionada = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK ACTUAL *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockActualController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK MÍNIMO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockMinimoController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('ESTADO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: doradoColor, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<bool>(
                            value: estadoSeleccionado,
                            isExpanded: true,
                            dropdownColor: dialogBg,
                            style: TextStyle(color: textColor, fontSize: 13),
                            items: const [
                              DropdownMenuItem(value: true, child: Text('activo', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: false, child: Text('inactivo', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (val) => setStateModal(() => estadoSeleccionado = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('NOTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notasController,
                        maxLines: 2,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Proveedor, color, observaciones...',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: doradoColor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          int actual = int.tryParse(stockActualController.text) ?? 0;
                          int minimo = int.tryParse(stockMinimoController.text) ?? 0;
                          bool stockBajoNuevo = actual <= minimo;

                          final datosNuevos = {
                            ...itemActual,
                            'nombre': nombreController.text,
                            'categoria': categoriaSeleccionada,
                            'unidad': unidadSeleccionada,
                            'cantidad': stockActualController.text,
                            'stockMinimo': stockMinimoController.text,
                            'activo': estadoSeleccionado,
                            'stockBajo': stockBajoNuevo,
                            'notas': notasController.text,
                          };

                          onGuardar(datosNuevos);
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget auxiliar para aplicar hover dorado y selección en elementos del dropdown
  Widget _buildDropdownItemText(String text, bool isSelected, Color doradoColor, Color defaultTextColor) {
    return StatefulBuilder(
      builder: (context, setStateItem) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setStateItem(() => isHovered = true),
          onExit: (_) => setStateItem(() => isHovered = false),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: isHovered || isSelected ? doradoColor.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isHovered || isSelected ? doradoColor : defaultTextColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget auxiliar para el botón de editar con hover dorado
class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final Color doradoColor;
  final VoidCallback onTap;

  const _HoverActionButton({required this.icon, required this.doradoColor, required this.onTap});

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? widget.doradoColor.withValues(alpha: 0.15) : Colors.transparent,
            border: Border.all(
              color: _isHovered ? widget.doradoColor : Colors.grey.withValues(alpha: 0.3),
              width: _isHovered ? 1.5 : 1,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: _isHovered ? widget.doradoColor : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}