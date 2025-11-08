import 'package:citybus_lite/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  static const String name = 'home';
  static const String path = '/';

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    return Center(
      child: FilledButton.tonal(
        onPressed: () => context.go(SettingsRoute.path),
        child: Text(
          'Ir a configuración',
          style: TextStyle(fontSize: textScaler.scale(16)),
        ),
      ),
    );
  }
}
