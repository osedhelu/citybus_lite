import 'package:citybus_lite/features/home/domain/domain.dart';
import 'package:citybus_lite/features/home/infrastructure/datasources/routes_datasource_impl.dart';

class RoutesRepositoryImpl implements RoutesRepository {
  final RoutesDataSource dataSource;

  RoutesRepositoryImpl({RoutesDataSource? dataSource})
    : dataSource = dataSource ?? RoutesDatasourceImpl();

  @override
  Future<List<BusRouteEntity>> fetchRoutes() {
    return dataSource.fetchRoutes();
  }

  @override
  Future<BusRouteEntity?> fetchRouteById(int id) {
    return dataSource.fetchRouteById(id);
  }

  @override
  Future<bool> addFavoriteRoute(int routeId) {
    return dataSource.addFavoriteRoute(routeId);
  }

  @override
  Future<bool> removeFavoriteRoute(int routeId) {
    return dataSource.removeFavoriteRoute(routeId);
  }

  @override
  Future<List<BusRouteEntity>> getFavoriteRoutes() {
    return dataSource.getFavoriteRoutes();
  }
}
