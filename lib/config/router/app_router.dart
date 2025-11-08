import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:citybus_lite/features/home/presentation/screens/home_screen.dart';
import 'package:citybus_lite/features/settings/presentation/screens/settings_screen.dart';

import 'router_aware_layout.dart';
import 'router_notifier.dart';
import 'router_state.dart';

typedef _RouteBuilder = Widget Function(BuildContext, GoRouterState);

const _loadingRouteName = 'loading';
const _loadingRoutePath = '/loading';

final navigatorKey = GlobalKey<NavigatorState>();

final List<_RouteConfig> _routeConfigs = [
  _RouteConfig(
    path: HomeRoute.path,
    name: HomeRoute.name,
    builder: (context, state) => RouterAwareLayout(child: const HomeRoute()),
    trailingBuilder: (context) => IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => context.go(SettingsRoute.path),
    ),
  ),
  _RouteConfig(
    path: _loadingRoutePath,
    name: _loadingRouteName,
    builder: (context, state) => const _LoadingScreen(),
  ),
  _RouteConfig(
    path: SettingsRoute.path,
    name: SettingsRoute.name,
    builder: (context, state) =>
        RouterAwareLayout(child: const SettingsRoute()),
    leadingBuilder: (context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => context.go(HomeRoute.path),
    ),
  ),
];

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.read(routerNotifierProvider.notifier);
  final refreshListenable = ref.watch(_routerRefreshListenableProvider);

  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: HomeRoute.path,
    refreshListenable: refreshListenable,
    routes: _routeConfigs.map((config) => config.toRoute()).toList(),
    redirect: (context, state) {
      final routerState = routerNotifier.state;

      if (!routerState.isReady && state.matchedLocation != _loadingRoutePath) {
        return _loadingRoutePath;
      }

      if (routerState.isReady && state.matchedLocation == _loadingRoutePath) {
        return HomeRoute.path;
      }

      return null;
    },
    observers: [_RouterNavigationObserver(notifier: routerNotifier)],
  );

  Future<void>.microtask(() {
    final location = _currentLocation(router);
    final config = _findRouteConfig(location);

    routerNotifier
      ..setCurrentLocation(location)
      ..updateRouteButtons(
        leadingBuilder: config?.leadingBuilder,
        trailingBuilder: config?.trailingBuilder,
      );
  });

  return router;
});

class _RouteConfig {
  const _RouteConfig({
    required this.path,
    required this.name,
    required this.builder,
    this.leadingBuilder,
    this.trailingBuilder,
  });

  final String path;
  final String name;
  final _RouteBuilder builder;
  final RouteButtonBuilder? leadingBuilder;
  final RouteButtonBuilder? trailingBuilder;

  GoRoute toRoute() => GoRoute(path: path, name: name, builder: builder);
}

final _routerRefreshListenableProvider = Provider<_RouterRefreshListenable>((
  ref,
) {
  final listenable = _RouterRefreshListenable(ref);
  ref.onDispose(listenable.dispose);
  return listenable;
});

_RouteConfig? _findRouteConfig(String location) {
  final path = Uri.tryParse(location)?.path ?? location;

  for (final config in _routeConfigs) {
    if (config.path == path) {
      return config;
    }
  }

  return null;
}

String _currentLocation(GoRouter router) {
  final configuration = router.routerDelegate.currentConfiguration;
  if (configuration.isNotEmpty) {
    return configuration.last.matchedLocation;
  }

  final routeInformation = router.routeInformationProvider.value;
  final location = routeInformation.location;
  if (location.isEmpty) {
    return HomeRoute.path;
  }
  return location;
}

class _RouterRefreshListenable extends ChangeNotifier {
  _RouterRefreshListenable(this._ref) {
    _subscription = _ref.listen<RouterState>(routerNotifierProvider, (
      previous,
      next,
    ) {
      if (previous != next) {
        notifyListeners();
      }
    }, fireImmediately: true);
  }

  final Ref _ref;
  late final ProviderSubscription<RouterState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

class _RouterNavigationObserver extends NavigatorObserver {
  _RouterNavigationObserver({required this.notifier});

  final RouterNotifier notifier;

  void _applyRouteState() {
    final navigatorState = navigator;
    if (navigatorState == null) return;

    final context = navigatorState.context;
    final goRouter = GoRouter.of(context);
    final location = _currentLocation(goRouter);
    final config = _findRouteConfig(location);

    Future<void>.microtask(() {
      notifier
        ..setCurrentLocation(location)
        ..updateRouteButtons(
          leadingBuilder: config?.leadingBuilder,
          trailingBuilder: config?.trailingBuilder,
        );
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _applyRouteState();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _applyRouteState();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _applyRouteState();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _applyRouteState();
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
