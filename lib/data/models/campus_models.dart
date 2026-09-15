class Community {
  const Community({
    required this.id,
    required this.name,
    required this.category,
    required this.members,
    required this.description,
    required this.nextEvent,
  });

  final String id;
  final String name;
  final String category;
  final int members;
  final String description;
  final CampusEvent nextEvent;
}

class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
  });

  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String category;
}

class StudentProfile {
  const StudentProfile({
    required this.firstName,
    required this.fullName,
    required this.number,
    required this.faculty,
    required this.department,
    required this.classLabel,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String firstName;
  final String fullName;
  final String number;
  final String faculty;
  final String department;
  final String classLabel;
  final String email;
  final String phone;
  final String address;

  String get name => fullName;
}

class GradeRecord {
  const GradeRecord({
    required this.courseCode,
    required this.courseName,
    required this.midterm,
    required this.finalExam,
    required this.makeup,
    required this.letter,
    required this.status,
  });

  final String courseCode;
  final String courseName;
  final int? midterm;
  final int? finalExam;
  final int? makeup;
  final String? letter;
  final String status;
}

class ExamRecord {
  const ExamRecord({
    required this.id,
    required this.courseName,
    required this.type,
    required this.date,
    required this.time,
    required this.building,
    required this.room,
    required this.past,
  });

  final String id;
  final String courseName;
  final String type;
  final String date;
  final String time;
  final String building;
  final String room;
  final bool past;
}

class AcademicDocument {
  const AcademicDocument({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.status,
  });

  final String id;
  final String title;
  final String updatedAt;
  final String status;
}

class AcademicCalendarEntry {
  const AcademicCalendarEntry({
    required this.date,
    required this.title,
    required this.description,
  });

  final String date;
  final String title;
  final String description;
}

class AdvisorInfo {
  const AdvisorInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.office,
    required this.hours,
  });

  final String name;
  final String title;
  final String email;
  final String office;
  final String hours;
}

class DiningMenu {
  const DiningMenu({
    required this.day,
    required this.date,
    required this.items,
    required this.calories,
    required this.allergens,
    required this.vegetarian,
    required this.hours,
  });

  final String day;
  final String date;
  final List<String> items;
  final int calories;
  final List<String> allergens;
  final bool vegetarian;
  final String hours;
}

class LibraryBook {
  const LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.location,
    required this.available,
    required this.summary,
  });

  final String id;
  final String title;
  final String author;
  final String location;
  final bool available;
  final String summary;
}

class BorrowedBook {
  const BorrowedBook({
    required this.title,
    required this.dueDate,
    required this.remainingDays,
  });

  final String title;
  final String dueDate;
  final int remainingDays;
}

class TransportLine {
  const TransportLine({
    required this.id,
    required this.name,
    required this.stops,
    required this.times,
    required this.duration,
  });

  final String id;
  final String name;
  final List<String> stops;
  final List<String> times;
  final String duration;
}

class CareerJob {
  const CareerJob({
    required this.id,
    required this.title,
    required this.company,
    required this.type,
    required this.location,
    required this.deadline,
    required this.description,
  });

  final String id;
  final String title;
  final String company;
  final String type;
  final String location;
  final String deadline;
  final String description;
}

class LostFoundItem {
  const LostFoundItem({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.description,
  });

  final String id;
  final String title;
  final String type;
  final String location;
  final String date;
  final String description;
}

class FavoriteItem {
  const FavoriteItem({
    required this.title,
    required this.subtitle,
    required this.category,
  });

  final String title;
  final String subtitle;
  final String category;
}

class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool enabled;
}
