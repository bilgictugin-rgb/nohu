import '../mock/mock_data.dart';
import '../models/attendance_models.dart';
import '../models/campus_models.dart';
import '../models/course_section.dart';

class MockCampusRepository {
  Future<List<CourseSection>> getCourseSections() async => mockSections;

  CourseSection? getCourseSectionById(String id) {
    return mockSections.where((item) => item.id == id).firstOrNull;
  }

  Future<List<AttendanceCourse>> getAttendance() async => mockAttendance;

  Future<List<Community>> getCommunities() async => mockCommunities;

  Community? getCommunityById(String id) {
    return mockCommunities.where((item) => item.id == id).firstOrNull;
  }

  Future<List<CampusEvent>> getEvents() async => mockEvents;

  CampusEvent? getEventById(String id) {
    return mockEvents.where((item) => item.id == id).firstOrNull;
  }

  StudentProfile getStudentProfile() => mockStudentProfile;

  Future<List<GradeRecord>> getGrades() async => mockGrades;

  Future<List<ExamRecord>> getExams() async => mockExams;

  Future<List<AcademicDocument>> getDocuments() async => mockDocuments;

  Future<List<AcademicCalendarEntry>> getAcademicCalendar() async =>
      mockAcademicCalendar;

  AdvisorInfo getAdvisor() => mockAdvisor;

  Future<List<DiningMenu>> getDiningWeek() async => mockDiningWeek;

  Future<List<LibraryBook>> getLibraryBooks() async => mockLibraryBooks;

  Future<List<BorrowedBook>> getBorrowedBooks() async => mockBorrowedBooks;

  Future<List<TransportLine>> getTransportLines() async => mockTransportLines;

  Future<List<CareerJob>> getCareerJobs() async => mockCareerJobs;

  CareerJob? getCareerJobById(String id) {
    return mockCareerJobs.where((item) => item.id == id).firstOrNull;
  }

  Future<List<LostFoundItem>> getLostFoundItems() async => mockLostFoundItems;

  LostFoundItem? getLostFoundItemById(String id) {
    return mockLostFoundItems.where((item) => item.id == id).firstOrNull;
  }

  Future<List<FavoriteItem>> getFavorites() async => mockFavorites;

  Future<List<NotificationPreference>> getNotificationPreferences() async =>
      mockNotificationPreferences;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
