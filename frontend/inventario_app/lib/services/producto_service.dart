import 'package:dio/dio.dart';
import '../models/producto.dart';
import 'api_client.dart';

class ProductoService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Producto>> getProductos() async {
    final res = await _dio.get('/api/productos');
    final data = res.data as List;
    return data.map((e) => Producto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Producto> getProducto(int id) async {
    final res = await _dio.get('/api/productos/$id');
    return Producto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Producto> createProducto(Producto producto) async {
    final res = await _dio.post('/api/productos', data: producto.toJson());
    return Producto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Producto> updateProducto(int id, Producto producto) async {
    final res = await _dio.put('/api/productos/$id', data: producto.toJson());
    return Producto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteProducto(int id) async {
    await _dio.delete('/api/productos/$id');
  }
}