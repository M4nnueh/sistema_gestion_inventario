import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/producto_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Permite ejecutar sin asset en entornos de prueba.
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductoProvider()..loadProductos(),
      child: const InventarioApp(),
    ),
  );
}