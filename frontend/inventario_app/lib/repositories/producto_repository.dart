import '../models/producto.dart';
import '../services/producto_service.dart';

class ProductoRepository {
  final ProductoService _service;
  ProductoRepository({ProductoService? service}) : _service = service ?? ProductoService();

  Future<List<Producto>> getAll() => _service.getProductos();
  Future<Producto> getById(int id) => _service.getProducto(id);
  Future<Producto> create(Producto producto) => _service.createProducto(producto);
  Future<Producto> update(int id, Producto producto) => _service.updateProducto(id, producto);
  Future<void> delete(int id) => _service.deleteProducto(id);
}