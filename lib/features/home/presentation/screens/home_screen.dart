import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/presentation/providers/home_provider.dart';
import 'package:citybus_lite/features/home/presentation/screens/route_detail_screen.dart';
import 'package:citybus_lite/features/settings/presentation/screens/settings_screen.dart';

class HomeRoute extends ConsumerStatefulWidget {
  const HomeRoute({super.key});

  static const String name = 'home';
  static const String path = '/';

  @override
  ConsumerState<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends ConsumerState<HomeRoute> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<BusRouteEntity> _routes = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRoutes();
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadRoutes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final provider = ref.read(routesProvider);
      final routes = await provider.resetData();
      if (!mounted) return;
      setState(() {
        _routes = routes;
      });
      await _applySearch(_searchController.text);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudieron cargar las rutas';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _applySearch(String query) async {
    final provider = ref.read(routesProvider);
    final results = await provider.searchRoutes(query);
    if (!mounted) return;
    setState(() {
      _routes = results;
    });
  }

  void _onSearchChanged() {
    _applySearch(_searchController.text);
  }

  Future<void> _toggleFavorite(BusRouteEntity route) async {
    final provider = ref.read(routesProvider);
    if (route.isFavorite) {
      await provider.unmarkAsFavorite(route.id);
    } else {
      await provider.markAsFavorite(route.id);
    }
    await _applySearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    final body = _isLoading
        ? const _RoutesSkeleton()
        : _errorMessage.isNotEmpty
            ? _ErrorState(
                message: _errorMessage,
                onRetry: _loadRoutes,
              )
            : _routes.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    itemCount: _routes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final route = _routes[index];
                      return _RouteCard(
                        route: route,
                        onFavoriteToggle: () => _toggleFavorite(route),
                        onTap: () => context.go(
                          RouteDetailRoute.pathWithId(route.id),
                        ),
                      );
                    },
                  );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CityBus Lite',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: textScaler.scale(24),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Configuración',
                      onPressed: () => context.go(SettingsRoute.path),
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SearchField(
                  controller: _searchController,
                  onClear: () {
                    _searchController.clear();
                    _applySearch('');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onClear,
  });

  final TextEditingController controller;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Buscar ruta por código o nombre',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: textScaler.scale(14),
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
              ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: textScaler.scale(16),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final BusRouteEntity route;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    route.code,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: textScaler.scale(16),
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: route.isFavorite
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    route.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: route.isFavorite
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              route.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: textScaler.scale(20),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.route_outlined,
                  color: theme.colorScheme.primary,
                  size: textScaler.scale(18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${route.from} → ${route.to}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: textScaler.scale(15),
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutesSkeleton extends StatelessWidget {
  const _RoutesSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: theme.colorScheme.surfaceVariant.withOpacity(0.6),
            highlightColor:
                theme.colorScheme.surfaceVariant.withOpacity(0.2),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus_filled_outlined,
              size: textScaler.scale(48),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No encontramos rutas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: textScaler.scale(18),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prueba con otro término de búsqueda o limpia el filtro.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: textScaler.scale(14),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: textScaler.scale(48),
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: textScaler.scale(16),
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(
                'Reintentar',
                style: TextStyle(fontSize: textScaler.scale(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
