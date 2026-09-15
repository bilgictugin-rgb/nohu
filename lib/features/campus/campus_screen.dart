import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/campus_models.dart';

class CampusScreen extends ConsumerStatefulWidget {
  const CampusScreen({super.key});

  @override
  ConsumerState<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends ConsumerState<CampusScreen> {
  var _category = 'Tümü';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: FutureBuilder<List<Community>>(
        future: ref.read(mockRepositoryProvider).getCommunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingState();
          }
          if (snapshot.hasError) {
            return ErrorState(message: snapshot.error.toString());
          }

          final communities = snapshot.data ?? [];
          final query = _search.text.toLowerCase();
          final filtered = communities.where((item) {
            final matchesCategory =
                _category == 'Tümü' || item.category == _category;
            final matchesQuery =
                query.isEmpty ||
                item.name.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query);
            return matchesCategory && matchesQuery;
          }).toList();
          final events = communities.map((item) => item.nextEvent).toList();

          return ListView(
            children: [
              const AppHeader(
                meta: 'Niğde Ömer Halisdemir Üniversitesi',
                title: 'Kampüsü keşfet',
                subtitle:
                    'Bugünkü etkinlikler, sık kullanılan yerler ve topluluklar.',
                compact: true,
              ),
              TextField(
                controller: _search,
                decoration: const InputDecoration(
                  labelText: 'Topluluk, etkinlik veya yer ara',
                  prefixIcon: AppIcon(AppIcons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.s16),
              HeroCard(
                title: 'Haritadan başla',
                subtitle:
                    'Yemekhane, kütüphane, duraklar ve fakülte binaları tek bakışta.',
                icon: AppIcons.map,
                color: AppColors.green,
                accent: AppColors.teal,
                action: FilledButton.icon(
                  onPressed: () => context.goNamed('campusMap'),
                  icon: const AppIcon(AppIcons.map),
                  label: const Text('Harita'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.green,
                  ),
                ),
              ),
              const AppSectionTitle(title: 'Kampüs modülleri'),
              _CampusGrid(),
              const AppSectionTitle(title: 'Topluluk filtresi'),
              _CategoryFilter(
                selected: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
              const AppSectionTitle(title: 'Topluluklar'),
              if (filtered.isEmpty)
                const EmptyState(
                  icon: AppIcons.communities,
                  title: 'Bu aramayla topluluk bulunmadı.',
                  message:
                      'Arama kelimesini kısaltabilir veya filtreyi değiştirebilirsin.',
                )
              else
                AppListSection(
                  children: [
                    for (final community in filtered)
                      _CommunityRow(community: community),
                  ],
                ),
              const AppSectionTitle(title: 'Bugünkü kampüs etkinlikleri'),
              AppListSection(
                children: [for (final event in events) _EventRow(event: event)],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CampusGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      _CampusItem(
        'Kampüs Haritası',
        'Binalar ve duraklar',
        AppIcons.map,
        AppColors.petrol,
        'campusMap',
      ),
      _CampusItem(
        'Yemekhane',
        'Bugün 11:30-14:00 açık',
        AppIcons.cafeteria,
        AppColors.petrol,
        'cafeteria',
      ),
      _CampusItem(
        'Kütüphane',
        'Sessiz çalışma alanı uygun',
        AppIcons.book,
        AppColors.petrol,
        'library',
      ),
      _CampusItem(
        'Ulaşım',
        'Merkez hattı 12 dk',
        AppIcons.transport,
        AppColors.petrol,
        'transport',
      ),
      _CampusItem(
        'Etkinlikler',
        'Takvim ve katılım',
        AppIcons.events,
        AppColors.petrol,
        'events',
      ),
      _CampusItem(
        'Topluluklar',
        'Kulüpler ve başvuru',
        AppIcons.communities,
        AppColors.petrol,
        'communities',
      ),
      _CampusItem(
        'Kariyer ve Staj',
        'İlanlar ve başvurular',
        AppIcons.career,
        AppColors.petrol,
        'career',
      ),
      _CampusItem(
        'Kayıp Eşya',
        'Kayıp ve bulunan ilanları',
        AppIcons.lostFound,
        AppColors.petrol,
        'lostFound',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.s12,
        mainAxisSpacing: AppSpacing.s12,
        childAspectRatio: 1.08,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return FeatureCard(
          title: item.title,
          subtitle: item.subtitle,
          icon: item.icon,
          color: item.color,
          onTap: () => context.goNamed(item.routeName),
        );
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const categories = ['Tümü', 'Teknoloji', 'Kariyer', 'Kültür'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s8),
              child: FilterChip(
                selected: selected == category,
                label: Text(category),
                onSelected: (_) => onChanged(category),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommunityRow extends StatelessWidget {
  const _CommunityRow({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      onTap: () => context.goNamed(
        'communityDetail',
        pathParameters: {'communityId': community.id},
      ),
      leading: const AppIconBadge(
        icon: AppIcons.communities,
        color: AppColors.lavender,
        size: 38,
      ),
      title: community.name,
      subtitle:
          '${community.category} · ${community.members} üye · ${community.nextEvent.date}',
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      onTap: () =>
          context.goNamed('eventDetail', pathParameters: {'eventId': event.id}),
      leading: const AppIconBadge(
        icon: AppIcons.events,
        color: AppColors.lavender,
        size: 38,
      ),
      title: event.title,
      subtitle: '${event.date} · ${event.time} · ${event.location}',
      trailing: TextButton(
        onPressed: () =>
            _showSnack(context, '${event.title} katılım listene eklendi.'),
        child: const Text('Katılacağım'),
      ),
    );
  }
}

class _CampusItem {
  const _CampusItem(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.routeName,
  );

  final String title;
  final String subtitle;
  final Object icon;
  final Color color;
  final String routeName;
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
