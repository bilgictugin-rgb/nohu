import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/course_section.dart';
import 'schedule_generator_service.dart';

class ScheduleBuilderScreen extends StatefulWidget {
  const ScheduleBuilderScreen({super.key});

  @override
  State<ScheduleBuilderScreen> createState() => _ScheduleBuilderScreenState();
}

class _ScheduleBuilderScreenState extends State<ScheduleBuilderScreen> {
  final _service = ScheduleGeneratorService();
  late Set<String> _selectedCourseIds;
  late Set<String> _selectedSectionIds;
  var _freeDay = 0;
  var _preferMorning = false;
  var _preferAfternoon = false;
  var _compactGaps = true;
  var _reduceCampusDays = true;
  var _timeRange = const RangeValues(8, 18);
  var _plans = <SchedulePlan>[];
  final _favorites = <int>{};
  final _compare = <int>{};

  @override
  void initState() {
    super.initState();
    _selectedCourseIds = mockSections.map((item) => item.courseId).toSet();
    _selectedSectionIds = mockSections.map((item) => item.id).toSet();
    _generate();
  }

  void _generate() {
    final prefs = SchedulePreferences(
      freeDays: _freeDay == 0 ? {} : {_freeDay},
      preferMorning: _preferMorning,
      preferAfternoon: _preferAfternoon,
      compactGaps: _compactGaps,
      reduceCampusDays: _reduceCampusDays,
      earliest: Duration(hours: _timeRange.start.round()),
      latest: Duration(hours: _timeRange.end.round()),
    );
    final availableSections = mockSections
        .where((item) => _selectedSectionIds.contains(item.id))
        .toList(growable: false);

    setState(() {
      _plans = _service.generate(
        sections: availableSections,
        selectedCourseIds: _selectedCourseIds,
        preferences: prefs,
      );
      _compare.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courses = _groupByCourse();
    return AppScaffold(
      body: ListView(
        children: [
          const AppHeader(
            meta: 'Akıllı program',
            title: 'Program Oluşturucu',
            subtitle:
                'Derslerini seç, şubelerini belirle ve sonuçları karşılaştır.',
            compact: true,
          ),
          AppCard(
            color: AppColors.indigo,
            elevated: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    AppIconBadge(
                      icon: Icons.tune_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Text(
                        '5 adımda uygun haftalık program',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s16),
                _BuilderProgress(
                  steps: const [
                    'Ders',
                    'Şube',
                    'Tercih',
                    'Oluştur',
                    'Karşılaştır',
                  ],
                  activeIndex: _plans.isEmpty ? 2 : 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Dersler ve şubeler',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final entry in courses.entries) ...[
            _CourseSelector(
              sections: entry.value,
              selectedCourseIds: _selectedCourseIds,
              selectedSectionIds: _selectedSectionIds,
              onChanged: (courseIds, sectionIds) {
                setState(() {
                  _selectedCourseIds = courseIds;
                  _selectedSectionIds = sectionIds;
                });
              },
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text('Tercihler', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  initialValue: _freeDay,
                  decoration: const InputDecoration(
                    labelText: 'Boş bırakılacak gün',
                    prefixIcon: Icon(Icons.free_breakfast_outlined),
                  ),
                  items: [
                    const DropdownMenuItem(value: 0, child: Text('Yok')),
                    for (var i = 1; i <= 5; i++)
                      DropdownMenuItem(
                        value: i,
                        child: Text(CourseSection.dayNames[i - 1]),
                      ),
                  ],
                  onChanged: (value) => setState(() => _freeDay = value ?? 0),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  value: _preferMorning,
                  onChanged: (value) => setState(() {
                    _preferMorning = value;
                    if (value) _preferAfternoon = false;
                  }),
                  title: const Text('Sabah tercihi'),
                  secondary: const Icon(Icons.wb_sunny_outlined),
                ),
                SwitchListTile(
                  value: _preferAfternoon,
                  onChanged: (value) => setState(() {
                    _preferAfternoon = value;
                    if (value) _preferMorning = false;
                  }),
                  title: const Text('Öğleden sonra tercihi'),
                  secondary: const Icon(Icons.wb_twilight_outlined),
                ),
                SwitchListTile(
                  value: _compactGaps,
                  onChanged: (value) => setState(() => _compactGaps = value),
                  title: const Text('Dersler arasında az boşluk'),
                  secondary: const Icon(Icons.compress_outlined),
                ),
                SwitchListTile(
                  value: _reduceCampusDays,
                  onChanged: (value) =>
                      setState(() => _reduceCampusDays = value),
                  title: const Text('Kampüse gelinen gün sayısını azalt'),
                  secondary: const Icon(Icons.calendar_view_week_outlined),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'En erken ve en geç ders saati: ${_timeRange.start.round()}:00 - ${_timeRange.end.round()}:00',
                  ),
                ),
                RangeSlider(
                  min: 8,
                  max: 19,
                  divisions: 11,
                  labels: RangeLabels(
                    '${_timeRange.start.round()}:00',
                    '${_timeRange.end.round()}:00',
                  ),
                  values: _timeRange,
                  onChanged: (value) => setState(() => _timeRange = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _generate,
            icon: const Icon(Icons.auto_awesome_outlined),
            label: const Text('En Uygun Programları Sırala'),
          ),
          const SizedBox(height: 18),
          if (_compare.length == 2) ...[
            _ComparePanel(
              first: _plans[_compare.first],
              second: _plans[_compare.last],
            ),
            const SizedBox(height: 12),
          ],
          Text('Sonuçlar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_plans.isEmpty)
            const EmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'Uygun program bulunamadı',
              message: 'Ders veya şube seçimini genişletip tekrar dene.',
            )
          else
            for (var i = 0; i < _plans.length; i++) ...[
              _PlanCard(
                index: i,
                plan: _plans[i],
                favorite: _favorites.contains(i),
                comparing: _compare.contains(i),
                onFavorite: () => setState(() {
                  _favorites.contains(i)
                      ? _favorites.remove(i)
                      : _favorites.add(i);
                }),
                onCompare: () => setState(() {
                  if (_compare.contains(i)) {
                    _compare.remove(i);
                  } else {
                    if (_compare.length == 2) _compare.remove(_compare.first);
                    _compare.add(i);
                  }
                }),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  Map<String, List<CourseSection>> _groupByCourse() {
    final grouped = <String, List<CourseSection>>{};
    for (final section in mockSections) {
      grouped.putIfAbsent(section.courseId, () => []).add(section);
    }
    return grouped;
  }
}

class _BuilderProgress extends StatelessWidget {
  const _BuilderProgress({required this.steps, required this.activeIndex});

  final List<String> steps;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: i <= activeIndex
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: i <= activeIndex
                            ? AppColors.indigo
                            : Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s6),
                Text(
                  steps[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (i != steps.length - 1)
            Container(
              width: 14,
              height: 2,
              margin: const EdgeInsets.only(bottom: 20),
              color: Colors.white.withValues(alpha: 0.28),
            ),
        ],
      ],
    );
  }
}

class _CourseSelector extends StatelessWidget {
  const _CourseSelector({
    required this.sections,
    required this.selectedCourseIds,
    required this.selectedSectionIds,
    required this.onChanged,
  });

  final List<CourseSection> sections;
  final Set<String> selectedCourseIds;
  final Set<String> selectedSectionIds;
  final void Function(Set<String>, Set<String>) onChanged;

  @override
  Widget build(BuildContext context) {
    final first = sections.first;
    final selectedCourse = selectedCourseIds.contains(first.courseId);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: selectedCourse,
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${first.code} · ${first.name}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('${sections.length} şube seçilebilir'),
            onChanged: (value) {
              final courses = {...selectedCourseIds};
              final branches = {...selectedSectionIds};
              if (value ?? false) {
                courses.add(first.courseId);
                branches.addAll(sections.map((item) => item.id));
              } else {
                courses.remove(first.courseId);
                branches.removeAll(sections.map((item) => item.id));
              }
              onChanged(courses, branches);
            },
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final section in sections)
                FilterChip(
                  selected: selectedSectionIds.contains(section.id),
                  onSelected: selectedCourse
                      ? (value) {
                          final courses = {...selectedCourseIds};
                          final branches = {...selectedSectionIds};
                          value
                              ? branches.add(section.id)
                              : branches.remove(section.id);
                          onChanged(courses, branches);
                        }
                      : null,
                  label: Text(
                    'Şube ${section.branch} · ${section.dayName} ${section.timeLabel}',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.index,
    required this.plan,
    required this.favorite,
    required this.comparing,
    required this.onFavorite,
    required this.onCompare,
  });

  final int index;
  final SchedulePlan plan;
  final bool favorite;
  final bool comparing;
  final VoidCallback onFavorite;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Program ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '%${plan.compatibility}',
                style: const TextStyle(
                  color: AppColors.indigo,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: plan.compatibility / 100),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Metric(label: 'Boş gün', value: '${plan.freeDayCount}'),
              _Metric(
                label: 'Toplam boşluk',
                value: '${plan.totalGapMinutes} dk',
              ),
              _Metric(label: 'İlk / son ders', value: plan.firstLastLabel),
            ],
          ),
          const SizedBox(height: 12),
          for (final section in plan.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 82,
                    child: Text(
                      section.dayName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${section.timeLabel} · ${section.code} ${section.branch} · ${section.room}',
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onFavorite,
                  icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
                  label: Text(favorite ? 'Favoride' : 'Favoriye ekle'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: onCompare,
                  icon: Icon(comparing ? Icons.done : Icons.compare_arrows),
                  label: Text(comparing ? 'Seçildi' : 'Karşılaştır'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ComparePanel extends StatelessWidget {
  const _ComparePanel({required this.first, required this.second});

  final SchedulePlan first;
  final SchedulePlan second;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.indigo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Program Karşılaştırma',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CompareColumn(title: 'A', plan: first),
              ),
              Container(
                width: 1,
                height: 92,
                color: Colors.white.withValues(alpha: 0.18),
              ),
              Expanded(
                child: _CompareColumn(title: 'B', plan: second),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompareColumn extends StatelessWidget {
  const _CompareColumn({required this.title, required this.plan});

  final String title;
  final SchedulePlan plan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Program $title', style: const TextStyle(color: Colors.white70)),
          Text(
            'Uyum %${plan.compatibility}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '${plan.freeDayCount} boş gün',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '${plan.totalGapMinutes} dk boşluk',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
