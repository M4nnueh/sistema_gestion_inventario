import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:inventario_app/app.dart';
import 'package:inventario_app/providers/auth_provider.dart';
import 'package:inventario_app/providers/producto_provider.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    final authProvider = AuthProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ],
        child: InventarioApp(authProvider: authProvider),
      ),
    );
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
