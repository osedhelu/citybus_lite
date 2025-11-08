import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/domain/repositories/routes_datasource.dart';
import 'package:citybus_lite/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRoutesRepository implements RoutesRepository {
  _FakeRoutesRepository(List<BusRouteEntity> routes)
      : _routes = List<BusRouteEntity>.from(routes);

  final List<BusRouteEntity> _routes;

  @override
  Future<bool> addFavoriteRoute(int routeId) async {
    final index = _routes.indexWhere((route) => route.id == routeId);
    if (index == -1) {
      return false;
    }
    _routes[index] = _routes[index].copyWith(isFavorite: true);
    return true;
  }

  @override
  Future<BusRouteEntity?> fetchRouteById(int id) async {
    return _routes.firstWhere(
      (route) => route.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<List<BusRouteEntity>> fetchRoutes() async {
    return List<BusRouteEntity>.from(_routes);
  }

  @override
  Future<List<BusRouteEntity>> getFavoriteRoutes() async {
    return _routes.where((route) => route.isFavorite).toList();
  }

  @override
  Future<bool> removeFavoriteRoute(int routeId) async {
    final index = _routes.indexWhere((route) => route.id == routeId);
    if (index == -1) {
      return false;
    }
    _routes[index] = _routes[index].copyWith(isFavorite: false);
    return true;
  }
}

void main() {
  late RoutesProvider provider;
  late _FakeRoutesRepository repository;
  late List<BusRouteEntity> sampleRoutes;

  setUp(() {
    sampleRoutes = [
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

    repository = _FakeRoutesRepository(sampleRoutes);
    provider = RoutesProvider(repository);
  });

  test('resetData carga rutas desde el repositorio', () async {
    final routes = await provider.resetData();

    expect(routes.length, sampleRoutes.length);
    expect(routes.first.code, 'CB001');
  });

  test('searchRoutes filtra por nombre o código', () async {
    await provider.resetData();

    final filteredByCode = await provider.searchRoutes('CB002');
    expect(filteredByCode, hasLength(1));
    expect(filteredByCode.single.id, 2);

    final filteredByName = await provider.searchRoutes('Centro');
    expect(filteredByName, hasLength(1));
    expect(filteredByName.single.id, 1);
  });

  test('markAsFavorite activa el flag y se refleja en getRouteById', () async {
    await provider.resetData();

    await provider.markAsFavorite(1);
    final route = await provider.getRouteById(1);

    expect(route?.isFavorite, isTrue);
  });

  test('unmarkAsFavorite desactiva el flag', () async {
    await provider.resetData();
    await provider.markAsFavorite(1);

    await provider.unmarkAsFavorite(1);
    final route = await provider.getRouteById(1);

    expect(route?.isFavorite, isFalse);
  });
}

