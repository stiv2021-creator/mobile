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
const Color kBlueColor = Color(0xFF4A90E2);
const Color kRedColor = Color(0xFFDC3545);
const Color kSuccessColor = Color(0xFF28A745);

// ============================================================
// MODELO REGISTRO DIARIO
// ============================================================
class RegistroDiario {
  String id;
  String ordenProduccionId;
  String operarioNombre;
  String procesoNombre;
  int cantidadUnidades;
  DateTime fecha;
  String observaciones;
  String estado; // 'COMPLETADO', 'EN PROCESO', 'CANCELADO'

  RegistroDiario({
    required this.id,
    required this.ordenProduccionId,
    required this.operarioNombre,
    required this.procesoNombre,
    required this.cantidadUnidades,
    required this.fecha,
    this.observaciones = '',
    this.estado = 'COMPLETADO',
  });
}

// ============================================================
// COMPONENTE HOVER ACTION BUTTON
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
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.doradoColor.withValues(alpha: 0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: widget.doradoColor,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REGISTRO DIARIO VIEW (CLASE PRINCIPAL)
// ============================================================
class RegistroDiarioView extends StatefulWidget {
  const RegistroDiarioView({super.key});

  @override
  State<RegistroDiarioView> createState() => _RegistroDiarioViewState();
}

class _RegistroDiarioViewState extends State<RegistroDiarioView> {
  final List<RegistroDiario> _registros = [
    RegistroDiario(
      id: 'REG-001',
      ordenProduccionId: 'OP-2026-01',
      operarioNombre: 'María Rodríguez',
      procesoNombre: 'Ensamble de Mangas',
      cantidadUnidades: 150,
      fecha: DateTime.now(),
      observaciones: 'Sin novedades',
      estado: 'COMPLETADO',
    ),
    RegistroDiario(
      id: 'REG-002',
      ordenProduccionId: 'OP-2026-02',
      operarioNombre: 'Carlos Pérez',
      procesoNombre: 'Fileteado de Cuello',
      cantidadUnidades: 95,
      fecha: DateTime.now().subtract(const Duration(days: 1)),
      observaciones: 'Falta insumo de hilo al final de la jornada',
      estado: 'EN PROCESO',
    ),
  ];

  String _busqueda = '';

  List<RegistroDiario> get _registrosFiltrados {
    if (_busqueda.trim().isEmpty) {
      return _registros;
    }
    final texto = _busqueda.toLowerCase().trim();
    return _registros.where((reg) {
      return reg.id.toLowerCase().contains(texto) ||
          reg.ordenProduccionId.toLowerCase().contains(texto) ||
          reg.operarioNombre.toLowerCase().contains(texto) ||
          reg.procesoNombre.toLowerCase().contains(texto) ||
          reg.observaciones.toLowerCase().contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Detección automática del brillo del tema (Light / Dark Mode)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? kDarkBackground : kLightBackground;
    final cardColor = isDarkMode ? kDarkCard : kLightCard;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final doradoColor = kGoldLight;
    final searchBgColor = isDarkMode ? kDarkInput : kLightInput;
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
              // ENCABEZADO SUPERIOR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registro Diario',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_registrosFiltrados.length} de ${_registros.length} registros',
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
                      _mostrarModalAgregar(
                        context,
                        isDarkMode,
                        doradoColor,
                        (nuevoRegistro) {
                          setState(() {
                            _registros.insert(0, nuevoRegistro);
                          });
                        },
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Nuevo registro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // BUSCADOR ADAPTATIVO
              TextField(
                onChanged: (value) => setState(() => _busqueda = value),
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por OP, operario, proceso o nota...',
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
                  fillColor: searchBgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              // LISTA DE TARJETAS
              Expanded(
                child: _registrosFiltrados.isEmpty
                    ? _sinResultados(subTextColor, doradoColor)
                    : ListView.builder(
                        itemCount: _registrosFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = _registrosFiltrados[index];
                          return _buildRegistroCard(
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            doradoColor: doradoColor,
                            circleBackgroundColor: circleBackgroundColor,
                            item: item,
                            isDarkMode: isDarkMode,
                            onEstadoChanged: (nuevoEstado) {
                              setState(() {
                                item.estado = nuevoEstado;
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
                                    _registros[_registros.indexOf(item)] =
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
                                subTextColor,
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
  // TARJETA DE REGISTRO DIARIO MÓVIL
  // ============================================================
  Widget _buildRegistroCard({
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color doradoColor,
    required Color circleBackgroundColor,
    required RegistroDiario item,
    required bool isDarkMode,
    required ValueChanged<String> onEstadoChanged,
    required VoidCallback onEditPressed,
    required VoidCallback onDeletePressed,
  }) {
    final bool completado = item.estado == 'COMPLETADO';
    final Color estadoColor = completado
        ? kSuccessColor
        : (item.estado == 'EN PROCESO' ? Colors.orange : kRedColor);
    final String fechaFormateada =
        "${item.fecha.day.toString().padLeft(2, '0')}/${item.fecha.month.toString().padLeft(2, '0')}/${item.fecha.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? kDarkBorder : kLightBorder,
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.estado,
                  style: TextStyle(
                    color: estadoColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fila 2: Ícono circular + OP + Operario
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
                  Icons.assignment_turned_in_outlined,
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
                      item.ordenProduccionId,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Operario: ${item.operarioNombre}',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Fila 3: Información detallada
          _buildInfoRow(
            Icons.precision_manufacturing_outlined,
            'Proceso: ${item.procesoNombre}',
            subTextColor,
            doradoColor,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.numbers_outlined,
            'Cantidad procesada: ${item.cantidadUnidades} unidades',
            subTextColor,
            doradoColor,
            textColorCustom: isDarkMode ? const Color(0xFF64B5F6) : kBlueColor,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Fecha: $fechaFormateada',
            subTextColor,
            doradoColor,
          ),
          if (item.observaciones.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildInfoRow(
              Icons.note_alt_outlined,
              'Obs: ${item.observaciones}',
              subTextColor,
              doradoColor,
            ),
          ],
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDarkMode ? kDarkBorder : kLightBorder,
          ),
          const SizedBox(height: 10),
          // Fila 4: Acciones inferiores (Dropdown estado + Botones Editar/Eliminar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String>(
                onSelected: onEstadoChanged,
                color: isDarkMode ? kDarkCard : Colors.white,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'COMPLETADO',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: kSuccessColor, size: 16),
                        SizedBox(width: 8),
                        Text('Completado', style: TextStyle(color: kSuccessColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'EN PROCESO',
                    child: Row(
                      children: [
                        Icon(Icons.hourglass_bottom, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Text('En Proceso', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'CANCELADO',
                    child: Row(
                      children: [
                        Icon(Icons.cancel_outlined, color: kRedColor, size: 16),
                        SizedBox(width: 8),
                        Text('Cancelado', style: TextStyle(color: kRedColor, fontWeight: FontWeight.bold)),
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
                    color: estadoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: estadoColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.estado.toLowerCase(),
                        style: TextStyle(
                          color: estadoColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: estadoColor,
                      ),
                    ],
                  ),
                ),
              ),
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
            text.isEmpty ? 'N/A' : text,
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
              Icons.fact_check_outlined,
              size: 30,
              color: doradoColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontraron registros diarios',
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

  Widget _buildLabelModal(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
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
    Color bg,
    Color focusBorderColor,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: focusBorderColor, width: 1.5),
      ),
    );
  }

  // ============================================================
  // MODAL AGREGAR REGISTRO DIARIO
  // ============================================================
  void _mostrarModalAgregar(
    BuildContext context,
    bool isDarkMode,
    Color doradoColor,
    ValueChanged<RegistroDiario> onAgregar,
  ) {
    final ordenIdController = TextEditingController();
    final operarioController = TextEditingController();
    final procesoController = TextEditingController();
    final cantidadController = TextEditingController();
    final observacionesController = TextEditingController();
    DateTime fechaSeleccionada = DateTime.now();
    String estadoSeleccionado = 'COMPLETADO';

    final dialogBg = isDarkMode ? kDarkCard : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode ? kDarkInput : kLightInput;

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
                    'Nuevo Registro Diario',
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
                      _buildLabelModal('ORDEN DE PRODUCCIÓN (OP) *'),
                      TextField(
                        controller: ordenIdController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: OP-2026-01',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('OPERARIO / EMPLEADO *'),
                      TextField(
                        controller: operarioController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: María Rodríguez',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('PROCESO *'),
                      TextField(
                        controller: procesoController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: Ensamble de Mangas',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('CANTIDAD PROCESADA *'),
                      TextField(
                        controller: cantidadController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: 150',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('OBSERVACIONES'),
                      TextField(
                        controller: observacionesController,
                        maxLines: 2,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Notas adicionales...',
                          inputBg,
                          doradoColor,
                        ),
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
                          child: DropdownButton<String>(
                            value: estadoSeleccionado,
                            isExpanded: true,
                            dropdownColor: dialogBg,
                            style: TextStyle(color: textColor, fontSize: 13),
                            items: const [
                              DropdownMenuItem(
                                value: 'COMPLETADO',
                                child: Text('Completado'),
                              ),
                              DropdownMenuItem(
                                value: 'EN PROCESO',
                                child: Text('En Proceso'),
                              ),
                              DropdownMenuItem(
                                value: 'CANCELADO',
                                child: Text('Cancelado'),
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
                          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEFEFEF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none,
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
                          if (ordenIdController.text.isEmpty ||
                              operarioController.text.isEmpty ||
                              procesoController.text.isEmpty ||
                              cantidadController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa los campos obligatorios (*)',
                                ),
                              ),
                            );
                            return;
                          }
                          final nuevo = RegistroDiario(
                            id: 'REG-00${_registros.length + 1}',
                            ordenProduccionId: ordenIdController.text,
                            operarioNombre: operarioController.text,
                            procesoNombre: procesoController.text,
                            cantidadUnidades:
                                int.tryParse(cantidadController.text) ?? 0,
                            fecha: fechaSeleccionada,
                            observaciones: observacionesController.text,
                            estado: estadoSeleccionado,
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
  // MODAL EDITAR REGISTRO DIARIO
  // ============================================================
  void _mostrarModalEditar(
    BuildContext context,
    RegistroDiario itemActual,
    bool isDarkMode,
    Color doradoColor,
    ValueChanged<RegistroDiario> onGuardar,
  ) {
    final ordenIdController =
        TextEditingController(text: itemActual.ordenProduccionId);
    final operarioController =
        TextEditingController(text: itemActual.operarioNombre);
    final procesoController =
        TextEditingController(text: itemActual.procesoNombre);
    final cantidadController =
        TextEditingController(text: itemActual.cantidadUnidades.toString());
    final observacionesController =
        TextEditingController(text: itemActual.observaciones);
    String estadoSeleccionado = itemActual.estado;

    final dialogBg = isDarkMode ? kDarkCard : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode ? kDarkInput : kLightInput;

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
                    'Editar Registro ${itemActual.id}',
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
                      _buildLabelModal('ORDEN DE PRODUCCIÓN (OP) *'),
                      TextField(
                        controller: ordenIdController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: OP-2026-01',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('OPERARIO / EMPLEADO *'),
                      TextField(
                        controller: operarioController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: María Rodríguez',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('PROCESO *'),
                      TextField(
                        controller: procesoController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: Ensamble de Mangas',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('CANTIDAD PROCESADA *'),
                      TextField(
                        controller: cantidadController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Ej: 150',
                          inputBg,
                          doradoColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabelModal('OBSERVACIONES'),
                      TextField(
                        controller: observacionesController,
                        maxLines: 2,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: _inputDecorationModal(
                          'Notas adicionales...',
                          inputBg,
                          doradoColor,
                        ),
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
                          child: DropdownButton<String>(
                            value: estadoSeleccionado,
                            isExpanded: true,
                            dropdownColor: dialogBg,
                            style: TextStyle(color: textColor, fontSize: 13),
                            items: const [
                              DropdownMenuItem(
                                value: 'COMPLETADO',
                                child: Text('Completado'),
                              ),
                              DropdownMenuItem(
                                value: 'EN PROCESO',
                                child: Text('En Proceso'),
                              ),
                              DropdownMenuItem(
                                value: 'CANCELADO',
                                child: Text('Cancelado'),
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
                          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEFEFEF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none,
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
                          if (ordenIdController.text.isEmpty ||
                              operarioController.text.isEmpty ||
                              procesoController.text.isEmpty ||
                              cantidadController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Completa los campos obligatorios (*)',
                                ),
                              ),
                            );
                            return;
                          }
                          final editado = RegistroDiario(
                            id: itemActual.id,
                            ordenProduccionId: ordenIdController.text,
                            operarioNombre: operarioController.text,
                            procesoNombre: procesoController.text,
                            cantidadUnidades:
                                int.tryParse(cantidadController.text) ?? 0,
                            fecha: itemActual.fecha,
                            observaciones: observacionesController.text,
                            estado: estadoSeleccionado,
                          );
                          onGuardar(editado);
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
  // DIÁLOGO DE CONFIRMACIÓN ELIMINAR
  // ============================================================
  void _confirmarEliminar(
    BuildContext context,
    RegistroDiario item,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
  ) {
    final dialogBg = isDarkMode ? kDarkCard : Colors.white;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: kRedColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error_outline_rounded, color: kRedColor, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  '¿Eliminar registro?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kRedColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kRedColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'Esta acción eliminará el registro diario ${item.id} de la OP "${item.ordenProduccionId}" de forma permanente.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kRedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEFEFEF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none,
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
                          backgroundColor: kRedColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _registros.removeWhere((element) => element.id == item.id);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sí, eliminar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}