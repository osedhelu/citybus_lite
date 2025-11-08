import '../entities/bus_route_entity.dart';

abstract class RoutesDataSource {
  Future<List<BusRouteEntity>> fetchRoutes();
  Future<BusRouteEntity?> fetchRouteById(int id);
  Future<bool> addFavoriteRoute(int routeId);
  Future<bool> removeFavoriteRoute(int routeId);
  Future<List<BusRouteEntity>> getFavoriteRoutes();
}
