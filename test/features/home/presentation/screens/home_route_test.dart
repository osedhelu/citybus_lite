import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/presentation/providers/home_provider.dart';
import 'package:citybus_lite/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeProvider implements InterfaceHomeProvider {
  _FakeHomeProvider(List<BusRouteEntity> routes)
      : _routes = List<BusRouteEntity>.from(routes);

  List<BusRouteEntity> _routes;

  @override
  List<BusRouteEntity> get data => List<BusRouteEntity>.unmodifiable(_routes);

  @override
  Future<BusRouteEntity?> getRouteById(int routeId) async {
    final index = _routes.indexWhere((route) => route.id == routeId);
    if (index == -1) {
      return null;
    }
    return _routes[index];
  }

  @override
  Future<void> markAsFavorite(int routeId) async {
    _routes = _routes
        .map(
          (route) => route.id == routeId
              ? route.copyWith(isFavorite: true)
              : route,
        )
        .toList();
  }

  @override
  Future<List<BusRouteEntity>> resetData() async {
    return data;
  }

  @override
  Future<List<BusRouteEntity>> searchRoutes(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return data;
    }

    return _routes
        .where(
          (route) =>
              route.code.toLowerCase().contains(normalized) ||
              route.name.toLowerCase().contains(normalized),
        )
        .toList();
  }

  @override
  Future<void> unmarkAsFavorite(int routeId) async {
    _routes = _routes
        .map(
          (route) => route.id == routeId
              ? route.copyWith(isFavorite: false)
              : route,
        )
        .toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeRoute', () {
    late _FakeHomeProvider fakeProvider;
    late List<BusRouteEntity> routes;

    setUp(() {
      routes = [
        BusRouteEntity(
          id: 1,
          code: 'CB001',
          name: 'Centro - Norte',
          from: 'Terminal Centro',
          to: 'Parque Norte',
          description: 'Ruta troncal con paradas principales.',
          stops: const ['Central', 'Av 10', 'Museo', 'Parque Norte'],
        ),
        BusRouteEntity(
          id: 2,
          code: 'CB002',
          name: 'Occidente - Sur',
          from: 'Portal Occidente',
          to: 'Universidad Sur',
          description: 'Ruta alimentadora.',
          stops: const ['Portal Occidente', 'Av 80', 'Estadio', 'Universidad Sur'],
        ),
      ];

      fakeProvider = _FakeHomeProvider(routes);
    });

    Future<void> _pumpHomeRoute(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            routesProvider.overrideWithValue(fakeProvider),
          ],
          child: const MaterialApp(
            home: Scaffold(body: HomeRoute()),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    }

    testWidgets('muestra el listado inicial de rutas', (tester) async {
      await _pumpHomeRoute(tester);

      expect(find.text('Centro - Norte'), findsOneWidget);
      expect(find.text('Occidente - Sur'), findsOneWidget);
    });

    testWidgets('filtra rutas con el buscador', (tester) async {
      await _pumpHomeRoute(tester);

      await tester.enterText(
        find.byType(TextField),
        'CB002',
      );
      await tester.pumpAndSettle();

      expect(find.text('Occidente - Sur'), findsOneWidget);
      expect(find.text('Centro - Norte'), findsNothing);
    });

    testWidgets('permite marcar una ruta como favorita', (tester) async {
      await _pumpHomeRoute(tester);

      final initialFavoriteIconFinder =
          find.byIcon(Icons.star_outline_rounded).first;
      await tester.tap(initialFavoriteIconFinder);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_rounded), findsWidgets);
    });
  });
}

