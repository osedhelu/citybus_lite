import 'package:flutter/widgets.dart';

typedef RouteButtonBuilder = Widget? Function(BuildContext context);

class RouterState {
  const RouterState({
    this.isReady = true,
    this.isAuthenticated = false,
    this.currentLocation = '/',
    this.leadingBuilder,
    this.trailingBuilder,
  });

  final bool isReady;
  final bool isAuthenticated;
  final String currentLocation;
  final RouteButtonBuilder? leadingBuilder;
  final RouteButtonBuilder? trailingBuilder;

  RouterState copyWith({
    bool? isReady,
    bool? isAuthenticated,
    String? currentLocation,
    RouteButtonBuilder? leadingBuilder,
    RouteButtonBuilder? trailingBuilder,
  }) {
    return RouterState(
      isReady: isReady ?? this.isReady,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentLocation: currentLocation ?? this.currentLocation,
      leadingBuilder: leadingBuilder ?? this.leadingBuilder,
      trailingBuilder: trailingBuilder ?? this.trailingBuilder,
    );
  }
}
