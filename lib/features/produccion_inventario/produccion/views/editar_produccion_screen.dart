import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/produccion_model.dart'; // Ajusta esta ruta según tus carpetas

class EditarProduccionScreen extends StatefulWidget {
  final ProduccionModel produccion;
  final Function(ProduccionModel) onUpdate;

  const EditarProduccionScreen({
    super.key,
    required this.produccion,
    required this.onUpdate,
  });

  @override
  State<EditarProduccionScreen> createState() => _EditarProduccionScreenState();
}

class _EditarProduccionScreenState extends State<EditarProduccionScreen> {
  // Controladores y estados
  late TextEditingController ordenPedidoCtrl;
  late TextEditingController fechaInicioCtrl;
  late TextEditingController fechaEntregaCtrl;
  late String estadoSeleccionado;
  late List<Map<String, dynamic>> detallesState;

  // Catálogos para el autocompletado
  static const List<String> _catalogoEmpleados = [
    'Juan Pérez',
    'María Rodríguez',
    'Carlos López',
    'Ana Gómez',
  ];
  static const List<String> _catalogoPiezas = [
    'Manga Larga',
    'Cuello Polo',
    'Frente Camisa',
    'Bolsillo',
  ];
  static const List<String> _catalogoMaquinas = [
    'Plana Industrial',
    'Fileteadora',
    'Colcollarin',
    'Ojaladora',
  ];
  static const List<String> _catalogoInsumosList = [
    'Tela lona',
    'Tela de algodón',
    'Hilo resistente negro',
    'Cierres metálicos personalizados',
    'Botones de metal grabados',
  ];

  @override
  void initState() {
    super.initState();
    ordenPedidoCtrl = TextEditingController(
      text: widget.produccion.idOrdenPedido,
    );
    fechaInicioCtrl = TextEditingController(
      text: widget.produccion.fechaInicio,
    );
    fechaEntregaCtrl = TextEditingController(
      text: widget.produccion.fechaEntrega,
    );
    estadoSeleccionado = widget.produccion.estado;

    detallesState = widget.produccion.detalles.map<Map<String, dynamic>>((d) {
      final insumoActual =
          (d.idInsumosEnviadosXCliente.isNotEmpty &&
              d.idInsumosEnviadosXCliente != 'N/A')
          ? d.idInsumosEnviadosXCliente
          : d.idInsumos;

      return {
        'idEmpleado': TextEditingController(text: d.idEmpleado),
        'idTipoPieza': TextEditingController(text: d.idTipoPieza),
        'idTipoMaquina': TextEditingController(text: d.idTipoMaquina),
        'insumoSeleccionado': TextEditingController(
          text: insumoActual == 'N/A' ? '' : insumoActual,
        ),
        'cantidad': TextEditingController(text: d.cantidadAsignada),
        'fechaAsignada': TextEditingController(text: d.fechaAsignada),
      };
    }).toList();
  }

  @override
  void dispose() {
    ordenPedidoCtrl.dispose();
    fechaInicioCtrl.dispose();
    fechaEntregaCtrl.dispose();
    for (var state in detallesState) {
      state['idEmpleado']?.dispose();
      state['idTipoPieza']?.dispose();
      state['idTipoMaquina']?.dispose();
      state['insumoSeleccionado']?.dispose();
      state['cantidad']?.dispose();
      state['fechaAsignada']?.dispose();
    }
    super.dispose();
  }

