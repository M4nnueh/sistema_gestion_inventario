import 'package:go_router/go_router.dart';
import '../screens/dashboard_screen.dart';
import '../screens/productos_list_screen.dart';
import '../screens/producto_detail_screen.dart';
import '../screens/producto_form_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
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
  ],
);