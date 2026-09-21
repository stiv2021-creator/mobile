// lib/models/orden_pedido.dart

class OrdenPedido {
  final String id;
  String idRemision;
  String fecha;
  String estado;

  OrdenPedido({
    required this.id,
    required this.idRemision,
    required this.fecha,
    required this.estado,
  });
}
