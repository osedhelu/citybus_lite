import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:citybus_lite/features/home/presentation/screens/home_screen.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  static const String name = 'settings';
  static const String path = '/settings';

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;

    return Center(
      child: FilledButton.tonal(
        onPressed: () => context.go(HomeRoute.path),
        child: Text(
          'Volver al inicio',
          style: TextStyle(fontSize: textScaler.scale(16)),
        ),
      ),
    );
  }
}
