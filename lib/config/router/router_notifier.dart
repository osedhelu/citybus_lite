import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router_state.dart';

final routerNotifierProvider = NotifierProvider<RouterNotifier, RouterState>(
  RouterNotifier.new,
);

class RouterNotifier extends Notifier<RouterState> {
  @override
  RouterState build() => const RouterState();

  void setReady(bool value) {
    if (state.isReady == value) return;
    state = state.copyWith(isReady: value);
  }

  void setAuthenticated(bool value) {
    if (state.isAuthenticated == value) return;
    state = state.copyWith(isAuthenticated: value);
  }

  void setCurrentLocation(String location) {
    if (state.currentLocation == location) return;
    state = state.copyWith(currentLocation: location);
  }

  void updateRouteButtons({
    RouteButtonBuilder? leadingBuilder,
    RouteButtonBuilder? trailingBuilder,
  }) {
    if (state.leadingBuilder == leadingBuilder &&
        state.trailingBuilder == trailingBuilder) {
      return;
    }

    state = RouterState(
      isReady: state.isReady,
      isAuthenticated: state.isAuthenticated,
      currentLocation: state.currentLocation,
      leadingBuilder: leadingBuilder,
      trailingBuilder: trailingBuilder,
    );
  }
}
