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
}
