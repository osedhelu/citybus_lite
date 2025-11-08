import 'dart:convert';

import 'package:citybus_lite/features/home/domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutesDatasourceImpl implements RoutesDataSource {
  RoutesDatasourceImpl({
    RoutesAssetService? assetService,
    FavoriteRoutesLocalService? favoriteRoutesService,
  }) : _assetService = assetService ?? RoutesAssetService(),
       _favoriteRoutesService =
           favoriteRoutesService ?? FavoriteRoutesLocalService();

  final RoutesAssetService _assetService;
  final FavoriteRoutesLocalService _favoriteRoutesService;

  @override
  Future<List<BusRouteEntity>> fetchRoutes() async {
    final routes = await _assetService.loadRoutes();
    final favoriteIds = await _favoriteRoutesService.getFavoriteRouteIds();
    return routes
        .map(
          (route) => route.copyWith(isFavorite: favoriteIds.contains(route.id)),
        )
        .toList();
  }

  @override
  Future<BusRouteEntity?> fetchRouteById(int id) async {
    final routes = await _assetService.loadRoutes();
    final favoriteIds = await _favoriteRoutesService.getFavoriteRouteIds();
    for (final route in routes) {
      if (route.id == id) {
        return route.copyWith(isFavorite: favoriteIds.contains(id));
      }
    }
    return null;
  }

  @override
  Future<bool> addFavoriteRoute(int routeId) {
    return _favoriteRoutesService.addFavoriteRoute(routeId);
  }

  @override
  Future<List<BusRouteEntity>> getFavoriteRoutes() async {
    final routes = await fetchRoutes();
    return routes.where((route) => route.isFavorite).toList();
  }

  @override
  Future<bool> removeFavoriteRoute(int routeId) {
    return _favoriteRoutesService.removeFavoriteRoute(routeId);
  }
}

class RoutesAssetService {
  RoutesAssetService({this.assetPath = 'assets/routes.json'});

  final String assetPath;

  List<BusRouteEntity>? _cachedRoutes;

  Future<List<BusRouteEntity>> loadRoutes() async {
    if (_cachedRoutes != null) {
      return _cachedRoutes!;
    }

    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    final routes = BusRouteEntity.fromListJson(decoded);
    _cachedRoutes = routes;
    return routes;
  }
}

class FavoriteRoutesLocalService {
  FavoriteRoutesLocalService({SharedPreferences? sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  static const _favoritesKey = 'favorite_routes';

  SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> _getPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  Future<bool> addFavoriteRoute(int routeId) async {
    final prefs = await _getPreferences();
    final storedIds = prefs.getStringList(_favoritesKey) ?? <String>[];
    final updatedIds = List<String>.from(storedIds);
    final routeIdString = routeId.toString();

    if (!updatedIds.contains(routeIdString)) {
      updatedIds.add(routeIdString);
    }

    return prefs.setStringList(_favoritesKey, updatedIds);
  }

  Future<bool> removeFavoriteRoute(int routeId) async {
    final prefs = await _getPreferences();
    final storedIds = prefs.getStringList(_favoritesKey) ?? <String>[];
    final routeIdString = routeId.toString();
    final updatedIds = storedIds.where((id) => id != routeIdString).toList();

    return prefs.setStringList(_favoritesKey, updatedIds);
  }

  Future<Set<int>> getFavoriteRouteIds() async {
    final prefs = await _getPreferences();
    final storedIds = prefs.getStringList(_favoritesKey) ?? <String>[];

    return storedIds.map((id) => int.tryParse(id)).whereType<int>().toSet();
  }
}
