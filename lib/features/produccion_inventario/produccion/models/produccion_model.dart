class ProduccionModel {
  String idProduccion;
  String idOrdenPedido;
  String fechaInicio;
  String fechaEntrega;
  String estado;
  List<DetalleProduccionModel> detalles;

  ProduccionModel({
    required this.idProduccion,
    required this.idOrdenPedido,
    required this.fechaInicio,
    required this.fechaEntrega,
    required this.estado,
    required this.detalles,
  });

  // Convertir de Map (JSON) a Objeto ProduccionModel
  factory ProduccionModel.fromJson(Map<String, dynamic> json) {
    return ProduccionModel(
      idProduccion: json['idProduccion'] ?? '',
      idOrdenPedido: json['idOrdenPedido'] ?? '',
      fechaInicio: json['fechaInicio'] ?? '',
      fechaEntrega: json['fechaEntrega'] ?? '',
      estado: json['estado'] ?? '',
      detalles:
          (json['detalles'] as List<dynamic>?)
              ?.map((x) => DetalleProduccionModel.fromJson(x))
              .toList() ??
          [],
    );
  }

  // Convertir de Objeto ProduccionModel a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idProduccion': idProduccion,
      'idOrdenPedido': idOrdenPedido,
      'fechaInicio': fechaInicio,
      'fechaEntrega': fechaEntrega,
      'estado': estado,
      'detalles': detalles.map((x) => x.toJson()).toList(),
    };
  }
}

class DetalleProduccionModel {
  String idDetalleProduccion;
  String idEmpleado;
  String idTipoPieza;
  String idTipoMaquina;
  String idInsumos;
  String idInsumosEnviadosXCliente;
  String cantidadAsignada;
  String fechaAsignada;
  String detalleRem;

  DetalleProduccionModel({
    required this.idDetalleProduccion,
    required this.idEmpleado,
    required this.idTipoPieza,
    required this.idTipoMaquina,
    required this.idInsumos,
    required this.idInsumosEnviadosXCliente,
    required this.cantidadAsignada,
    required this.fechaAsignada,
    required this.detalleRem,
  });

  // Convertir de Map (JSON) a Objeto DetalleProduccionModel
  factory DetalleProduccionModel.fromJson(Map<String, dynamic> json) {
    return DetalleProduccionModel(
      idDetalleProduccion: json['idDetalleProduccion'] ?? '',
      idEmpleado: json['idEmpleado'] ?? '',
      idTipoPieza: json['idTipoPieza'] ?? '',
      idTipoMaquina: json['idTipoMaquina'] ?? '',
      idInsumos: json['idInsumos'] ?? '',
      idInsumosEnviadosXCliente: json['idInsumosEnviadosXCliente'] ?? '',
      cantidadAsignada: json['cantidadAsignada'] ?? '',
      fechaAsignada: json['fechaAsignada'] ?? '',
      detalleRem: json['detalleRem'] ?? '',
    );
  }

  // Convertir de Objeto DetalleProduccionModel a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idDetalleProduccion': idDetalleProduccion,
      'idEmpleado': idEmpleado,
      'idTipoPieza': idTipoPieza,
      'idTipoMaquina': idTipoMaquina,
      'idInsumos': idInsumos,
      'idInsumosEnviadosXCliente': idInsumosEnviadosXCliente,
      'cantidadAsignada': cantidadAsignada,
      'fechaAsignada': fechaAsignada,
      'detalleRem': detalleRem,
    };
  }
}
