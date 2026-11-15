import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';

class InventarioApp extends StatefulWidget {
  final AuthProvider authProvider;
  const InventarioApp({super.key, required this.authProvider});

  @override
  State<InventarioApp> createState() => _InventarioAppState();
}

class _InventarioAppState extends State<InventarioApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(widget.authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gestion de Inventario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF17365D)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
