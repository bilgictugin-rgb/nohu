import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';

class AppSpacing {
  static const s4 = 4.0;
  static const s6 = 6.0;
  static const s8 = 8.0;
  static const s10 = 10.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const page = s20;
  static const maxContentWidth = 560.0;

  static const x1 = s8;
  static const x2 = s16;
  static const x3 = s24;
  static const x4 = s32;
}

class AppRadius {
  static const compact = 8.0;
  static const surface = 22.0;
  static const hero = 30.0;

  static const small = compact;
  static const medium = surface;
}

class NohuLogoMark extends StatelessWidget {
  const NohuLogoMark({
    super.key,
    this.size = 42,
    this.width,
    this.height,
    this.showBorder = true,
  });

  final double size;
  final double? width;
  final double? height;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final logoWidth = width ?? size;
    final logoHeight = height ?? size;
    return Container(
      width: logoWidth,
      height: logoHeight,
      padding: EdgeInsets.symmetric(
        horizontal: logoWidth * 0.08,
        vertical: logoHeight * 0.10,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.compact + 4),
        border: showBorder
            ? Border.all(color: Theme.of(context).dividerColor)
            : null,
      ),
      child: Image.asset(
        AppAssets.nohuLogo,
        fit: BoxFit.contain,
        semanticLabel: 'NOHÜ logosu',
      ),
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.padding = const EdgeInsets.only(top: 20, bottom: 8),
  });

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class SectionHeader extends AppSectionTitle {
  const SectionHeader({
    super.key,
    required super.title,
    super.trailing,
    super.padding,
  });
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.page,
      AppSpacing.s8,
      AppSpacing.page,
      AppSpacing.s24,
    ),
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.safeTop = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool safeTop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        top: safeTop,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Padding(padding: padding, child: body),
          ),
        ),
      ),
    );
  }
}

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const destinations = [
      _NavDestination(
        label: 'Ana Sayfa',
        icon: AppIcons.home,
        selectedIcon: AppIcons.homeSelected,
      ),
      _NavDestination(
        label: 'Akademik',
        icon: AppIcons.academic,
        selectedIcon: AppIcons.academicSelected,
      ),
      _NavDestination(
        label: 'Kampüs',
        icon: AppIcons.campus,
        selectedIcon: AppIcons.campusSelected,
      ),
      _NavDestination(
        label: 'Profil',
        icon: AppIcons.profile,
        selectedIcon: AppIcons.profileSelected,
      ),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s12,
                  AppSpacing.s8,
                  AppSpacing.s12,
                  AppSpacing.s8,
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < destinations.length; i++)
                      Expanded(
                        child: _NavItem(
                          destination: destinations[i],
                          selected: selectedIndex == i,
                          onTap: () => onDestinationSelected(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final Object icon;
  final Object selectedIcon;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.surface),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24,
                child: AnimatedScale(
                  duration: AppAnimations.fast,
                  curve: AppAnimations.curve,
                  scale: selected ? 1.06 : 1,
                  child: AppIcon(
                    selected ? destination.selectedIcon : destination.icon,
                    color: color,
                    size: selected ? 24 : 22,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigation extends AppNavigationBar {
  const AppBottomNavigation({
    super.key,
    required super.selectedIndex,
    required super.onDestinationSelected,
  });
}

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.meta,
    this.trailing,
    this.action,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final String? meta;
  final Widget? trailing;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: compact ? AppSpacing.s12 : AppSpacing.s20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meta != null) ...[
                  Text(
                    meta!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                ],
                Text(title, style: theme.textTheme.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.s8),
                  Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
                if (action != null) ...[
                  const SizedBox(height: AppSpacing.s12),
                  action!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.s12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.meta,
    this.action,
    this.onTap,
    this.color = AppColors.indigo,
    this.accent = AppColors.teal,
    this.illustration = true,
  });

  final String title;
  final String subtitle;
  final Object icon;
  final String? meta;
  final Widget? action;
  final VoidCallback? onTap;
  final Color color;
  final Color accent;
  final bool illustration;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      elevated: true,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.surface),
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, accent, 0.32)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.compact),
                  ),
                  child: AppIcon(icon, color: Colors.white),
                ),
                const Spacer(),
                if (meta != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s10,
                      vertical: AppSpacing.s6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadius.compact),
                    ),
                    child: Text(
                      meta!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 330),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 330),
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, height: 1.35),
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.s16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppListSection extends StatelessWidget {
  const AppListSection({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.surface),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(
                height: 1,
                indent: AppSpacing.s20,
                endIndent: AppSpacing.s20,
                color: Theme.of(context).dividerColor,
              ),
          ],
        ],
      ),
    );
  }
}

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.s16,
      vertical: AppSpacing.s12,
    ),
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final tile = InkWell(
      onTap: onTap,
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.s12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.s12),
              trailing!,
            ],
          ],
        ),
      ),
    );
    if (semanticLabel == null) return tile;
    return Semantics(label: semanticLabel, button: onTap != null, child: tile);
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.trailing,
    this.action,
    this.height,
  });

  final String title;
  final String subtitle;
  final Object icon;
  final Color color;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? action;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      color: theme.colorScheme.surface,
      border: BorderSide(color: theme.dividerColor),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _SoftIcon(icon: icon, color: color),
                const Spacer(),
                ?trailing,
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.s4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.s12),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
    this.prominent = false,
  });

  final String title;
  final String? subtitle;
  final Object icon;
  final Color color;
  final VoidCallback? onTap;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleSmall?.copyWith(
      color: prominent ? Colors.white : null,
    );
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: prominent ? Colors.white70 : null,
    );
    return AppCard(
      onTap: onTap,
      color: prominent ? color : theme.colorScheme.surface,
      border: prominent ? null : BorderSide(color: theme.dividerColor),
      elevated: prominent,
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prominent
              ? Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(AppRadius.compact),
                  ),
                  child: AppIcon(icon, color: Colors.white, size: 22),
                )
              : _SoftIcon(icon: icon, color: color),
          const Spacer(),
          Text(title, style: titleStyle),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: subtitleStyle,
            ),
          ],
        ],
      ),
    );
  }
}

