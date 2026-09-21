import 'package:flutter/material.dart';

// ============================================================
// COLORES GENERALES DEL MÓDULO (LIGADOS A LA PALETA COMPARTIDA)
// ============================================================
const Color kGoldLight = Color(0xFFD4AF37);
const Color kGoldDark = Color(0xFFE5B800);
const Color kDarkBackground = Color(0xFF101010);
const Color kDarkCard = Color(0xFF1E1E1E);
const Color kDarkInput = Color(0xFF292929);
const Color kDarkBorder = Color(0xFF383838);
const Color kLightBackground = Color(0xFFF7F7F7);
const Color kLightCard = Color(0xFFFFFFFF);
const Color kLightInput = Color(0xFFF1F1F1);
const Color kLightBorder = Color(0xFFE2E2E2);

// ============================================================
// MODELO CLIENTE
// ============================================================
class Cliente {
  String id;
  String nombre;
  String identificacion;
  String direccion;
  String correo;
  String telefono;
  String estado; // 'ACTIVO' o 'INACTIVO'

  Cliente({
    required this.id,
    required this.nombre,
    required this.identificacion,
    required this.direccion,
    required this.correo,
    required this.telefono,
    this.estado = 'ACTIVO',
  });
}

// ============================================================
// CLIENTES VIEW (ESTRUCTURA IDÉNTICA A INSUMOS)
// ============================================================
class ClientesView extends StatefulWidget {
  const ClientesView({super.key});

