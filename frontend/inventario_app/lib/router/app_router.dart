import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/productos_list_screen.dart';
import '../screens/producto_detail_screen.dart';
import '../screens/producto_form_screen.dart';
import '../screens/session_screen.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // Si no está autenticado y no está en la pantalla de login, forzar redirección a login
      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      // Si ya está autenticado e intenta ir a login, redirigir al Dashboard
      if (isAuth && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/productos',
        builder: (context, state) => const ProductosListScreen(),
      ),
      GoRoute(
        path: '/productos/nuevo',
        builder: (context, state) => const ProductoFormScreen(),
      ),
      GoRoute(
        path: '/productos/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductoDetailScreen(productoId: id);
        },
      ),
      GoRoute(
        path: '/productos/:id/editar',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductoFormScreen(productoId: id);
        },
      ),
      GoRoute(
        path: '/sesion',
        builder: (context, state) => const SessionScreen(),
      ),
    ],
  );
}
