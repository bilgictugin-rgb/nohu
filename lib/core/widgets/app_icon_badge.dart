import 'package:flutter/material.dart';

import '../theme/app_assets.dart';
import 'app_design.dart';

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final Object icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.42)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.70);
    final effectiveColor = theme.colorScheme.onSurface;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.compact + 4),
        border: Border.all(color: theme.dividerColor),
      ),
      child: AppIcon(icon, color: effectiveColor, size: 21),
    );
  }
}
