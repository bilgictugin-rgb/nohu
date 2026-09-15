import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/course_section.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  var _view = _ScheduleView.weekly;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: FutureBuilder<List<CourseSection>>(
        future: ref.read(mockRepositoryProvider).getCourseSections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingState();
          }
          if (snapshot.hasError) {
            return ErrorState(message: snapshot.error.toString());
          }
          final sections = snapshot.data ?? [];
          if (sections.isEmpty) {
            return const EmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'Program yok',
              message: 'Seçili dönem için ders programı bulunamadı.',
            );
          }

          return ListView(
            children: [
              const AppHeader(
                meta: '2024-2025 Bahar',
                title: 'Ders Programım',
                subtitle: 'Bugünkü derslerini ve haftalık akışını takip et.',
                compact: true,
              ),
              HeroCard(
                onTap: () => context.go('/academic/schedule-builder'),
                meta: 'Akıllı öneri',
                title: 'Yeni Program Oluştur',
                subtitle: 'Şubeleri ve tercihleri seçerek haftanı planla.',
                icon: Icons.auto_awesome_outlined,
                color: AppColors.indigo,
                accent: AppColors.teal,
                action: FilledButton.icon(
                  onPressed: () => context.go('/academic/schedule-builder'),
                  icon: const Icon(Icons.add),
                  label: const Text('Başla'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              SegmentedButton<_ScheduleView>(
                segments: const [
                  ButtonSegment(
                    value: _ScheduleView.weekly,
                    label: Text('Hafta'),
                    icon: Icon(Icons.view_week_outlined),
                  ),
                  ButtonSegment(
                    value: _ScheduleView.daily,
                    label: Text('Bugün'),
                    icon: Icon(Icons.today_outlined),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (value) =>
                    setState(() => _view = value.first),
              ),
              const SizedBox(height: AppSpacing.s12),
              _DaySelector(sections: sections),
              const SizedBox(height: AppSpacing.s12),
              if (_view == _ScheduleView.weekly)
                _WeeklySchedule(sections: sections.take(6).toList())
              else
                _DailySchedule(sections: sections.take(3).toList()),
            ],
          );
        },
      ),
    );
  }
}

enum _ScheduleView { weekly, daily }

class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.sections});

  final List<CourseSection> sections;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var day = 1; day <= 5; day++)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s8),
              child: _DayPill(
                day: CourseSection.dayNames[day - 1],
                count: sections.where((item) => item.day == day).length,
                selected: day == 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.day,
    required this.count,
    required this.selected,
  });

  final String day;
  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: selected ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.surface),
        border: Border.all(color: color.withValues(alpha: 0.14)),
      ),
      child: Column(
        children: [
          Text(
            day,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text('$count ders', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _WeeklySchedule extends StatelessWidget {
  const _WeeklySchedule({required this.sections});

  final List<CourseSection> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var day = 1; day <= 5; day++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CourseSection.dayNames[day - 1],
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  ...sections
                      .where((item) => item.day == day)
                      .map((item) => _ScheduleLine(section: item)),
                  if (sections.where((item) => item.day == day).isEmpty)
                    Text(
                      'Ders yok',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DailySchedule extends StatelessWidget {
  const _DailySchedule({required this.sections});

  final List<CourseSection> sections;

  @override
  Widget build(BuildContext context) {
    final today = sections.where((item) => item.day == 1).toList();
    return Column(
      children: [
        for (final section in today)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(child: _ScheduleLine(section: section)),
          ),
      ],
    );
  }
}

class _ScheduleLine extends StatelessWidget {
  const _ScheduleLine({required this.section});

  final CourseSection section;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.goNamed(
        'courseDetail',
        pathParameters: {'courseId': section.id},
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.indigo.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                CourseSection.formatDuration(section.start),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.indigo,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${section.code} · Şube ${section.branch} · ${section.room}',
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
