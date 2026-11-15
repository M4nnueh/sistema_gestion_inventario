import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion de Sesion'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          final isAuth = authProvider.isAuthenticated;
          final hasToken = authProvider.hasToken;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar y encabezado
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: const Color(0xFF17365D),
                      child: Text(
                        user != null && user.nombre.isNotEmpty
                            ? user.nombre[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.nombre ?? 'Sin sesion',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'No autenticado',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tarjeta de información requerida por el taller
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos de Autenticacion JWT',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      _SessionItem(
                        icon: Icons.person_outline,
                        label: 'Nombre del usuario',
                        value: user?.nombre ?? 'N/A',
                      ),
                      _SessionItem(
                        icon: Icons.email_outlined,
                        label: 'Correo electronico',
                        value: user?.email ?? 'N/A',
                      ),
                      _SessionItem(
                        icon: isAuth ? Icons.verified_user : Icons.gpp_bad,
                        label: 'Estado de autenticacion',
                        value: isAuth ? 'Sesion activa' : 'Sin sesion',
                        valueColor: isAuth ? Colors.green.shade700 : Colors.red,
                      ),
                      _SessionItem(
                        icon: hasToken ? Icons.vpn_key : Icons.vpn_key_off,
                        label: 'Indicador de token almacenado',
                        value: hasToken
                            ? 'Presente (flutter_secure_storage)'
                            : 'No almacenado',
                        valueColor: hasToken ? Colors.green.shade700 : Colors.red,
                      ),
                      _SessionItem(
                        icon: Icons.storage_outlined,
                        label: 'Almacenamiento de usuario',
                        value: 'shared_preferences',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de cerrar sesión
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Cerrar sesion'),
                        content: const Text(
                          '¿Esta seguro de cerrar sesion? Se borraran el token JWT y los datos locales de sesion.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Cerrar Sesion'),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;
                    if (!context.mounted) return;

                    await context.read<AuthProvider>().logout();
                    if (!context.mounted) return;
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesion', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SessionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SessionItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF17365D)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