class AcademicSummaryCard extends StatelessWidget {
  const AcademicSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSummaryCard extends AcademicSummaryCard {
  const ProfileSummaryCard({
    super.key,
    required super.label,
    required super.value,
    required super.color,
  });
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.meta,
    required this.time,
    this.onTap,
    this.color = AppColors.indigo,
  });

  final String title;
  final String meta;
  final String time;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      title: title,
      subtitle: meta,
      icon: AppIcons.book,
      color: color,
      onTap: onTap,
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.title,
    required this.meta,
    this.action,
    this.onTap,
  });

  final String title;
  final String meta;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      title: title,
      subtitle: meta,
      icon: AppIcons.clock,
      color: AppColors.warning,
      action: action,
      onTap: onTap,
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.meta,
    this.onTap,
  });

  final String title;
  final String meta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      title: title,
      subtitle: meta,
      icon: AppIcons.events,
      color: AppColors.lavender,
      onTap: onTap,
    );
  }
}

class CommunityCard extends StatelessWidget {
  const CommunityCard({
    super.key,
    required this.title,
    required this.meta,
    this.onTap,
  });

  final String title;
  final String meta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FeatureCard(
      title: title,
      subtitle: meta,
      icon: AppIcons.communities,
      color: AppColors.lavender,
      onTap: onTap,
    );
  }
}

class EducationIllustration extends StatelessWidget {
  const EducationIllustration({
    super.key,
    this.size = 132,
    this.color,
    this.icon = Icons.auto_stories_outlined,
  });

  final double size;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EducationIllustrationPainter(color: effectiveColor),
        child: Center(
          child: Icon(
            icon,
            color: effectiveColor.withValues(alpha: 0.95),
            size: size * 0.34,
          ),
        ),
      ),
    );
  }
}

class _EducationIllustrationPainter extends CustomPainter {
  const _EducationIllustrationPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.18);
    final accent = Paint()..color = color.withValues(alpha: 0.34);
    final line = Paint()
      ..color = color.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.16,
          size.height * 0.18,
          size.width * 0.68,
          size.height * 0.62,
        ),
        Radius.circular(size.width * 0.18),
      ),
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.76),
      size.width * 0.10,
      accent,
    );
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.28),
      size.width * 0.08,
      accent,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, size.height * 0.34),
      Offset(size.width * 0.70, size.height * 0.34),
      line,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, size.height * 0.48),
      Offset(size.width * 0.62, size.height * 0.48),
      line,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.50, size.height * 0.55),
        radius: size.width * 0.30,
      ),
      math.pi * 0.06,
      math.pi * 0.82,
      false,
      line,
    );
  }

  @override
  bool shouldRepaint(covariant _EducationIllustrationPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon, required this.color});

  final Object icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = Theme.of(context).brightness == Brightness.dark
        ? scheme.surfaceContainerHighest.withValues(alpha: 0.42)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.70);
    final iconColor = scheme.onSurface;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.compact),
      ),
      child: AppIcon(icon, color: iconColor, size: 22),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return FilledButton(onPressed: onPressed, child: Text(label));
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return OutlinedButton(onPressed: onPressed, child: Text(label));
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.icon,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
      onChanged: onChanged,
    );
  }
}

class StatusBadge extends AppStatusPill {
  const StatusBadge({super.key, required super.label, super.type});
}

class AcademicListRow extends StatelessWidget {
  const AcademicListRow({
    super.key,
    required this.title,
    required this.value,
    this.meta,
    this.onTap,
  });

  final String title;
  final String value;
  final String? meta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: title,
      subtitle: meta,
      trailing: Text(
        value,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      onTap: onTap,
    );
  }
}

