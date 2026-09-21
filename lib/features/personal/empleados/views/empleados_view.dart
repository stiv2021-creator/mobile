import 'package:flutter/material.dart';

class EmpleadosView extends StatefulWidget {
  const EmpleadosView({super.key});

  @override
  State<EmpleadosView> createState() => _EmpleadosViewState();
}

class _EmpleadosViewState extends State<EmpleadosView> {
  String _searchQuery = '';

  final List<Map<String, String>> _empleados = [
    {
      'id_Empleados': 'EMP001',
      'Nombre': 'Axebiel Galvis',
      'Identificacion': '1098765432',
      'Correo': 'axebiel@empresa.com',
      'Telefono': '+57 310 691 2124',
      'Direccion': 'San Cristóbal, Calle 5',
      'Contraseña': '••••••••',
      'Estado': 'Activo',
      'id_Rol': 'Administrador',
    },
    {
      'id_Empleados': 'EMP002',
      'Nombre': 'María Rodríguez',
      'Identificacion': '1023456789',
      'Correo': 'maria.r@empresa.com',
      'Telefono': '+57 300 123 4567',
      'Direccion': 'Av. Principal #45',
      'Contraseña': '••••••••',
      'Estado': 'Activo',
      'id_Rol': 'Empleado',
    },
    {
      'id_Empleados': 'EMP003',
      'Nombre': 'Carlos Mendoza',
      'Identificacion': '987654321',
      'Correo': 'carlos.m@empresa.com',
      'Telefono': '+57 315 987 6543',
      'Direccion': 'Carrera 12 #8-30',
      'Contraseña': '••••••••',
      'Estado': 'Inactivo',
      'id_Rol': 'Empleado',
    },
  ];

  List<Map<String, String>> get _empleadosFiltrados {
    if (_searchQuery.isEmpty) return _empleados;

    final query = _searchQuery.toLowerCase();

    return _empleados.where((emp) {
      return (emp['Nombre']?.toLowerCase().contains(query) ?? false) ||
          (emp['id_Empleados']?.toLowerCase().contains(query) ?? false) ||
          (emp['Identificacion']?.toLowerCase().contains(query) ?? false) ||
          (emp['id_Rol']?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  String _generarNuevoId() {
    int maxId = 0;

    for (var emp in _empleados) {
      final idStr =
          emp['id_Empleados']?.replaceAll('EMP', '') ?? '0';

      final idNum = int.tryParse(idStr) ?? 0;

      if (idNum > maxId) {
        maxId = idNum;
      }
    }

    return 'EMP${(maxId + 1).toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el tema REAL que está usando la aplicación.
    // Este cambia automáticamente desde el Sidebar.
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF8F9FA);

    final cardColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final inputColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F3F5);

    final primaryTextColor =
        isDark ? Colors.white : const Color(0xFF212529);

    final secondaryTextColor =
        isDark ? const Color(0xFFA0A0A0) : const Color(0xFF6C757D);

    const accentColor = Color(0xFFE5B012);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    final lista = _empleadosFiltrados;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Empleados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            Text(
              'Gestión de personal y acceso',
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),

        // YA NO HAY BOTÓN LIGHT/DARK AQUÍ.
        // El cambio de tema lo controla el Sidebar.
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 16,
              top: 12,
              bottom: 12,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1B382B)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF21C063)
                        : const Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${lista.length}',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF21C063)
                        : const Color(0xFF2E7D32),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),

          child: Column(
            children: [
              const SizedBox(height: 8),

              TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },

                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                ),

