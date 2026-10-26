import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF17365D)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.inventory_2, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text('Inventario App',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Gestion de productos', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Productos'),
            onTap: () {
              Navigator.pop(context);
              context.go('/productos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Nuevo producto'),
            onTap: () {
              Navigator.pop(context);
              context.go('/productos/nuevo');
            },
          ),
        ],
      ),
    );
  }
}