import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  const AppAssets._();

  static const nohuLogo = 'assets/logos/nohu_logo.png';

  static const iconRoot = 'assets/icons';
  static const String? homeIcon = null;
  static const String? busIcon = null;
  static const String? cafeteriaIcon = null;
  static const String? academicIcon = null;
  static const String? scheduleIcon = null;
  static const String? gradesIcon = null;
  static const String? documentsIcon = null;
  static const String? clockIcon = null;
  static const String? notificationIcon = null;
  static const String? locationIcon = null;
  static const String? advisorIcon = null;
  static const String? bookIcon = null;
  static const String? eventsIcon = null;
  static const String? profileIcon = null;
  static const String? communitiesIcon = null;
  static const String? careerIcon = null;
  static const String? lostFoundIcon = null;
}

class AppIconSpec {
  const AppIconSpec(this.key, this.fallback, {this.assetPath});

  final String key;
  final IconData fallback;
  final String? assetPath;
}

class AppIcons {
  const AppIcons._();

  static const home = AppIconSpec(
    'home',
    Icons.home_outlined,
    assetPath: AppAssets.homeIcon,
  );
  static const homeSelected = AppIconSpec('homeSelected', Icons.home);
  static const academic = AppIconSpec(
    'academic',
    Icons.school_outlined,
    assetPath: AppAssets.academicIcon,
  );
  static const academicSelected = AppIconSpec('academicSelected', Icons.school);
  static const campus = AppIconSpec(
    'campus',
    Icons.location_on_outlined,
    assetPath: AppAssets.locationIcon,
  );
  static const campusSelected = AppIconSpec(
    'campusSelected',
    Icons.location_on,
  );
  static const profile = AppIconSpec(
    'profile',
    Icons.person_outline,
    assetPath: AppAssets.profileIcon,
  );
  static const profileSelected = AppIconSpec('profileSelected', Icons.person);

  static const notification = AppIconSpec(
    'notification',
    Icons.notifications_none_outlined,
    assetPath: AppAssets.notificationIcon,
  );
  static const cafeteria = AppIconSpec(
    'cafeteria',
    Icons.restaurant_menu_outlined,
    assetPath: AppAssets.cafeteriaIcon,
  );
  static const grades = AppIconSpec(
    'grades',
    Icons.sticky_note_2_outlined,
    assetPath: AppAssets.gradesIcon,
  );
  static const events = AppIconSpec(
    'events',
    Icons.celebration_outlined,
    assetPath: AppAssets.eventsIcon,
  );
  static const attendance = AppIconSpec(
    'attendance',
    Icons.fact_check_outlined,
    assetPath: AppAssets.scheduleIcon,
  );
  static const schedule = AppIconSpec(
    'schedule',
    Icons.event_available_outlined,
    assetPath: AppAssets.scheduleIcon,
  );
  static const clock = AppIconSpec(
    'clock',
    Icons.schedule_outlined,
    assetPath: AppAssets.clockIcon,
  );
  static const documents = AppIconSpec(
    'documents',
    Icons.file_copy_outlined,
    assetPath: AppAssets.documentsIcon,
  );
  static const advisor = AppIconSpec(
    'advisor',
    Icons.support_agent_outlined,
    assetPath: AppAssets.advisorIcon,
  );
  static const book = AppIconSpec(
    'book',
    Icons.menu_book_outlined,
    assetPath: AppAssets.bookIcon,
  );
  static const map = AppIconSpec(
    'map',
    Icons.location_on_outlined,
    assetPath: AppAssets.locationIcon,
  );
  static const transport = AppIconSpec(
    'transport',
    Icons.directions_bus_outlined,
    assetPath: AppAssets.busIcon,
  );
  static const communities = AppIconSpec(
    'communities',
    Icons.groups_outlined,
    assetPath: AppAssets.communitiesIcon,
  );
  static const career = AppIconSpec(
    'career',
    Icons.work_outline,
    assetPath: AppAssets.careerIcon,
  );
  static const lostFound = AppIconSpec(
    'lostFound',
    Icons.inventory_2_outlined,
    assetPath: AppAssets.lostFoundIcon,
  );
  static const favorite = AppIconSpec('favorite', Icons.favorite_border);
  static const theme = AppIconSpec('theme', Icons.contrast_outlined);
  static const language = AppIconSpec('language', Icons.language_outlined);
  static const accessibility = AppIconSpec(
    'accessibility',
    Icons.accessibility_new_outlined,
  );
  static const help = AppIconSpec('help', Icons.help_outline);
  static const feedback = AppIconSpec('feedback', Icons.feedback_outlined);
  static const privacy = AppIconSpec('privacy', Icons.verified_user_outlined);
  static const edit = AppIconSpec('edit', Icons.edit_outlined);
  static const logout = AppIconSpec('logout', Icons.logout);
  static const search = AppIconSpec('search', Icons.search_outlined);
  static const directions = AppIconSpec('directions', Icons.near_me_outlined);
  static const chevronRight = AppIconSpec('chevronRight', Icons.chevron_right);
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.color, this.size = 22});

  final Object icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final spec = _spec(icon);
    final assetPath = spec.assetPath;
    if (assetPath == null || assetPath.isEmpty) {
      return Icon(spec.fallback, color: color, semanticLabel: null, size: size);
    }

    final effectiveColor = color ?? IconTheme.of(context).color;
    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: effectiveColor == null
            ? null
            : ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      );
    }

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        effectiveColor ?? Colors.black,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        semanticLabel: null,
      ),
    );
  }

  AppIconSpec _spec(Object icon) {
    if (icon is AppIconSpec) return icon;
    if (icon is IconData) return AppIconSpec('material', icon);
    throw ArgumentError.value(icon, 'icon', 'Unsupported app icon reference');
  }
}
