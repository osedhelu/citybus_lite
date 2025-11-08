import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router_notifier.dart';

class RouterAwareLayout extends ConsumerWidget {
  const RouterAwareLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerState = ref.watch(routerNotifierProvider);
    final leading = routerState.leadingBuilder?.call(context);
    final trailing = routerState.trailingBuilder?.call(context);

    final appBar = (leading == null && trailing == null)
        ? null
        : AppBar(
            leading: leading,
            actions: [if (trailing != null) trailing],
            title: const SizedBox.shrink(),
          );

    return Scaffold(appBar: appBar, body: child);
  }
}
