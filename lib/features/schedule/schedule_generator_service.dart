import '../../data/models/course_section.dart';

class ScheduleGeneratorService {
  List<SchedulePlan> generate({
    required List<CourseSection> sections,
    required Set<String> selectedCourseIds,
    required SchedulePreferences preferences,
  }) {
    final grouped = <String, List<CourseSection>>{};
    for (final section in sections) {
      if (!selectedCourseIds.contains(section.courseId)) continue;
      grouped.putIfAbsent(section.courseId, () => []).add(section);
    }

    if (grouped.isEmpty) return [];

    final plans = <SchedulePlan>[];
    _walk(
      groups: grouped.values.toList(),
      index: 0,
      picked: [],
      preferences: preferences,
      plans: plans,
    );

    plans.sort((a, b) => b.score.compareTo(a.score));
    return plans.take(10).toList(growable: false);
  }

  void _walk({
    required List<List<CourseSection>> groups,
    required int index,
    required List<CourseSection> picked,
    required SchedulePreferences preferences,
    required List<SchedulePlan> plans,
  }) {
    if (index == groups.length) {
      plans.add(_score(picked, preferences));
      return;
    }

    for (final candidate in groups[index]) {
      final hasConflict = picked.any(candidate.conflictsWith);
      if (hasConflict) continue;

      picked.add(candidate);
      _walk(
        groups: groups,
        index: index + 1,
        picked: picked,
        preferences: preferences,
        plans: plans,
      );
      picked.removeLast();
    }
  }

  SchedulePlan _score(
    List<CourseSection> sections,
    SchedulePreferences preferences,
  ) {
    final sorted = [...sections]
      ..sort((a, b) {
        final dayCompare = a.day.compareTo(b.day);
        return dayCompare == 0 ? a.start.compareTo(b.start) : dayCompare;
      });

    final usedDays = sorted.map((item) => item.day).toSet();
    final freeDayCount = 5 - usedDays.length;
    final totalGap = _gapMinutes(sorted);
    final firstStart = sorted.map((item) => item.start).reduce(_minDuration);
    final lastEnd = sorted.map((item) => item.end).reduce(_maxDuration);

    var score = 100.0;
    score -= totalGap / (preferences.compactGaps ? 25 : 55);
    score += freeDayCount * (preferences.reduceCampusDays ? 6 : 2);

    for (final section in sorted) {
      if (preferences.freeDays.contains(section.day)) score -= 22;
      if (section.start < preferences.earliest) score -= 10;
      if (section.end > preferences.latest) score -= 10;
      if (preferences.preferMorning &&
          section.start >= const Duration(hours: 12)) {
        score -= 5;
      }
      if (preferences.preferAfternoon &&
          section.start < const Duration(hours: 12)) {
        score -= 5;
      }
    }

    final compatibility = score.clamp(0, 100).round();
    return SchedulePlan(
      sections: sorted,
      score: score,
      compatibility: compatibility,
      freeDayCount: freeDayCount,
      totalGapMinutes: totalGap,
      firstStart: firstStart,
      lastEnd: lastEnd,
    );
  }

  int _gapMinutes(List<CourseSection> sorted) {
    var total = 0;
    for (var i = 0; i < sorted.length - 1; i++) {
      final current = sorted[i];
      final next = sorted[i + 1];
      if (current.day == next.day && next.start > current.end) {
        total += (next.start - current.end).inMinutes;
      }
    }
    return total;
  }

  Duration _minDuration(Duration a, Duration b) => a < b ? a : b;

  Duration _maxDuration(Duration a, Duration b) => a > b ? a : b;
}
