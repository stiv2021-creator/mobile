import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class VentasView extends StatefulWidget {
  const VentasView({super.key});

  @override
  State<VentasView> createState() => _VentasViewState();
}

class _VentasViewState extends State<VentasView> {
  final List<Venta> _ventas = [
    Venta(
      id: 'VT-001',
      orden: 'OP-1028',
      valor: 245000,
      fecha: DateTime(2026, 9, 17),
      comprobante: 'FAC-1028.pdf',
    ),
    Venta(
      id: 'VT-002',
      orden: 'OP-1025',
      valor: 185000,
      fecha: DateTime(2026, 9, 16),
      comprobante: 'FAC-1025.pdf',
    ),
  ];

  String _search = '';

  List<Venta> get _ventasFiltradas {
    if (_search.trim().isEmpty) {
      return _ventas;
    }
    final texto = _search.toLowerCase();
    return _ventas.where((venta) {
      return venta.orden.toLowerCase().contains(texto) ||
          venta.id.toLowerCase().contains(texto) ||
          venta.comprobante.toLowerCase().contains(texto);
    }).toList();
  }

  double get _totalVentas {
    return _ventas.fold(
      0,
      (total, venta) => total + venta.valor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        backgroundColor: AppColors.bg(context),
        elevation: 0,
        titleSpacing: 20,
        iconTheme: IconThemeData(color: AppColors.text(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ventas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.text(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Gestión de ventas',
              style: TextStyle(
                color: AppColors.muted(context),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _abrirBusqueda,
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            _tarjetaResumen(),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ventas registradas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text(context),
                    ),
                  ),
                ),
                Text(
                  '${_ventas.length}',
                  style: TextStyle(
                    color: AppColors.muted(context),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_search.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.gold,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Buscando: $_search',
                        style: TextStyle(
                          color: AppColors.muted(context),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _search = '';
                        });
                      },
                      child: const Text(
                        'Limpiar',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_ventasFiltradas.isEmpty)
              _estadoVacio()
            else
              ..._ventasFiltradas.map(
                (venta) => _tarjetaVenta(venta),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        elevation: 8,
        onPressed: _agregarVenta,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Agregar venta',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RESUMEN
  // ============================================================
  Widget _tarjetaResumen() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border(context),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _icono(
                Icons.point_of_sale_rounded,
                const Color(0xFF3C3210),
                AppColors.gold,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Resumen de ventas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF173A24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: Color(0xFF37D67A),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Activo',
                      style: TextStyle(
                        color: Color(0xFF69E59B),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _indicador(
                  'Ventas',
                  '${_ventas.length}',
                  'registradas',
                  Icons.receipt_long_rounded,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: AppColors.border(context),
              ),
              Expanded(
                child: _indicador(
                  'Ingresos',
                  _dinero(_totalVentas),
                  'acumulado',
                  Icons.attach_money_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _indicador(
    String titulo,
    String valor,
    String subtitulo,
    IconData icono,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            icono,
            color: AppColors.gold,
            size: 21,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: AppColors.muted(context),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  valor,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text(context),
                  ),
                ),
                Text(
                  subtitulo,
                  style: TextStyle(
                    color: AppColors.muted(context),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARJETA DE VENTA
  // ============================================================
  Widget _tarjetaVenta(Venta venta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border(context),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          _verDetalle(venta);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              _icono(
                Icons.shopping_cart_checkout_rounded,
                const Color(0xFF153A27),
                const Color(0xFF35D27A),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venta.orden,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text(context),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${_fecha(venta.fecha)} • ${venta.comprobante}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.muted(context),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _dinero(venta.valor),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.muted(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AGREGAR VENTA
  // ============================================================
  void _agregarVenta() {
    final formKey = GlobalKey<FormState>();
    final ordenController = TextEditingController();
    final valorController = TextEditingController();
    DateTime fechaSeleccionada = DateTime.now();
    XFile? imagenSeleccionada; // Cambiado a XFile para soporte universal

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            _icono(
                              Icons.add_shopping_cart_rounded,
                              const Color(0xFF3C3210),
                              AppColors.gold,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Agregar venta',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Registra la información de la venta',
                                    style: TextStyle(
                                      color: AppColors.muted(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        _label('Orden de pedido'),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: ordenController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: AppColors.text(context)),
                          decoration: _inputDecoration('Ej. OP-1029', Icons.assignment_outlined),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa la orden de pedido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _label('Valor de venta'),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: valorController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(color: AppColors.text(context)),
                          decoration: _inputDecoration('Ej. 250000', Icons.attach_money_rounded),
                          validator: (value) {
                            final numero = double.tryParse((value ?? '').replaceAll(',', '.'));
                            if (numero == null || numero <= 0) {
                              return 'Ingresa un valor válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _label('Fecha de venta'),
                        const SizedBox(height: 7),
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate: fechaSeleccionada,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (fecha != null) {
                              setModalState(() {
                                fechaSeleccionada = fecha;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: _inputDecoration('', Icons.calendar_month_outlined),
                            child: Text(
                              _fecha(fechaSeleccionada),
                              style: TextStyle(color: AppColors.text(context)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _label('Comprobante de pago'),
                        const SizedBox(height: 7),
                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setModalState(() {
                                imagenSeleccionada = pickedFile;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border(context)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  imagenSeleccionada != null ? Icons.image_rounded : Icons.add_photo_alternate_outlined,
                                  color: imagenSeleccionada != null ? AppColors.gold : AppColors.muted(context),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    imagenSeleccionada != null
                                        ? imagenSeleccionada!.name // Extrae el nombre de forma segura
                                        : 'Seleccionar imagen de la galería...',
                                    style: TextStyle(
                                      color: imagenSeleccionada != null
                                          ? AppColors.text(context)
                                          : AppColors.muted(context),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (imagenSeleccionada != null)
                                  GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        imagenSeleccionada = null;
                                      });
                                    },
                                    child: Icon(Icons.close_rounded, color: AppColors.muted(context), size: 20),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              final valor = double.parse(valorController.text.replaceAll(',', '.'));

                              this.setState(() {
                                _ventas.insert(
                                  0,
                                  Venta(
                                    id: 'VT-${(_ventas.length + 1).toString().padLeft(3, '0')}',
                                    orden: ordenController.text.trim(),
                                    valor: valor,
                                    fecha: fechaSeleccionada,
                                    comprobante: imagenSeleccionada != null 
                                        ? imagenSeleccionada!.name 
                                        : 'Sin comprobante',
                                    rutaImagen: imagenSeleccionada?.path,
                                  ),
                                );
                              });

                              Navigator.pop(modalContext);
                              _mensaje('Venta registrada correctamente');
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text(
                              'Guardar venta',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // DETALLE
  // ============================================================
  void _verDetalle(Venta venta) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _icono(
                            Icons.receipt_long_rounded,
                            const Color(0xFF153A27),
                            const Color(0xFF35D27A),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Detalle de venta',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text(context),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: AppColors.text(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _filaDetalle('Orden de pedido', venta.orden),
                      _filaDetalle('Valor', _dinero(venta.valor), resaltado: true),
                      _filaDetalle('Fecha', _fecha(venta.fecha)),
                      _filaDetalle('Comprobante', venta.comprobante),

                      if (venta.rutaImagen != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Imagen del comprobante:',
                          style: TextStyle(
                            color: AppColors.text(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          // Aquí validamos si estamos en Web para usar Image.network
                          child: kIsWeb 
                              ? Image.network(
                                  venta.rutaImagen!,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(venta.rutaImagen!),
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _mensaje('Esta venta no tiene una imagen adjunta');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gold,
                              side: const BorderSide(color: AppColors.gold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.image_not_supported_outlined),
                            label: const Text(
                              'Sin imagen de comprobante',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filaDetalle(String titulo, String valor, {bool resaltado = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppColors.border(context),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                color: AppColors.muted(context),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: resaltado ? AppColors.gold : AppColors.text(context),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUSCAR
  // ============================================================
  void _abrirBusqueda() {
    final controller = TextEditingController(text: _search);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            MediaQuery.of(context).viewInsets.bottom + 30,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border(context),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Buscar ventas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text(context),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                style: TextStyle(color: AppColors.text(context)),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
                decoration: _inputDecoration('Orden o comprobante...', Icons.search_rounded),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Aplicar búsqueda',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ESTADO VACÍO
  // ============================================================
  Widget _estadoVacio() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 42,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border(context),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 42,
            color: AppColors.muted(context),
          ),
          const SizedBox(height: 12),
          Text(
            'No hay ventas para mostrar',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Agrega una venta o cambia la búsqueda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPONENTES
  // ============================================================
  Widget _icono(IconData icono, Color fondo, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icono,
        color: color,
        size: 21,
      ),
    );
  }

  Widget _label(String texto) {
    return Text(
      texto,
      style: TextStyle(
        color: AppColors.text(context),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.card(context),
      hintStyle: TextStyle(color: AppColors.muted(context)),
      prefixIcon: Icon(icon, color: AppColors.muted(context)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
    );
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.card(context),
      ),
    );
  }
}

// ============================================================
// MODELO VENTA
// ============================================================
class Venta {
  final String id;
  final String orden;
  final double valor;
  final DateTime fecha;
  final String comprobante;
  final String? rutaImagen;

  const Venta({
    required this.id,
    required this.orden,
    required this.valor,
    required this.fecha,
    required this.comprobante,
    this.rutaImagen,
  });
}

// ============================================================
// COLORES DEL DISEÑO DINÁMICO
// ============================================================
class AppColors {
  static const Color gold = Color(0xFFC5A326);

  static Color bg(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
      
  static Color surface(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF171717) : Colors.white;
      
  static Color card(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1F1F1F) : Colors.white;
      
  static Color border(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0);
      
  static Color muted(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFFB7B7B7) : const Color(0xFF757575);
      
  static Color text(BuildContext context) => 
      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87;
}

// ============================================================
// FUNCIONES
// ============================================================
String _dinero(double valor) {
  final numero = valor.round().toString();
  final caracteres = numero.split('');
  final resultado = StringBuffer();
  for (int i = 0; i < caracteres.length; i++) {
    final posicion = caracteres.length - i;
    resultado.write(caracteres[i]);
    if (posicion > 1 && posicion % 3 == 1) {
      resultado.write('.');
    }
  }
  return '\$${resultado.toString()}';
}

String _fecha(DateTime fecha) {
  final dia = fecha.day.toString().padLeft(2, '0');
  final mes = fecha.month.toString().padLeft(2, '0');
  return '$dia/$mes/${fecha.year}';
}