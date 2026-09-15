class CourseSection {
  const CourseSection({
    required this.id,
    required this.courseId,
    required this.code,
    required this.name,
    required this.instructor,
    required this.branch,
    required this.day,
    required this.start,
    required this.end,
    required this.room,
  });

  final String id;
  final String courseId;
  final String code;
  final String name;
  final String instructor;
  final String branch;
  final int day;
  final Duration start;
  final Duration end;
  final String room;

  String get dayName => dayNames[day - 1];

  String get timeLabel => '${formatDuration(start)}-${formatDuration(end)}';

  bool conflictsWith(CourseSection other) {
    if (day != other.day) return false;
    return start < other.end && other.start < end;
  }

  static const dayNames = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma'];

  static String formatDuration(Duration value) {
    final hours = value.inHours.toString().padLeft(2, '0');
    final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

class SchedulePreferences {
  const SchedulePreferences({
    this.freeDays = const {},
    this.preferMorning = false,
    this.preferAfternoon = false,
    this.compactGaps = true,
    this.reduceCampusDays = true,
    this.earliest = const Duration(hours: 8),
    this.latest = const Duration(hours: 18),
  });

  final Set<int> freeDays;
  final bool preferMorning;
  final bool preferAfternoon;
  final bool compactGaps;
  final bool reduceCampusDays;
  final Duration earliest;
  final Duration latest;
}

class SchedulePlan {
  const SchedulePlan({
    required this.sections,
    required this.score,
    required this.compatibility,
    required this.freeDayCount,
    required this.totalGapMinutes,
    required this.firstStart,
    required this.lastEnd,
  });

  final List<CourseSection> sections;
  final double score;
  final int compatibility;
  final int freeDayCount;
  final int totalGapMinutes;
  final Duration firstStart;
  final Duration lastEnd;

  String get firstLastLabel =>
      '${CourseSection.formatDuration(firstStart)} / ${CourseSection.formatDuration(lastEnd)}';
}
