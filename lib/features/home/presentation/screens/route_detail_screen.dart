import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import 'package:citybus_lite/features/home/domain/entities/bus_route_entity.dart';
import 'package:citybus_lite/features/home/presentation/providers/home_provider.dart';

class RouteDetailRoute extends ConsumerStatefulWidget {
  const RouteDetailRoute({super.key, required this.routeId});

  static const String name = 'route-detail';
  static const String path = '/routes/:id';

  static String pathWithId(int id) => '/routes/$id';

  final int routeId;

  @override
  ConsumerState<RouteDetailRoute> createState() => _RouteDetailRouteState();
}

class _RouteDetailRouteState extends ConsumerState<RouteDetailRoute> {
  bool _isLoading = true;
  String _errorMessage = '';
  BusRouteEntity? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRoute();
    });
  }

  Future<void> _loadRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final provider = ref.read(routesProvider);
      final route = await provider.getRouteById(widget.routeId);

      if (!mounted) return;

      if (route == null) {
        setState(() {
          _errorMessage = 'La ruta no existe o fue eliminada.';
        });
      } else {
        setState(() {
          _route = route;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo cargar el detalle.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final route = _route;
    if (route == null) return;

    final provider = ref.read(routesProvider);
    if (route.isFavorite) {
      await provider.unmarkAsFavorite(route.id);
    } else {
      await provider.markAsFavorite(route.id);
    }
    await _loadRoute();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    Widget body;

    if (_isLoading) {
      body = const _RouteDetailSkeleton();
    } else if (_errorMessage.isNotEmpty) {
      body = _RouteDetailError(message: _errorMessage, onRetry: _loadRoute);
    } else if (_route != null) {
      final route = _route!;
      body = SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.code,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: textScaler.scale(16),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        route.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: textScaler.scale(26),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    route.isFavorite
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                  ),
                  color: route.isFavorite
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurfaceVariant,
                  tooltip: route.isFavorite
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailInfoRow(
                    icon: Icons.place_outlined,
                    label: 'Origen',
                    value: route.from,
                  ),
                  const SizedBox(height: 16),
                  _DetailInfoRow(
                    icon: Icons.flag_outlined,
                    label: 'Destino',
                    value: route.to,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Descripción',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: textScaler.scale(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    route.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: textScaler.scale(15),
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Paradas',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: textScaler.scale(20),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: route.stops.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 20),
                itemBuilder: (context, index) {
                  final stop = route.stops[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: textScaler.scale(13),
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          stop,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: textScaler.scale(16),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      body = const SizedBox.shrink();
    }

    return SafeArea(child: body);
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: textScaler.scale(22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: textScaler.scale(13),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: textScaler.scale(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteDetailSkeleton extends StatelessWidget {
  const _RouteDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: theme.colorScheme.surfaceVariant.withOpacity(0.6),
            highlightColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: theme.colorScheme.surfaceVariant.withOpacity(0.6),
            highlightColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: theme.colorScheme.surfaceVariant.withOpacity(0.6),
            highlightColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetailError extends StatelessWidget {
  const _RouteDetailError({required this.message, required this.onRetry});

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

class RouteDetailNotFoundView extends StatelessWidget {
  const RouteDetailNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_bus_filled_outlined,
                size: textScaler.scale(52),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Ruta no encontrada',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontSize: textScaler.scale(24),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Verifica el enlace o regresa a la lista de rutas.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: textScaler.scale(15),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