  @override
  State<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends State<ClientesView> {
  final List<Cliente> _clientes = [
    Cliente(
      id: '00-1',
      nombre: 'QueNOTA',
      identificacion: '10458231',
      direccion: 'Cra 45 #20-432',
      correo: 'guenota@gmail.com',
      telefono: '3049820982',
      estado: 'ACTIVO',
    ),
    Cliente(
      id: '00-2',
      nombre: 'Offcors',
      identificacion: '9032145',
      direccion: 'Cra 43 #43s',
      correo: 'offcors@gmail.com',
      telefono: '3092903093',
      estado: 'ACTIVO',
    ),
    Cliente(
      id: '00-3',
      nombre: 'Nike',
      identificacion: '8801234',
      direccion: 'Cra 48 #99',
      correo: 'nike@gmail.com',
      telefono: '90980981',
      estado: 'ACTIVO',
    ),
  ];

  String _busqueda = '';

  List<Cliente> get _clientesFiltrados {
    if (_busqueda.trim().isEmpty) {
      return _clientes;
    }
    final texto = _busqueda.toLowerCase().trim();
    return _clientes.where((cliente) {
      return cliente.id.toLowerCase().contains(texto) ||
          cliente.nombre.toLowerCase().contains(texto) ||
          cliente.identificacion.toLowerCase().contains(texto) ||
          cliente.direccion.toLowerCase().contains(texto) ||
          cliente.correo.toLowerCase().contains(texto) ||
          cliente.telefono.toLowerCase().contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final doradoColor = const Color(0xFFD4AF37);
    final circleBackgroundColor = isDarkMode
        ? doradoColor.withValues(alpha: 0.08)
        : doradoColor.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // ENCABEZADO SUPERIOR
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clientes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_clientesFiltrados.length} de ${_clientes.length} registros',
                        style: TextStyle(fontSize: 12, color: subTextColor),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doradoColor,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _mostrarModalAgregar(context, isDarkMode, doradoColor, (
                        nuevoCliente,
                      ) {
                        setState(() {
                          _clientes.insert(0, nuevoCliente);
                        });
                      });
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Agregar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==================================================
              // BUSCADOR
              // ==================================================
              TextField(
                onChanged: (value) => setState(() => _busqueda = value),
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, identificación o correo...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  suffixIcon: _busqueda.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: subTextColor,
                          ),
                          onPressed: () => setState(() => _busqueda = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: isDarkMode
                      ? const Color(0xFF252525)
                      : const Color(0xFFF1F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),

              // ==================================================
              // LISTA DE TARJETAS
              // ==================================================
              Expanded(
                child: _clientesFiltrados.isEmpty
                    ? _sinResultados(subTextColor, doradoColor)
                    : ListView.builder(
                        itemCount: _clientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = _clientesFiltrados[index];
                          return _buildClienteCard(
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            doradoColor: doradoColor,
                            circleBackgroundColor: circleBackgroundColor,
                            item: item,
                            isDarkMode: isDarkMode,
                            onEstadoChanged: (nuevoEstado) {
                              setState(() {
                                item.estado = nuevoEstado
                                    ? 'ACTIVO'
                                    : 'INACTIVO';
                              });
                            },
                            onEditPressed: () {
                              _mostrarModalEditar(
                                context,
                                item,
                                isDarkMode,
                                doradoColor,
                                (datosActualizados) {
                                  setState(() {
                                    _clientes[_clientes.indexOf(item)] =
                                        datosActualizados;
                                  });
                                },
                              );
                            },
                            onDeletePressed: () {
                              _confirmarEliminar(
                                context,
                                item,
                                isDarkMode,
                                textColor,
                              );
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

  // ============================================================
  // COMPONENTE TARJETA DE CLIENTE
  // ============================================================
  Widget _buildClienteCard({
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color doradoColor,
    required Color circleBackgroundColor,
    required Cliente item,
    required bool isDarkMode,
    required ValueChanged<bool> onEstadoChanged,
    required VoidCallback onEditPressed,
    required VoidCallback onDeletePressed,
  }) {
    final bool activo = item.estado == 'ACTIVO';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fila 1: Badge ID + Badge Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: doradoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.id,
                  style: TextStyle(
                    color: doradoColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: activo
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  activo ? 'ACTIVO' : 'INACTIVO',
                  style: TextStyle(
                    color: activo ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila 2: Ícono circular + Nombre + C.C.
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleBackgroundColor,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: doradoColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nombre,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'CC · ${item.identificacion}',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Fila 3: Información detallada (Dirección, Correo, Teléfono)
          _buildInfoRow(
            Icons.location_on_outlined,
            item.direccion,
            subTextColor,
            doradoColor,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.email_outlined,
            item.correo,
            subTextColor,
            doradoColor,
            textColorCustom: isDarkMode
                ? const Color(0xFF64B5F6)
                : const Color(0xFF4285D4),
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.phone_outlined,
            item.telefono,
            subTextColor,
            doradoColor,
          ),

          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDarkMode ? Colors.grey[800] : Colors.black12,
          ),
          const SizedBox(height: 10),

          // Fila 4: Acciones inferiores (Dropdown de estado + Botones de Editar/Eliminar)
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
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Activo',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: false,
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Inactivo',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: activo
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: activo
                          ? Colors.green.withValues(alpha: 0.3)
                          : Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activo ? 'activo' : 'inactivo',
                        style: TextStyle(
                          color: activo ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: activo ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción con el mismo efecto hover
              Row(
                children: [
                  _HoverActionButton(
                    icon: Icons.edit_outlined,
                    doradoColor: doradoColor,
                    onTap: onEditPressed,
                  ),
                  const SizedBox(width: 8),
                  _HoverActionButton(
                    icon: Icons.delete_outline_rounded,
                    doradoColor: Colors.redAccent,
                    onTap: onDeletePressed,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    Color subTextColor,
    Color doradoColor, {
    Color? textColorCustom,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: doradoColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: textColorCustom ?? subTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sinResultados(Color subTextColor, Color doradoColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: doradoColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 30,
              color: doradoColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontraron clientes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MODAL AGREGAR CLIENTE
  // ============================================================
  void _mostrarModalAgregar(
    BuildContext context,
    bool isDarkMode,
    Color doradoColor,
    ValueChanged<Cliente> onAgregar,
  ) {
    final nombreController = TextEditingController();
    final identificacionController = TextEditingController();
    final direccionController = TextEditingController();
    final correoController = TextEditingController();
    final telefonoController = TextEditingController();
    bool estadoSeleccionado = true;

    final dialogBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFF1F3F5);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agregar Cliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
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
                      _buildLabelModal('NOMBRE COMPLETO *'),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: QueNOTA',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('IDENTIFICACIÓN (NIT / C.C.) *'),
                      TextField(
                        controller: identificacionController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: 10458231',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('DIRECCIÓN'),
                      TextField(
                        controller: direccionController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: Cra 45 #20-432',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelModal('CORREO'),
                                TextField(
                                  controller: correoController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecorationModal(
                                    'correo@gmail.com',
                                    inputBg,
                                    doradoColor,
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
                                _buildLabelModal('TELÉFONO'),
                                TextField(
                                  controller: telefonoController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecorationModal(
                                    '3000000000',
                                    inputBg,
                                    doradoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('ESTADO *'),
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
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  'Activo',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  'Inactivo',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            ],
                            onChanged: (val) =>
                                setStateModal(() => estadoSeleccionado = val!),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (nombreController.text.isEmpty ||
                              identificacionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa los campos obligatorios (*)',
                                ),
                              ),
                            );
                            return;
                          }
                          final nuevo = Cliente(
                            id: '00-${_clientes.length + 1}',
                            nombre: nombreController.text,
                            identificacion: identificacionController.text,
                            direccion: direccionController.text,
                            correo: correoController.text,
                            telefono: telefonoController.text,
                            estado: estadoSeleccionado ? 'ACTIVO' : 'INACTIVO',
                          );
                          onAgregar(nuevo);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  // ============================================================
  // MODAL EDITAR CLIENTE
  // ============================================================
  void _mostrarModalEditar(
    BuildContext context,
    Cliente itemActual,
    bool isDarkMode,
    Color doradoColor,
    ValueChanged<Cliente> onGuardar,
  ) {
    final nombreController = TextEditingController(text: itemActual.nombre);
    final identificacionController = TextEditingController(
      text: itemActual.identificacion,
    );
    final direccionController = TextEditingController(
      text: itemActual.direccion,
    );
    final correoController = TextEditingController(text: itemActual.correo);
    final telefonoController = TextEditingController(text: itemActual.telefono);
    bool estadoSeleccionado = itemActual.estado == 'ACTIVO';

    final dialogBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFF1F3F5);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Editar Cliente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
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
                      _buildLabelModal('NOMBRE COMPLETO *'),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          '',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('IDENTIFICACIÓN *'),
                      TextField(
                        controller: identificacionController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          '',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('DIRECCIÓN'),
                      TextField(
                        controller: direccionController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          '',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabelModal('CORREO'),
                                TextField(
                                  controller: correoController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecorationModal(
                                    '',
                                    inputBg,
                                    doradoColor,
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
                                _buildLabelModal('TELÉFONO'),
                                TextField(
                                  controller: telefonoController,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  decoration: _inputDecorationModal(
                                    '',
                                    inputBg,
                                    doradoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('ESTADO *'),
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
                              DropdownMenuItem(
                                value: true,
                                child: Text(
                                  'Activo',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text(
                                  'Inactivo',
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            ],
                            onChanged: (val) =>
                                setStateModal(() => estadoSeleccionado = val!),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final actualizado = Cliente(
                            id: itemActual.id,
                            nombre: nombreController.text,
                            identificacion: identificacionController.text,
                            direccion: direccionController.text,
                            correo: correoController.text,
                            telefono: telefonoController.text,
                            estado: estadoSeleccionado ? 'ACTIVO' : 'INACTIVO',
                          );
                          onGuardar(actualizado);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Guardar cambios',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  // ============================================================
  // CONFIRMAR ELIMINAR CLIENTE
  // ============================================================
  void _confirmarEliminar(
    BuildContext context,
    Cliente cliente,
    bool isDarkMode,
    Color textColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Eliminar cliente',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          content: Text(
            '¿Deseas eliminar a ${cliente.nombre} permanentemente?',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  _clientes.removeWhere((item) => item.id == cliente.id);
                });
                Navigator.pop(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabelModal(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _inputDecorationModal(
    String hint,
    Color inputBg,
    Color doradoColor,
  ) {
    return InputDecoration(
      hintText: hint.isNotEmpty ? hint : null,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      filled: true,
      fillColor: inputBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: doradoColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}

// ============================================================
// WIDGET AUXILIAR BOTOŃ CON HOVER DORADO
// ============================================================
class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final Color doradoColor;
  final VoidCallback onTap;

  const _HoverActionButton({
    required this.icon,
    required this.doradoColor,
    required this.onTap,
  });

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
            color: _isHovered
                ? widget.doradoColor.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? widget.doradoColor
                  : Colors.grey.withValues(alpha: 0.3),
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
