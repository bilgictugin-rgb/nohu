enum PersonalAttendanceStatus {
  attended('Katıldım'),
  absent('Katılmadım'),
  cancelled('Ders yapılmadı'),
  excused('İzinli/Raporlu');

  const PersonalAttendanceStatus(this.label);
  final String label;
}

class AttendanceCourse {
  const AttendanceCourse({
    required this.code,
    required this.name,
    required this.limit,
    required this.personalAbsences,
    required this.officialAbsences,
    required this.usedRight,
    required this.remainingRight,
    required this.differences,
    this.officialEntered = true,
  });

  final String code;
  final String name;
  final int limit;
  final int personalAbsences;
  final int? officialAbsences;
  final int usedRight;
  final int remainingRight;
  final List<String> differences;
  final bool officialEntered;

  bool get hasMismatch =>
      officialEntered &&
      officialAbsences != null &&
      officialAbsences != personalAbsences;
}
