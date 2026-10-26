import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../repositories/producto_repository.dart';

class ProductoProvider extends ChangeNotifier {
  final ProductoRepository _repository;
  ProductoProvider({ProductoRepository? repository}) : _repository = repository ?? ProductoRepository();

  List<Producto> _productos = [];
  bool _isLoading = false;
  String? _error;

  List<Producto> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalProductos => _productos.length;
  int get totalUnidades => _productos.fold(0, (sum, p) => sum + p.cantidad);
  double get valorTotal => _productos.fold(0.0, (sum, p) => sum + (p.precio * p.cantidad));

  Future<void> loadProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _repository.getAll();
    } catch (e) {
      _error = _errorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProducto(Producto producto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final created = await _repository.create(producto);
      _productos = [..._productos, created];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _errorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProducto(int id, Producto producto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final updated = await _repository.update(id, producto);
      final idx = _productos.indexWhere((p) => p.id == id);
      if (idx != -1) _productos[idx] = updated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _errorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProducto(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repository.delete(id);
      _productos.removeWhere((p) => p.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _errorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Producto? findById(int id) {
    try {
      return _productos.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  String _errorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'].toString();
      if (e.type == DioExceptionType.connectionError) return 'No se pudo conectar con la API';
      if (e.type == DioExceptionType.receiveTimeout) return 'Tiempo de espera agotado';
      return e.message ?? 'Error de comunicacion';
    }
    return e.toString();
  }
}