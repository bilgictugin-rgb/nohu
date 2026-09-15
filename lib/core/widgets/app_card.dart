import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_design.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.border,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderSide? border;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasTone = color != null;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      side:
          border ??
          BorderSide(
            color: hasTone
                ? Colors.transparent
                : Theme.of(context).dividerColor,
          ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.surface),
        boxShadow: elevated
            ? AppShadows.floating(
                Theme.of(context).brightness == Brightness.dark,
              )
            : null,
      ),
      child: Card(
        color: color ?? colors.surface,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.surface),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
