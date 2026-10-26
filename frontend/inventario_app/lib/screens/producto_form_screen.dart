import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/producto_provider.dart';
import '../repositories/producto_repository.dart';

class ProductoFormScreen extends StatefulWidget {
  final int? productoId;
  const ProductoFormScreen({super.key, this.productoId});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();

  final ProductoRepository _repository = ProductoRepository();
  bool _loading = true;
  bool _submitting = false;

  bool get isEdit => widget.productoId != null;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (isEdit) {
      final cached = context.read<ProductoProvider>().findById(widget.productoId!);
      Producto? p = cached;
      if (p == null) {
        try {
          p = await _repository.getById(widget.productoId!);
        } catch (_) {
          p = null;
        }
      }
      if (p != null) {
        _nombreCtrl.text = p.nombre;
        _codigoCtrl.text = p.codigo;
        _descripcionCtrl.text = p.descripcion ?? '';
        _precioCtrl.text = p.precio.toString();
        _cantidadCtrl.text = p.cantidad.toString();
        _categoriaCtrl.text = p.categoria;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _codigoCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _cantidadCtrl.dispose();
    _categoriaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final producto = Producto(
      id: widget.productoId,
      nombre: _nombreCtrl.text.trim(),
      codigo: _codigoCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
      precio: double.parse(_precioCtrl.text.trim()),
      cantidad: int.parse(_cantidadCtrl.text.trim()),
      categoria: _categoriaCtrl.text.trim(),
    );
    final provider = context.read<ProductoProvider>();
    bool ok;
    if (isEdit) {
      ok = await provider.updateProducto(widget.productoId!, producto);
    } else {
      ok = await provider.addProducto(producto);
    }
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEdit ? 'Producto actualizado' : 'Producto registrado')),
      );
      context.go('/productos');
    } else {
      final err = provider.error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Error al guardar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar producto' : 'Nuevo producto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
            ),
            TextFormField(
              controller: _codigoCtrl,
              decoration: const InputDecoration(labelText: 'Codigo'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
            ),
            TextFormField(
              controller: _descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripcion (opcional)'),
            ),
            TextFormField(
              controller: _precioCtrl,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obligatorio';
                final n = double.tryParse(v.trim());
                if (n == null || n < 0) return 'Numero valido >= 0';
                return null;
              },
            ),
            TextFormField(
              controller: _cantidadCtrl,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obligatorio';
                final n = int.tryParse(v.trim());
                if (n == null || n < 0) return 'Entero valido >= 0';
                return null;
              },
            ),
            TextFormField(
              controller: _categoriaCtrl,
              decoration: const InputDecoration(labelText: 'Categoria'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isEdit ? 'Actualizar' : 'Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}