class CourseBlock extends StatelessWidget {
  const CourseBlock({
    super.key,
    required this.course,
    required this.time,
    required this.room,
    this.active = false,
    this.onTap,
  });

  final String course;
  final String time;
  final String room;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    return Material(
      color: color.withValues(alpha: active ? 0.12 : 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.compact),
        side: BorderSide(color: color.withValues(alpha: active ? 0.32 : 0.14)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.compact),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.s4),
              Text(
                '$time · $room',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventRow extends StatelessWidget {
  const EventRow({
    super.key,
    required this.title,
    required this.meta,
    this.action,
    this.onTap,
  });

  final String title;
  final String meta;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.lavender.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.compact),
          border: Border.all(color: AppColors.lavender.withValues(alpha: 0.10)),
        ),
        child: const Icon(
          Icons.event_outlined,
          color: AppColors.lavender,
          size: 20,
        ),
      ),
      title: title,
      subtitle: meta,
      trailing: action,
      onTap: onTap,
    );
  }
}

class StudentIdentityHeader extends StatelessWidget {
  const StudentIdentityHeader({
    super.key,
    required this.name,
    required this.number,
    required this.department,
    this.trailing,
  });

  final String name;
  final String number;
  final String department;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: name,
      meta: number,
      subtitle: department,
      trailing: trailing,
    );
  }
}

class AppStatusPill extends StatelessWidget {
  const AppStatusPill({
    super.key,
    required this.label,
    this.type = AppStatusType.neutral,
  });

  final String label;
  final AppStatusType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      AppStatusType.success => AppColors.success,
      AppStatusType.warning => AppColors.warning,
      AppStatusType.error => Theme.of(context).colorScheme.error,
      AppStatusType.neutral => Theme.of(context).colorScheme.secondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class EduHeroCard extends HeroCard {
  const EduHeroCard({
    super.key,
    required super.title,
    required super.subtitle,
    required super.icon,
    super.meta,
    super.action,
    super.onTap,
    super.color,
    super.accent,
    super.illustration,
  });
}

class EduFeatureCard extends FeatureCard {
  const EduFeatureCard({
    super.key,
    required super.title,
    required super.subtitle,
    required super.icon,
    required super.color,
    super.onTap,
    super.trailing,
    super.action,
    super.height,
  });
}

class EduCourseCard extends CourseCard {
  const EduCourseCard({
    super.key,
    required super.title,
    required super.meta,
    required super.time,
    super.onTap,
    super.color,
  });
}

class EduSectionHeader extends AppSectionTitle {
  const EduSectionHeader({
    super.key,
    required super.title,
    super.trailing,
    super.padding,
  });
}

class EduPrimaryButton extends PrimaryButton {
  const EduPrimaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
  });
}

class EduSecondaryButton extends SecondaryButton {
  const EduSecondaryButton({
    super.key,
    required super.label,
    required super.onPressed,
    super.icon,
  });
}

class EduInput extends AppTextField {
  const EduInput({
    super.key,
    required super.label,
    super.controller,
    super.icon,
    super.onChanged,
    super.keyboardType,
    super.textInputAction,
  });
}

class EduChip extends StatelessWidget {
  const EduChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return ChoiceChip(
      selected: selected,
      label: Text(label),
      selectedColor: effectiveColor.withValues(alpha: 0.14),
      side: BorderSide(
        color: selected
            ? effectiveColor.withValues(alpha: 0.32)
            : Theme.of(context).dividerColor,
      ),
      onSelected: onSelected,
    );
  }
}

class EduStatusBadge extends AppStatusPill {
  const EduStatusBadge({super.key, required super.label, super.type});
}

class EduProgressCard extends StatelessWidget {
  const EduProgressCard({
    super.key,
    required this.title,
    required this.value,
    required this.progress,
    this.subtitle,
    this.color = AppColors.indigo,
  });

  final String title;
  final String value;
  final double progress;
  final String? subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color.withValues(
        alpha: Theme.of(context).brightness == Brightness.dark ? 0.13 : 0.06,
      ),
      border: BorderSide(color: color.withValues(alpha: 0.12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: AppSpacing.s12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.compact),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress.clamp(0, 1).toDouble(),
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class EduProfileHeader extends StudentIdentityHeader {
  const EduProfileHeader({
    super.key,
    required super.name,
    required super.number,
    required super.department,
    super.trailing,
  });
}

class EduBottomNavigation extends AppNavigationBar {
  const EduBottomNavigation({
    super.key,
    required super.selectedIndex,
    required super.onDestinationSelected,
  });
}

class EduEmptyState extends StatelessWidget {
  const EduEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final Object icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(AppRadius.surface),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: AppIcon(icon, color: colors.onSurface, size: 32),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class EduBottomSheet extends StatelessWidget {
  const EduBottomSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(AppRadius.compact),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.s12),
            child,
          ],
        ),
      ),
    );
  }
}

enum AppStatusType { neutral, success, warning, error }
