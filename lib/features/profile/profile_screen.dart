import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../data/models/campus_models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(mockRepositoryProvider).getStudentProfile();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _StudentIdentityHeader(profile: profile)),
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
                    AppSpacing.s16,
                    AppSpacing.page,
                    AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionTitle(title: 'Hesabım'),
                      _ProfileSection(
                        items: const [
                          _ProfileItem(
                            'Kişisel Bilgilerim',
                            'İletişim ve adres bilgileri',
                            AppIcons.documents,
                            AppColors.indigo,
                            '/profile/personal-info',
                          ),
                          _ProfileItem(
                            'Bildirim Ayarları',
                            'Ders, etkinlik ve duyuru tercihleri',
                            AppIcons.notification,
                            AppColors.indigo,
                            '/profile/notification-settings',
                          ),
                        ],
                      ),
                      const AppSectionTitle(title: 'Akademik bilgiler'),
                      _ProfileSection(
                        items: const [
                          _ProfileItem(
                            'Akademik Danışmanım',
                            'Prof. Dr. Mehmet Kaya',
                            AppIcons.advisor,
                            AppColors.indigo,
                            '/profile/advisor',
                          ),
                          _ProfileItem(
                            'Favorilerim',
                            'Program, etkinlik ve hatlar',
                            AppIcons.favorite,
                            AppColors.indigo,
                            '/profile/favorites',
                          ),
                        ],
                      ),
                      const AppSectionTitle(title: 'Tercihler'),
                      _ProfileSection(
                        items: const [
                          _ProfileItem(
                            'Tema',
                            'Açık, koyu veya sistem',
                            AppIcons.theme,
                            AppColors.indigo,
                            '/profile/theme',
                          ),
                          _ProfileItem(
                            'Dil',
                            'Türkçe',
                            AppIcons.language,
                            AppColors.indigo,
                            '/profile/language',
                          ),
                          _ProfileItem(
                            'Erişilebilirlik',
                            'Yazı boyutu ve kontrast',
                            AppIcons.accessibility,
                            AppColors.indigo,
                            '/profile/accessibility',
                          ),
                        ],
                      ),
                      const AppSectionTitle(title: 'Destek ve güvenlik'),
                      _ProfileSection(
                        items: const [
                          _ProfileItem(
                            'Yardım ve SSS',
                            'Sık sorulan sorular',
                            AppIcons.help,
                            AppColors.indigo,
                            '/profile/help',
                          ),
                          _ProfileItem(
                            'Geri Bildirim',
                            'Öneri ve hata bildirimi',
                            AppIcons.feedback,
                            AppColors.indigo,
                            '/profile/feedback',
                          ),
                          _ProfileItem(
                            'Gizlilik ve Güvenlik',
                            'Oturum ve izinler',
                            AppIcons.privacy,
                            AppColors.indigo,
                            '/profile/privacy',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _confirmLogout(context, ref),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          icon: const AppIcon(AppIcons.logout),
                          label: const Text('Çıkış Yap'),
                        ),
                      ),
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

class _StudentIdentityHeader extends StatelessWidget {
  const _StudentIdentityHeader({required this.profile});

  final StudentProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.petrol, AppColors.tealDark, AppColors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s16,
                AppSpacing.page,
                AppSpacing.s24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        tooltip: 'Profili düzenle',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(48, 48),
                        ),
                        onPressed: () => context.go('/profile/edit'),
                        icon: const AppIcon(AppIcons.edit),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 62,
                        height: 78,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(
                            AppRadius.surface,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24),
                          ),
                        ),
                        child: const AppIcon(
                          AppIcons.profile,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.12,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s8),
                            Text(
                              '${profile.number} · ${profile.classLabel}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              '${profile.faculty} · ${profile.department}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.74),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s20),
                  const _AcademicMiniSummary(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AcademicMiniSummary extends StatelessWidget {
  const _AcademicMiniSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ProfileSummaryCard(
            label: 'GNO',
            value: '3.24',
            color: AppColors.petrol,
          ),
        ),
        SizedBox(width: AppSpacing.s8),
        Expanded(
          child: ProfileSummaryCard(
            label: 'Kredi',
            value: '120',
            color: AppColors.teal,
          ),
        ),
        SizedBox(width: AppSpacing.s8),
        Expanded(
          child: ProfileSummaryCard(
            label: 'Dönem',
            value: '6.',
            color: AppColors.lavender,
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.items});

  final List<_ProfileItem> items;

  @override
  Widget build(BuildContext context) {
    return AppListSection(
      children: [for (final item in items) _ProfileTile(item: item)],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.item});

  final _ProfileItem item;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      onTap: () => context.go(item.route),
      leading: AppIconBadge(icon: item.icon, color: item.color, size: 38),
      title: item.title,
      subtitle: item.subtitle,
      trailing: const AppIcon(AppIcons.chevronRight),
      semanticLabel: '${item.title} ekranını aç',
    );
  }
}

class _ProfileItem {
  const _ProfileItem(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.route,
  );

  final String title;
  final String subtitle;
  final Object icon;
  final Color color;
  final String route;
}

Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
  final approved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Çıkış Yap'),
      content: const Text('Oturumunu kapatmak istediğine emin misin?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Çıkış Yap'),
        ),
      ],
    ),
  );
  if (approved != true) return;
  await ref.read(sharedPreferencesProvider).setBool('rememberedLogin', false);
  if (context.mounted) context.go('/login');
}
