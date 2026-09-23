import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/produccion_model.dart';
import '../widgets/produccion_card.dart';

class ProduccionView extends StatefulWidget {
  const ProduccionView({super.key});

  @override
  State<ProduccionView> createState() => _ProduccionViewState();
}

class _ProduccionViewState extends State<ProduccionView> {
  String _filtroEstado = 'Todos';
  String _busqueda = '';
  List<ProduccionModel> _producciones = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosLocales();
  }

  // 1. Cargar datos desde el almacenamiento local del celular
  Future<void> _cargarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    final String? datosJson = prefs.getString('eslabon_producciones_v2');

    if (datosJson != null) {
      final List<dynamic> listaDecodificada = jsonDecode(datosJson);
      setState(() {
        _producciones = listaDecodificada
            .map((item) => ProduccionModel.fromJson(item))
            .toList();
        _cargando = false;
      });
    } else {
      // Si es la primera vez, cargamos los 10 ejemplos por defecto y los guardamos
      setState(() {
        _producciones = _ejemplosIniciales;
        _cargando = false;
      });
      _guardarDatosLocales();
    }
  }

  // 2. Guardar datos en el almacenamiento local del celular
  Future<void> _guardarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    final String datosJson = jsonEncode(
      _producciones.map((p) => p.toJson()).toList(),
    );
    await prefs.setString('eslabon_producciones_v2', datosJson);
  }

  // Los 10 ejemplos iniciales
  final List<ProduccionModel> _ejemplosIniciales = [
    ProduccionModel(
      idProduccion: "PROD-001",
      idOrdenPedido: "ORD-1045",
      fechaInicio: "2026-09-01",
      fechaEntrega: "2026-09-15",
      estado: "En proceso",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-001",
          idEmpleado: "Juan Pérez",
          idTipoPieza: "Manga Larga",
          idTipoMaquina: "Plana Industrial",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Tela de algodón",
          cantidadAsignada: "30",
          fechaAsignada: "2026-09-05",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-002",
      idOrdenPedido: "ORD-1046",
      fechaInicio: "2026-09-10",
      fechaEntrega: "2026-09-25",
      estado: "Pendiente",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-002",
          idEmpleado: "María Rodríguez",
          idTipoPieza: "Cuello Polo",
          idTipoMaquina: "Fileteadora",
          idInsumosEnviadosXCliente: "Cierres personalizados",
          idInsumos: "N/A",
          cantidadAsignada: "15",
          fechaAsignada: "2026-09-11",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-003",
      idOrdenPedido: "ORD-1047",
      fechaInicio: "2026-09-02",
      fechaEntrega: "2026-09-12",
      estado: "Completado",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-003",
          idEmpleado: "Carlos López",
          idTipoPieza: "Frente Camisa",
          idTipoMaquina: "Colcollarin",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Tela lona",
          cantidadAsignada: "50",
          fechaAsignada: "2026-09-03",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-004",
      idOrdenPedido: "ORD-1048",
      fechaInicio: "2026-09-04",
      fechaEntrega: "2026-09-18",
      estado: "En proceso",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-004",
          idEmpleado: "Ana Gómez",
          idTipoPieza: "Bolsillo",
          idTipoMaquina: "Ojaladora",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Hilo resistente negro",
          cantidadAsignada: "40",
          fechaAsignada: "2026-09-06",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-005",
      idOrdenPedido: "ORD-1049",
      fechaInicio: "2026-09-05",
      fechaEntrega: "2026-09-20",
      estado: "Pendiente",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-005",
          idEmpleado: "Juan Pérez",
          idTipoPieza: "Manga Larga",
          idTipoMaquina: "Plana Industrial",
          idInsumosEnviadosXCliente: "Botones de metal grabados",
          idInsumos: "N/A",
          cantidadAsignada: "25",
          fechaAsignada: "2026-09-08",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-006",
      idOrdenPedido: "ORD-1050",
      fechaInicio: "2026-09-06",
      fechaEntrega: "2026-09-22",
      estado: "Cancelado",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-006",
          idEmpleado: "María Rodríguez",
          idTipoPieza: "Cuello Polo",
          idTipoMaquina: "Fileteadora",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Tela lona",
          cantidadAsignada: "60",
          fechaAsignada: "2026-09-09",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-007",
      idOrdenPedido: "ORD-1051",
      fechaInicio: "2026-09-08",
      fechaEntrega: "2026-09-30",
      estado: "En proceso",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-007",
          idEmpleado: "Carlos López",
          idTipoPieza: "Frente Camisa",
          idTipoMaquina: "Plana Industrial",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Tela de algodón",
          cantidadAsignada: "35",
          fechaAsignada: "2026-09-10",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-008",
      idOrdenPedido: "ORD-1052",
      fechaInicio: "2026-09-09",
      fechaEntrega: "2026-10-02",
      estado: "Completado",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-008",
          idEmpleado: "Ana Gómez",
          idTipoPieza: "Bolsillo",
          idTipoMaquina: "Colcollarin",
          idInsumosEnviadosXCliente: "Cierres personalizados",
          idInsumos: "N/A",
          cantidadAsignada: "45",
          fechaAsignada: "2026-09-11",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-009",
      idOrdenPedido: "ORD-1053",
      fechaInicio: "2026-09-11",
      fechaEntrega: "2026-10-05",
      estado: "Pendiente",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-009",
          idEmpleado: "Juan Pérez",
          idTipoPieza: "Manga Larga",
          idTipoMaquina: "Fileteadora",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "Hilo resistente negro",
          cantidadAsignada: "55",
          fechaAsignada: "2026-09-12",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-010",
      idOrdenPedido: "ORD-1054",
      fechaInicio: "2026-09-12",
      fechaEntrega: "2026-10-10",
      estado: "En proceso",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-010",
          idEmpleado: "Carlos López",
          idTipoPieza: "Cuello Polo",
          idTipoMaquina: "Ojaladora",
          idInsumosEnviadosXCliente: "Botones de metal grabados",
          idInsumos: "N/A",
          cantidadAsignada: "20",
          fechaAsignada: "2026-09-14",
          detalleRem: "",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF121212);
    final Color subtitleColor = isDarkMode
        ? Colors.grey[400]!
        : const Color(0xFF6B6B6B);
    final Color inputFillColor = isDarkMode
        ? const Color(0xFF252525)
        : Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    final Color chipBgColor = isDarkMode
        ? const Color(0xFF252525)
        : Colors.white;

    if (_cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );
    }

    final produccionesFiltradas = _producciones.where((p) {
      final coincideEstado =
          _filtroEstado == 'Todos' || p.estado == _filtroEstado;
      final coincideBusqueda =
          p.idProduccion.toLowerCase().contains(_busqueda.toLowerCase()) ||
          p.idOrdenPedido.toLowerCase().contains(_busqueda.toLowerCase());
      return coincideEstado && coincideBusqueda;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gestión de Producción',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.factory_outlined,
                  color: Color(0xFFD4AF37),
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Producción',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${produccionesFiltradas.length} registros encontrados',
              style: GoogleFonts.montserrat(fontSize: 13, color: subtitleColor),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => setState(() => _busqueda = val),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Buscar por código o pedido...',
                hintStyle: GoogleFonts.montserrat(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: inputFillColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      'Todos',
                      'En proceso',
                      'Pendiente',
                      'Completado',
                      'Cancelado',
                    ].map((estado) {
                      final isSelected = _filtroEstado == estado;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(estado),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.15),
                          backgroundColor: chipBgColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : borderColor,
                          ),
                          labelStyle: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : subtitleColor,
                          ),
                          onSelected: (val) =>
                              setState(() => _filtroEstado = estado),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: produccionesFiltradas.length,
                itemBuilder: (context, index) {
                  return ProduccionCard(
                    produccion: produccionesFiltradas[index],
                    onUpdate: (updatedProd) {
                      setState(() {
                        final pIndex = _producciones.indexWhere(
                          (p) => p.idProduccion == updatedProd.idProduccion,
                        );
                        if (pIndex != -1) {
                          _producciones[pIndex] = updatedProd;
                          _guardarDatosLocales(); // 👈 Guarda automáticamente al actualizar
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
