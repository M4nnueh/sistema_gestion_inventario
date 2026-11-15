import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF17365D)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white24,
                  child: Text(
                    user != null && user.nombre.isNotEmpty
                        ? user.nombre[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.nombre ?? 'Inventario App',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? 'Sesión activa',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Informacion de Sesion'),
            onTap: () {
              Navigator.pop(context);
              context.go('/sesion');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesion', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