                decoration: InputDecoration(
                  hintText:
                      'Buscar por nombre, cédula o rol...',

                  hintStyle: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),

                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: accentColor,
                    size: 20,
                  ),

                  filled: true,
                  fillColor: cardColor,

                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: borderColor),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: accentColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: lista.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search_outlined,
                              size: 48,
                              color: secondaryTextColor,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'No se encontraron empleados',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: lista.length,
                        physics:
                            const BouncingScrollPhysics(),

                        itemBuilder: (context, index) {
                          return _buildCardEmpleado(
                            emp: lista[index],
                            cardColor: cardColor,
                            primaryText: primaryTextColor,
                            secondaryText: secondaryTextColor,
                            accentColor: accentColor,
                            borderColor: borderColor,
                            inputColor: inputColor,
                            isDark: isDark,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        elevation: 3,
        backgroundColor: accentColor,

        onPressed: () => _mostrarFormulario(
          cardColor: cardColor,
          primaryText: primaryTextColor,
          secondaryText: secondaryTextColor,
          accentColor: accentColor,
          inputColor: inputColor,
        ),

        icon: const Icon(
          Icons.add_rounded,
          color: Colors.black,
        ),

        label: const Text(
          'Empleado',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCardEmpleado({
    required Map<String, String> emp,
    required Color cardColor,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required Color borderColor,
    required Color inputColor,
    required bool isDark,
  }) {
    final bool esActivo = emp['Estado'] == 'Activo';
    final bool esAdmin = emp['id_Rol'] == 'Administrador';

    final activeBg = isDark
        ? const Color(0xFF1B382B)
        : const Color(0xFFE8F5E9);

    final activeText = isDark
        ? const Color(0xFF21C063)
        : const Color(0xFF2E7D32);

    final inactiveBg = isDark
        ? const Color(0xFF381B1B)
        : const Color(0xFFFFEBEE);

    final inactiveText = isDark
        ? const Color(0xFFFF5252)
        : const Color(0xFFC62828);

    final String empId =
        emp['id_Empleados'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color:
                      Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [
              CircleAvatar(
                radius: 20,

                backgroundColor: isDark
                    ? const Color(0xFF2D2200)
                    : const Color(0xFFFFF8E1),

                child: Text(
                  (emp['Nombre'] ?? 'E')[0]
                      .toUpperCase(),

                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      emp['Nombre'] ?? '',

                      style: TextStyle(
                        color: primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'ID: $empId  •  C.C: ${emp['Identificacion'] ?? 'N/A'}',

                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    emp['Estado'] =
                        esActivo
                            ? 'Inactivo'
                            : 'Activo';
                  });
                },

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: esActivo
                        ? activeBg
                        : inactiveBg,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    emp['Estado'] ?? 'Activo',

                    style: TextStyle(
                      color: esActivo
                          ? activeText
                          : inactiveText,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              thickness: 0.5,
            ),
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),

                      decoration: BoxDecoration(
                        color: esAdmin
                            ? accentColor
                                .withValues(alpha: 0.15)
                            : primaryText
                                .withValues(alpha: 0.05),

                        borderRadius:
                            BorderRadius.circular(6),
                      ),

                      child: Text(
                        emp['id_Rol'] ??
                            "Empleado",

                        style: TextStyle(
                          color: esAdmin
                              ? accentColor
                              : primaryText
                                  .withValues(alpha: 0.8),

                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 12,
                          color: secondaryText,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            emp['Correo'] ?? "N/A",

                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),

                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: secondaryText,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          emp['Telefono'] ?? "N/A",

                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  IconButton(
                    visualDensity:
                        VisualDensity.compact,

                    icon: Icon(
                      Icons.edit_outlined,
                      color:
                          primaryText.withValues(alpha: 0.7),
                      size: 20,
                    ),

                    onPressed: () =>
                        _mostrarFormulario(
                      empleado: emp,
                      cardColor: cardColor,
                      primaryText: primaryText,
                      secondaryText:
                          secondaryText,
                      accentColor: accentColor,
                      inputColor: inputColor,
                    ),
                  ),

                  IconButton(
                    visualDensity:
                        VisualDensity.compact,

                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color:
                          Color(0xFFFF5252),
                      size: 20,
                    ),

                    onPressed: () =>
                        _confirmarEliminacion(
                      empId,
                      isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario({
    Map<String, String>? empleado,
    required Color cardColor,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required Color inputColor,
  }) {
    final esEdicion = empleado != null;

    final nombreCtrl = TextEditingController(
      text: empleado?['Nombre'] ?? '',
    );

    final docCtrl = TextEditingController(
      text: empleado?['Identificacion'] ?? '',
    );

    final correoCtrl = TextEditingController(
      text: empleado?['Correo'] ?? '',
    );

    final telCtrl = TextEditingController(
      text: empleado?['Telefono'] ?? '',
    );

    final dirCtrl = TextEditingController(
      text: empleado?['Direccion'] ?? '',
    );

    final passCtrl = TextEditingController(
      text: empleado?['Contraseña'] ?? '',
    );

    String rolSel =
        empleado?['id_Rol'] ?? 'Empleado';

    if (rolSel != 'Administrador' &&
        rolSel != 'Empleado') {
      rolSel = 'Empleado';
    }

    String estadoSel =
        empleado?['Estado'] ?? 'Activo';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 12,
                left: 20,
                right: 20,
                bottom:
                    MediaQuery.of(context)
                            .viewInsets
                            .bottom +
                        20,
              ),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,

                        margin:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),

                        decoration:
                            BoxDecoration(
                          color: secondaryText
                              .withValues(alpha: 0.3),

                          borderRadius:
                              BorderRadius.circular(
                                  2),
                        ),
                      ),
                    ),

                    Text(
                      esEdicion
                          ? 'Editar Empleado'
                          : 'Nuevo Empleado',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                        color: primaryText,
                      ),
                    ),

                    if (esEdicion &&
                        empleado[
                                'id_Empleados'] !=
                            null)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                                top: 2.0),

                        child: Text(
                          'ID: ${empleado['id_Empleados']}',

                          style: TextStyle(
                            fontSize: 12,
                            color: accentColor,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    _field(
                      nombreCtrl,
                      'Nombre Completo',
                      Icons.person_outline,
                      inputColor,
                      primaryText,
                      secondaryText,
                    ),

                    _field(
                      docCtrl,
                      'Identificación / Cédula',
                      Icons.badge_outlined,
                      inputColor,
                      primaryText,
                      secondaryText,
                      keyboardType:
                          TextInputType.number,
                    ),

                    _field(
                      correoCtrl,
                      'Correo Electrónico',
                      Icons.email_outlined,
                      inputColor,
                      primaryText,
                      secondaryText,
                      keyboardType:
                          TextInputType.emailAddress,
                    ),

                    _field(
                      telCtrl,
                      'Teléfono',
                      Icons.phone_outlined,
                      inputColor,
                      primaryText,
                      secondaryText,
                      keyboardType:
                          TextInputType.phone,
                    ),

                    _field(
                      dirCtrl,
                      'Dirección',
                      Icons.location_on_outlined,
                      inputColor,
                      primaryText,
                      secondaryText,
                    ),

                    if (!esEdicion)
                      _field(
                        passCtrl,
                        'Contraseña',
                        Icons.lock_outline,
                        inputColor,
                        primaryText,
                        secondaryText,
                        obscure: true,
                      ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                'Rol',
                                style: TextStyle(
                                  color:
                                      secondaryText,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                              const SizedBox(
                                  height: 4),

                              DropdownButtonFormField<
                                  String>(
                                initialValue: rolSel,

                                dropdownColor:
                                    cardColor,

                                style: TextStyle(
                                  color:
                                      primaryText,
                                  fontSize: 13,
                                ),

                                decoration:
                                    _inputDec(
                                  inputColor,
                                ),

                                items: [
                                  'Administrador',
                                  'Empleado'
                                ]
                                    .map(
                                      (r) =>
                                          DropdownMenuItem(
                                        value: r,
                                        child:
                                            Text(r),
                                      ),
                                    )
                                    .toList(),

                                onChanged:
                                    (val) {
                                  if (val !=
                                      null) {
                                    setModalState(
                                      () {
                                        rolSel =
                                            val;
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                'Estado',
                                style: TextStyle(
                                  color:
                                      secondaryText,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                              const SizedBox(
                                  height: 4),

                              DropdownButtonFormField<
                                  String>(
                                initialValue:
                                    estadoSel,

                                dropdownColor:
                                    cardColor,

                                style: TextStyle(
                                  color:
                                      primaryText,
                                  fontSize: 13,
                                ),

                                decoration:
                                    _inputDec(
                                  inputColor,
                                ),

                                items: [
                                  'Activo',
                                  'Inactivo'
                                ]
                                    .map(
                                      (e) =>
                                          DropdownMenuItem(
                                        value: e,
                                        child:
                                            Text(e),
                                      ),
                                    )
                                    .toList(),

                                onChanged:
                                    (val) {
                                  if (val !=
                                      null) {
                                    setModalState(
                                      () {
                                        estadoSel =
                                            val;
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              accentColor,
                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                        ),

                        onPressed: () {
                          if (nombreCtrl
                              .text
                              .isEmpty) {
                            return;
                          }

                          setState(() {
                            final String idEmp =
                                (esEdicion &&
                                        empleado[
                                                'id_Empleados'] !=
                                            null)
                                    ? empleado[
                                        'id_Empleados']!
                                    : _generarNuevoId();

                            final datos =
                                <String, String>{
                              'id_Empleados':
                                  idEmp,
                              'Nombre':
                                  nombreCtrl
                                      .text,
                              'Identificacion':
                                  docCtrl.text,
                              'Correo':
                                  correoCtrl.text,
                              'Telefono':
                                  telCtrl.text,
                              'Direccion':
                                  dirCtrl.text,
                              'Contraseña':
                                  passCtrl.text,
                              'Estado':
                                  estadoSel,
                              'id_Rol':
                                  rolSel,
                            };

                            if (esEdicion) {
                              final idx =
                                  _empleados
                                      .indexWhere(
                                (e) =>
                                    e['id_Empleados'] ==
                                    idEmp,
                              );

                              if (idx != -1) {
                                _empleados[
                                    idx] = datos;
                              }
                            } else {
                              _empleados
                                  .add(datos);
                            }
                          });

                          Navigator.pop(context);
                        },

                        child: Text(
                          esEdicion
                              ? 'Actualizar Datos'
                              : 'Guardar Empleado',

                          style:
                              const TextStyle(
                            color: Colors.black,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmarEliminacion(
    String id,
    bool isDark,
  ) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? const Color(0xFF222222)
            : Colors.white,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),

        title: Text(
          'Eliminar Empleado',

          style: TextStyle(
            color:
                isDark
                    ? Colors.white
                    : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        content: Text(
          '¿Estás seguro de que deseas eliminar al empleado $id?',

          style: TextStyle(
            color: isDark
                ? const Color(0xFFA0A0A0)
                : Colors.black87,
            fontSize: 14,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),

            child: Text(
              'Cancelar',

              style: TextStyle(
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          ),

          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFFF5252),
              elevation: 0,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8),
              ),
            ),

            onPressed: () {
              setState(() {
                _empleados.removeWhere(
                  (e) =>
                      e['id_Empleados'] ==
                      id,
                );
              });

              Navigator.pop(context);
            },

            child: const Text(
              'Eliminar',

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    Color fillColor,
    Color textColor,
    Color labelColor, {
    bool obscure = false,
    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0),

      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,

        style: TextStyle(
          color: textColor,
          fontSize: 13,
        ),

        decoration:
            _inputDec(fillColor).copyWith(
          labelText: label,

          labelStyle: TextStyle(
            color: labelColor,
            fontSize: 13,
          ),

          prefixIcon: Icon(
            icon,
            color:
                labelColor.withValues(alpha: 0.7),
            size: 18,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(
    Color fillColor,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: fillColor,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide:
            BorderSide.none,
      ),
    );
  }
}