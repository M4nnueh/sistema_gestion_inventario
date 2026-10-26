class Producto {
  final int? id;
  final String nombre;
  final String codigo;
  final String? descripcion;
  final double precio;
  final int cantidad;
  final String categoria;

  Producto({
    this.id,
    required this.nombre,
    required this.codigo,
    this.descripcion,
    required this.precio,
    required this.cantidad,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      nombre: (json['nombre'] ?? '').toString(),
      codigo: (json['codigo'] ?? '').toString(),
      descripcion: json['descripcion']?.toString(),
      precio: (json['precio'] is num)
          ? (json['precio'] as num).toDouble()
          : double.tryParse('${json['precio']}') ?? 0.0,
      cantidad: (json['cantidad'] is int)
          ? json['cantidad'] as int
          : int.tryParse('${json['cantidad']}') ?? 0,
      categoria: (json['categoria'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'precio': precio,
      'cantidad': cantidad,
      'categoria': categoria,
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    String? codigo,
    String? descripcion,
    double? precio,
    int? cantidad,
    String? categoria,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      categoria: categoria ?? this.categoria,
    );
  }
}