  void _guardarCambios() {
    widget.produccion.idOrdenPedido = ordenPedidoCtrl.text;
    widget.produccion.fechaInicio = fechaInicioCtrl.text;
    widget.produccion.fechaEntrega = fechaEntregaCtrl.text;
    widget.produccion.estado = estadoSeleccionado;

    for (int i = 0; i < widget.produccion.detalles.length; i++) {
      final detalle = widget.produccion.detalles[i];
      detalle.idEmpleado = detallesState[i]['idEmpleado']!.text;
      detalle.idTipoPieza = detallesState[i]['idTipoPieza']!.text;
      detalle.idTipoMaquina = detallesState[i]['idTipoMaquina']!.text;
      detalle.cantidadAsignada = detallesState[i]['cantidad']!.text;
      detalle.fechaAsignada = detallesState[i]['fechaAsignada']!.text;
      detalle.detalleRem = '';

      final insumoTexto = detallesState[i]['insumoSeleccionado']!.text;
      if (insumoTexto.isEmpty) {
        detalle.idInsumos = 'N/A';
        detalle.idInsumosEnviadosXCliente = 'N/A';
      } else {
        detalle.idInsumos = insumoTexto;
        detalle.idInsumosEnviadosXCliente = 'N/A';
      }
    }

    widget.onUpdate(widget.produccion);
    Navigator.pop(context); // Regresa a la vista anterior
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF121212);
    final Color containerBg = isDarkMode
        ? const Color(0xFF252525)
        : const Color(0xFFF8F9FA);
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    final Color dividerColor = isDarkMode
        ? Colors.white12
        : const Color(0xFFE0E0E0);
    final Color scaffoldBg = isDarkMode
        ? const Color(0xFF121212)
        : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          'Editar Producción',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD4AF37),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos de Producción',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ordenPedidoCtrl,
              style: TextStyle(color: textColor),
              decoration: _inputDecoration('Orden de Pedido', isDarkMode),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration('Estado', isDarkMode),
              initialValue: estadoSeleccionado,
              dropdownColor: containerBg,
              items: ['Pendiente', 'En proceso', 'Completado', 'Cancelado'].map(
                (e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.montserrat(color: textColor),
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => estadoSeleccionado = val);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fechaInicioCtrl,
                    style: TextStyle(color: textColor),
                    decoration: _inputDecoration('Fecha Inicio', isDarkMode),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: fechaEntregaCtrl,
                    style: TextStyle(color: textColor),
                    decoration: _inputDecoration('Fecha Entrega', isDarkMode),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Divider(color: dividerColor),
            const SizedBox(height: 16),
            Text(
              'Asignación de Operarios y Tareas',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(widget.produccion.detalles.length, (index) {
              final state = detallesState[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: containerBg,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produccion.detalles[index].idDetalleProduccion,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD4AF37),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAutocomplete(
                      'Empleado',
                      state['idEmpleado'],
                      _catalogoEmpleados,
                      isDarkMode,
                      textColor,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAutocomplete(
                            'Pieza',
                            state['idTipoPieza'],
                            _catalogoPiezas,
                            isDarkMode,
                            textColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAutocomplete(
                            'Máquina',
                            state['idTipoMaquina'],
                            _catalogoMaquinas,
                            isDarkMode,
                            textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildAutocomplete(
                      'Insumo (Empresa o Cliente)',
                      state['insumoSeleccionado'],
                      _catalogoInsumosList,
                      isDarkMode,
                      textColor,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: state['cantidad'],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: textColor),
                            decoration: _inputDecoration(
                              'Cantidad',
                              isDarkMode,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: state['fechaAsignada'],
                            style: TextStyle(color: textColor),
                            decoration: _inputDecoration(
                              'Fecha Asignada',
                              isDarkMode,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _guardarCambios,
                child: Text(
                  'Guardar Cambios',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // WIDGET REUTILIZABLE PARA AUTOCOMPLETADO DENTRO DE LA PANTALLA
  Widget _buildAutocomplete(
    String label,
    TextEditingController controller,
    List<String> opciones,
    bool isDarkMode,
    Color textColor,
  ) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return opciones.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            fieldTextEditingController.addListener(() {
              controller.text = fieldTextEditingController.text;
            });

            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              style: TextStyle(color: textColor),
              decoration: _inputDecoration(label, isDarkMode),
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            final Color popBg = isDarkMode
                ? const Color(0xFF2A2A2A)
                : Colors.white;
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                color: popBg,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 75,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            option,
                            style: GoogleFonts.montserrat(color: textColor),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }

  InputDecoration _inputDecoration(String label, bool isDarkMode) {
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        color: isDarkMode ? Colors.grey[500] : const Color(0xFF9E9E9E),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
    );
  }
}
