import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/presentation/providers/home_provider.dart';
import 'package:citybus_lite/features/home/presentation/screens/route_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDetailProvider implements InterfaceHomeProvider {
  _FakeDetailProvider(List<BusRouteEntity> routes)
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
          (route) =>
              route.id == routeId ? route.copyWith(isFavorite: true) : route,
        )
        .toList();
  }

  @override
  Future<List<BusRouteEntity>> resetData() async {
    return data;
  }

  @override
  Future<List<BusRouteEntity>> searchRoutes(String query) async {
    return data;
  }

  @override
  Future<void> unmarkAsFavorite(int routeId) async {
    _routes = _routes
        .map(
          (route) =>
              route.id == routeId ? route.copyWith(isFavorite: false) : route,
        )
        .toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RouteDetailRoute', () {
    late _FakeDetailProvider fakeProvider;
    late BusRouteEntity route;

    setUp(() {
      route = BusRouteEntity(
        id: 1,
        code: 'CB001',
        name: 'Centro - Norte',
        from: 'Terminal Centro',
        to: 'Parque Norte',
        description: 'Ruta troncal con paradas principales.',
        stops: const ['Central', 'Av 10', 'Museo', 'Parque Norte'],
      );

      fakeProvider = _FakeDetailProvider([route]);
    });

    Future<void> _pumpDetailRoute(
      WidgetTester tester, {
      required int routeId,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [routesProvider.overrideWithValue(fakeProvider)],
          child: MaterialApp(
            home: Scaffold(body: RouteDetailRoute(routeId: routeId)),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    }

    testWidgets('muestra información detallada de la ruta', (tester) async {
      await _pumpDetailRoute(tester, routeId: 1);

      expect(find.text('Centro - Norte'), findsOneWidget);
      expect(
        find.text('Ruta troncal con paradas principales.'),
        findsOneWidget,
      );
      expect(find.text('Parque Norte'), findsNWidgets(2));
    });

    testWidgets('permite marcar y desmarcar favoritos', (tester) async {
      await _pumpDetailRoute(tester, routeId: 1);

      final favoriteButton = find.byIcon(Icons.star_outline_rounded);
      expect(favoriteButton, findsOneWidget);

      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.star_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
    });
  });
}
