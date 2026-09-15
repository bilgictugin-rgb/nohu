import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_design.dart';
import '../../data/mock/mock_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.s12,
                    AppSpacing.page,
                    AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NextClassPanel(),
                      const SizedBox(height: AppSpacing.s16),
                      const _DaySummaryStrip(),
                      const AppSectionTitle(title: 'Hızlı erişim'),
                      _QuickAccessList(),
                      const AppSectionTitle(title: 'Bugünden öne çıkanlar'),
                      const _TodayFlow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = _formatToday();
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.hero),
        ),
        gradient: LinearGradient(
          colors: [AppColors.petrol, AppColors.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.s24,
                    AppSpacing.page,
                    AppSpacing.s32,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.s8),
                            Text(
                              'Merhaba, ${mockStudentProfile.firstName}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    height: 1.08,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      const Opacity(
                        opacity: 0.88,
                        child: NohuLogoMark(
                          width: 124,
                          height: 76,
                          showBorder: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: AppSpacing.page,
                  top: AppSpacing.s16,
                  child: _NotificationButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bildirimler, okunmamış bildirim var',
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.14),
              foregroundColor: Colors.white,
              minimumSize: const Size(44, 44),
            ),
            onPressed: () => context.goNamed('notifications'),
            icon: const AppIcon(AppIcons.notification),
          ),
          Positioned(
            right: 11,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.warning,
                border: Border.all(color: Colors.white, width: 1.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextClassPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HeroCard(
      color: AppColors.indigo,
      accent: AppColors.teal,
      icon: AppIcons.book,
      meta: '42 dk kaldı',
      title: 'Veri Yapıları ve Algoritmalar',
      subtitle: '10:00 · A102 Dersliği · Prof. Dr. Ahmet Şahin',
      onTap: () => context.goNamed(
        'courseDetail',
        pathParameters: {'courseId': 'alg-a'},
      ),
      action: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => context.goNamed('campusMap'),
          icon: const AppIcon(AppIcons.directions),
          label: const Text('Yol Tarifi'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.indigo,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.compact),
            ),
          ),
        ),
      ),
    );
  }
}

class _DaySummaryStrip extends StatelessWidget {
  const _DaySummaryStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 132,
            child: QuickActionCard(
              title: 'Yaklaşan Sınav',
              subtitle: 'Lineer Cebir · 7 gün',
              icon: AppIcons.clock,
              color: AppColors.lavender,
              onTap: () => context.go('/academic/exams'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: SizedBox(
            height: 132,
            child: QuickActionCard(
              title: 'Devamsızlık',
              subtitle: '1 ders sınırda',
              icon: AppIcons.attendance,
              color: AppColors.warning,
              onTap: () => context.go('/academic/attendance'),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAccessList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickItem(
        'Yemekhane',
        AppIcons.cafeteria,
        AppColors.petrol,
        'cafeteria',
        named: true,
      ),
      _QuickItem(
        'Notlarım',
        AppIcons.grades,
        AppColors.petrol,
        '/academic/grades',
      ),
      _QuickItem(
        'Etkinlikler',
        AppIcons.events,
        AppColors.petrol,
        'events',
        named: true,
      ),
      _QuickItem(
        'Devamsızlık',
        AppIcons.attendance,
        AppColors.petrol,
        '/academic/attendance',
      ),
      _QuickItem(
        'Ders Programı',
        AppIcons.schedule,
        AppColors.petrol,
        '/academic/schedule',
      ),
    ];

    void open(_QuickItem item) {
      if (item.named) {
        context.goNamed(item.route);
      } else {
        context.go(item.route);
      }
    }

    Widget card(_QuickItem item, {double height = 108}) {
      return SizedBox(
        height: height,
        child: QuickActionCard(
          title: item.label,
          icon: item.icon,
          color: item.color,
          onTap: () => open(item),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: card(items[0])),
            const SizedBox(width: AppSpacing.s12),
            Expanded(child: card(items[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        Row(
          children: [
            Expanded(child: card(items[2])),
            const SizedBox(width: AppSpacing.s12),
            Expanded(child: card(items[3])),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        card(items[4], height: 96),
      ],
    );
  }
}

class _QuickItem {
  const _QuickItem(
    this.label,
    this.icon,
    this.color,
    this.route, {
    this.named = false,
  });

  final String label;
  final Object icon;
  final Color color;
  final String route;
  final bool named;
}

class _TodayFlow extends StatelessWidget {
  const _TodayFlow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeatureCard(
          title: 'Bugünün menüsü',
          subtitle: 'Mercimek çorbası, tavuk kavurma, pilav ve cacık',
          icon: AppIcons.cafeteria,
          color: AppColors.petrol,
          trailing: const AppIcon(AppIcons.chevronRight),
          onTap: () => context.goNamed('cafeteria'),
        ),
        const SizedBox(height: AppSpacing.s12),
        FeatureCard(
          title: 'Yaklaşan etkinlik',
          subtitle: 'Flutter ile Kampüs Uygulamaları · 18 Mayıs 14:00',
          icon: AppIcons.events,
          color: AppColors.petrol,
          trailing: const AppIcon(AppIcons.chevronRight),
          onTap: () => context.goNamed('events'),
        ),
        AppSectionTitle(
          title: 'Son Duyurular',
          trailing: IconButton(
            tooltip: 'Duyurularda ara',
            onPressed: () => context.goNamed('announcements'),
            icon: const AppIcon(AppIcons.search),
          ),
        ),
        AppListSection(
          children: [
            _AnnouncementTile(
              icon: AppIcons.notification,
              title: 'Bahar Şenliği kayıtları başladı.',
              subtitle: '15-17 Mayıs · Kongre Merkezi çevresi',
              onTap: () => context.goNamed('announcements'),
            ),
            _AnnouncementTile(
              icon: AppIcons.academic,
              title: 'Akademik takvim güncellendi.',
              subtitle: 'Final haftası ve kayıt yenileme tarihleri yayınlandı.',
              onTap: () => context.goNamed('academicCalendar'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  const _AnnouncementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Object icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.42)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.70);
    return AppListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.compact),
          border: Border.all(color: theme.dividerColor),
        ),
        child: AppIcon(icon, color: theme.colorScheme.onSurface, size: 23),
      ),
      title: title,
      subtitle: subtitle,
      trailing: const AppIcon(AppIcons.chevronRight),
      onTap: onTap,
    );
  }
}

String _formatToday() {
  final now = DateTime.now();
  const days = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];
  const months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];
  return '${now.day} ${months[now.month - 1]}, ${days[now.weekday - 1]}';
}
