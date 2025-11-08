import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';

abstract class RoutesRepository {
  Future<List<BusRouteEntity>> fetchRoutes();
  Future<BusRouteEntity?> fetchRouteById(int id);
  Future<bool> addFavoriteRoute(int routeId);
  Future<bool> removeFavoriteRoute(int routeId);
  Future<List<BusRouteEntity>> getFavoriteRoutes();
}
