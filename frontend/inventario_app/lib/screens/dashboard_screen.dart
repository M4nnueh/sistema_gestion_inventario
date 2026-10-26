import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/producto_provider.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
          return RefreshIndicator(
            onRefresh: provider.loadProductos,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Sistema de Gestion de Inventario',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Indicadores en tiempo real desde la API'),
                const SizedBox(height: 16),
                _StatCard(
                  title: 'Total de productos',
                  value: '${provider.totalProductos}',
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Unidades disponibles',
                  value: '${provider.totalUnidades}',
                  icon: Icons.numbers,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Valor total del inventario',
                  value: '\$${provider.valorTotal.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.go('/productos'),
                  icon: const Icon(Icons.list),
                  label: const Text('Gestionar productos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}