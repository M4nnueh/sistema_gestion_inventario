import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../widgets/app_drawer.dart';

class ProductosListScreen extends StatelessWidget {
  const ProductosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductoProvider>().loadProductos(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<ProductoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.productos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.productos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.loadProductos,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (provider.productos.isEmpty) {
            return const Center(child: Text('No hay productos registrados'));
          }
          return RefreshIndicator(
            onRefresh: provider.loadProductos,
            child: ListView.builder(
              itemCount: provider.productos.length,
              itemBuilder: (context, index) {
                final p = provider.productos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(p.nombre),
                    subtitle: Text('Precio: \$${p.precio.toStringAsFixed(2)}  |  Cantidad: ${p.cantidad}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/productos/${p.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/productos/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}