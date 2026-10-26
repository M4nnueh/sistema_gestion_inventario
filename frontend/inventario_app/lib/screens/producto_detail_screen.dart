import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../providers/producto_provider.dart';
import '../repositories/producto_repository.dart';
import '../widgets/app_drawer.dart';

class ProductoDetailScreen extends StatefulWidget {
  final int productoId;
  const ProductoDetailScreen({super.key, required this.productoId});

  @override
  State<ProductoDetailScreen> createState() => _ProductoDetailScreenState();
}

class _ProductoDetailScreenState extends State<ProductoDetailScreen> {
  final ProductoRepository _repository = ProductoRepository();
  late Future<Producto> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Producto> _load() async {
    final cached = context.read<ProductoProvider>().findById(widget.productoId);
    if (cached != null) return cached;
    return _repository.getById(widget.productoId);
  }

  Future<void> _delete() async {
    final provider = context.read<ProductoProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text('¿Seguro que deseas eliminar este producto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirm != true) return;
    final ok = await provider.deleteProducto(widget.productoId);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
      context.go('/productos');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? 'Error al eliminar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/productos/${widget.productoId}/editar'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _delete,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<Producto>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final p = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(p.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Codigo: ${p.codigo}'),
              Text('Categoria: ${p.categoria}'),
              Text('Precio: \$${p.precio.toStringAsFixed(2)}'),
              Text('Cantidad: ${p.cantidad}'),
              Text('Descripcion: ${p.descripcion ?? '-'}'),
              if (p.id != null) Text('ID: ${p.id}'),
            ],
          );
        },
      ),
    );
  }
}