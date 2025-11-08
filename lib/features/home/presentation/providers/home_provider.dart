import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/domain/repositories/routes_datasource.dart';
import 'package:citybus_lite/features/home/infrastructure/repositories/routes_datasource_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class InterfaceHomeProvider {
  List<BusRouteEntity> get data;
  Future<List<BusRouteEntity>> resetData();
  Future<List<BusRouteEntity>> searchRoutes(String query);
  Future<BusRouteEntity?> getRouteById(int routeId);
  Future<void> markAsFavorite(int routeId);
  Future<void> unmarkAsFavorite(int routeId);
}

class RoutesProvider extends InterfaceHomeProvider {
  RoutesProvider(this._repository) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await resetData();
    });
  }

  final RoutesRepository _repository;

  List<BusRouteEntity> _routes = [];
  List<BusRouteEntity>? _searchResults;

  @override
  List<BusRouteEntity> get data =>
      List<BusRouteEntity>.unmodifiable(_searchResults ?? _routes);

  @override
  Future<List<BusRouteEntity>> resetData() async {
    final fetchedRoutes = await _repository.fetchRoutes();
    _routes = fetchedRoutes;
    _searchResults = null;
    return data;
  }

  @override
  Future<List<BusRouteEntity>> searchRoutes(String query) async {
    await _ensureRoutesLoaded();

    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      _searchResults = null;
      return data;
    }

    _searchResults = _routes.where((route) {
      final searchableContent = [
        route.code,
        route.name,
        route.description,
        route.from,
        route.to,
        ...route.stops,
      ].join(' ').toLowerCase();

      return searchableContent.contains(normalizedQuery);
    }).toList();

    return data;
  }

  @override
  Future<BusRouteEntity?> getRouteById(int routeId) async {
    await _ensureRoutesLoaded();

    final routeIndex = _routes.indexWhere((route) => route.id == routeId);
    if (routeIndex != -1) {
      return _routes[routeIndex];
    }

    final route = await _repository.fetchRouteById(routeId);
    if (route != null) {
      _upsertRoute(route);
    }
    return route;
  }

  @override
  Future<void> markAsFavorite(int routeId) async {
    await _ensureRoutesLoaded();
    final success = await _repository.addFavoriteRoute(routeId);
    if (success) {
      await _refreshRoute(routeId);
    }
  }

  @override
  Future<void> unmarkAsFavorite(int routeId) async {
    await _ensureRoutesLoaded();
    final success = await _repository.removeFavoriteRoute(routeId);
    if (success) {
      await _refreshRoute(routeId);
    }
  }

  Future<void> _ensureRoutesLoaded() async {
    if (_routes.isEmpty) {
      await resetData();
    }
  }

  Future<void> _refreshRoute(int routeId) async {
    final route = await _repository.fetchRouteById(routeId);
    if (route != null) {
      _upsertRoute(route);
    }
  }

  void _upsertRoute(BusRouteEntity updatedRoute) {
    final routeIndex = _routes.indexWhere(
      (route) => route.id == updatedRoute.id,
    );

    if (routeIndex >= 0) {
      final updatedRoutes = List<BusRouteEntity>.from(_routes);
      updatedRoutes[routeIndex] = updatedRoute;
      _routes = updatedRoutes;
    } else {
      _routes = [..._routes, updatedRoute];
    }

    if (_searchResults != null) {
      final results = List<BusRouteEntity>.from(_searchResults!);
      final resultIndex = results.indexWhere(
        (route) => route.id == updatedRoute.id,
      );

      if (resultIndex >= 0) {
        results[resultIndex] = updatedRoute;
      }

      _searchResults = results;
    }
  }
}

final routesRepositoryProvider = Provider<RoutesRepository>(
  (ref) => RoutesRepositoryImpl(),
);

final routesProvider = Provider<InterfaceHomeProvider>(
  (ref) => RoutesProvider(ref.read(routesRepositoryProvider)),
);
