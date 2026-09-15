import '../models/attendance_models.dart';
import '../models/campus_models.dart';
import '../models/course_section.dart';

const studentFirstName = 'Tugin';
const studentFullName = 'Tugin Buğra Bilgiç';
const studentName = studentFullName;
const studentNumber = '202612345';
const studentFaculty = 'Mühendislik Fakültesi';
const studentDepartment = 'Bilgisayar Mühendisliği';
const studentClass = '4. Sınıf';

const mockStudentProfile = StudentProfile(
  firstName: studentFirstName,
  fullName: studentFullName,
  number: studentNumber,
  faculty: studentFaculty,
  department: studentDepartment,
  classLabel: studentClass,
  email: 'tugin.bilgic@ogrenci.ohu.edu.tr',
  phone: '+90 555 123 45 67',
  address: 'Niğde Merkez, Aşağı Kayabaşı Mahallesi',
);

final mockSections = <CourseSection>[
  const CourseSection(
    id: 'alg-a',
    courseId: 'alg',
    code: 'BM401',
    name: 'Veri Yapıları ve Algoritmalar',
    instructor: 'Prof. Dr. Ahmet Şahin',
    branch: 'A',
    day: 1,
    start: Duration(hours: 10),
    end: Duration(hours: 11, minutes: 30),
    room: 'A102 Dersliği',
  ),
  const CourseSection(
    id: 'alg-b',
    courseId: 'alg',
    code: 'BM401',
    name: 'Veri Yapıları ve Algoritmalar',
    instructor: 'Prof. Dr. Ahmet Şahin',
    branch: 'B',
    day: 2,
    start: Duration(hours: 14),
    end: Duration(hours: 15, minutes: 30),
    room: 'B204',
  ),
  const CourseSection(
    id: 'db-a',
    courseId: 'db',
    code: 'BM405',
    name: 'Veritabanı Sistemleri',
    instructor: 'Doç. Dr. Elif Demir',
    branch: 'A',
    day: 1,
    start: Duration(hours: 12),
    end: Duration(hours: 13, minutes: 30),
    room: 'Lab 2',
  ),
  const CourseSection(
    id: 'db-b',
    courseId: 'db',
    code: 'BM405',
    name: 'Veritabanı Sistemleri',
    instructor: 'Doç. Dr. Elif Demir',
    branch: 'B',
    day: 3,
    start: Duration(hours: 9),
    end: Duration(hours: 10, minutes: 30),
    room: 'Lab 1',
  ),
  const CourseSection(
    id: 'ai-a',
    courseId: 'ai',
    code: 'BM421',
    name: 'Yapay Zekaya Giriş',
    instructor: 'Dr. Öğr. Üyesi Deniz Arı',
    branch: 'A',
    day: 4,
    start: Duration(hours: 9),
    end: Duration(hours: 10, minutes: 45),
    room: 'C301',
  ),
  const CourseSection(
    id: 'ai-b',
    courseId: 'ai',
    code: 'BM421',
    name: 'Yapay Zekaya Giriş',
    instructor: 'Dr. Öğr. Üyesi Deniz Arı',
    branch: 'B',
    day: 2,
    start: Duration(hours: 10),
    end: Duration(hours: 11, minutes: 45),
    room: 'C301',
  ),
  const CourseSection(
    id: 'math-a',
    courseId: 'math',
    code: 'MAT302',
    name: 'Lineer Cebir',
    instructor: 'Prof. Dr. Zeynep Kaya',
    branch: 'A',
    day: 3,
    start: Duration(hours: 13),
    end: Duration(hours: 14, minutes: 30),
    room: 'B301',
  ),
  const CourseSection(
    id: 'math-b',
    courseId: 'math',
    code: 'MAT302',
    name: 'Lineer Cebir',
    instructor: 'Prof. Dr. Zeynep Kaya',
    branch: 'B',
    day: 5,
    start: Duration(hours: 11),
    end: Duration(hours: 12, minutes: 30),
    room: 'B301',
  ),
  const CourseSection(
    id: 'mobile-a',
    courseId: 'mobile',
    code: 'BM430',
    name: 'Mobil Uygulama Geliştirme',
    instructor: 'Öğr. Gör. Mehmet Kaya',
    branch: 'A',
    day: 4,
    start: Duration(hours: 14),
    end: Duration(hours: 16),
    room: 'Lab 3',
  ),
  const CourseSection(
    id: 'mobile-b',
    courseId: 'mobile',
    code: 'BM430',
    name: 'Mobil Uygulama Geliştirme',
    instructor: 'Öğr. Gör. Mehmet Kaya',
    branch: 'B',
    day: 5,
    start: Duration(hours: 9),
    end: Duration(hours: 11),
    room: 'Lab 4',
  ),
];

final mockAttendance = <AttendanceCourse>[
  const AttendanceCourse(
    code: 'BM401',
    name: 'Veri Yapıları ve Algoritmalar',
    limit: 4,
    personalAbsences: 1,
    officialAbsences: 1,
    usedRight: 1,
    remainingRight: 3,
    differences: [],
  ),
  const AttendanceCourse(
    code: 'BM405',
    name: 'Veritabanı Sistemleri',
    limit: 4,
    personalAbsences: 2,
    officialAbsences: 1,
    usedRight: 1,
    remainingRight: 3,
    differences: [
      '12 Mart kişisel kayıt: Katılmadım',
      '12 Mart resmi kayıt: Katıldım',
    ],
  ),
  const AttendanceCourse(
    code: 'BM421',
    name: 'Yapay Zekaya Giriş',
    limit: 3,
    personalAbsences: 0,
    officialAbsences: null,
    usedRight: 0,
    remainingRight: 3,
    differences: [],
    officialEntered: false,
  ),
];

const mockEvents = <CampusEvent>[
  CampusEvent(
    id: 'flutter-campus',
    title: 'Flutter ile Kampüs Uygulamaları',
    date: '18 Mayıs',
    time: '14:00',
    location: 'Kongre Merkezi',
    category: 'Teknoloji',
  ),
  CampusEvent(
    id: 'career-meetup',
    title: 'Kariyer ve Staj Buluşması',
    date: '21 Mayıs',
    time: '10:30',
    location: 'Merkez Yerleşke Fuaye',
    category: 'Kariyer',
  ),
  CampusEvent(
    id: 'photo-walk',
    title: 'Bahar Fotoğraf Yürüyüşü',
    date: '25 Mayıs',
    time: '16:00',
    location: 'Kampüs Ana Giriş',
    category: 'Kültür',
  ),
];

final mockCommunities = <Community>[
  Community(
    id: 'software-ai',
    name: 'Yazılım ve Yapay Zeka Topluluğu',
    category: 'Teknoloji',
    members: 348,
    description:
        'Atölyeler, proje günleri ve açık kaynak buluşmaları düzenler.',
    nextEvent: mockEvents.first,
  ),
  Community(
    id: 'entrepreneurship',
    name: 'Girişimcilik Kulübü',
    category: 'Kariyer',
    members: 214,
    description: 'Fikirden ürüne giden yol için mentorluk ve sunum günleri.',
    nextEvent: mockEvents[1],
  ),
  Community(
    id: 'photography',
    name: 'Fotoğraf Topluluğu',
    category: 'Kültür',
    members: 172,
    description: 'Kampüs yürüyüşleri, sergiler ve temel fotoğraf eğitimleri.',
    nextEvent: mockEvents[2],
  ),
];

const mockGrades = <GradeRecord>[
  GradeRecord(
    courseCode: 'BM401',
    courseName: 'Veri Yapıları ve Algoritmalar',
    midterm: 84,
    finalExam: 91,
    makeup: null,
    letter: 'AA',
    status: 'Açıklandı',
  ),
  GradeRecord(
    courseCode: 'BM405',
    courseName: 'Veritabanı Sistemleri',
    midterm: 76,
    finalExam: 82,
    makeup: null,
    letter: 'BA',
    status: 'Açıklandı',
  ),
  GradeRecord(
    courseCode: 'BM421',
    courseName: 'Yapay Zekaya Giriş',
    midterm: 88,
    finalExam: null,
    makeup: null,
    letter: null,
    status: 'Final notu bekleniyor',
  ),
  GradeRecord(
    courseCode: 'MAT302',
    courseName: 'Lineer Cebir',
    midterm: 69,
    finalExam: 74,
    makeup: null,
    letter: 'BB',
    status: 'Açıklandı',
  ),
];

const mockExams = <ExamRecord>[
  ExamRecord(
    id: 'exam-math-midterm',
    courseName: 'Lineer Cebir',
    type: 'Vize',
    date: '14 Mayıs 2026',
    time: '13:30',
    building: 'Mühendislik Fakültesi',
    room: 'B301',
    past: false,
  ),
  ExamRecord(
    id: 'exam-ai-final',
    courseName: 'Yapay Zekaya Giriş',
    type: 'Final',
    date: '2 Haziran 2026',
    time: '10:00',
    building: 'Merkezi Derslik',
    room: 'C301',
    past: false,
  ),
  ExamRecord(
    id: 'exam-db-midterm',
    courseName: 'Veritabanı Sistemleri',
    type: 'Vize',
    date: '16 Nisan 2026',
    time: '09:30',
    building: 'Bilgisayar Laboratuvarı',
    room: 'Lab 2',
    past: true,
  ),
];

const mockDocuments = <AcademicDocument>[
  AcademicDocument(
    id: 'student-certificate',
    title: 'Öğrenci Belgesi',
    updatedAt: '5 Ağustos 2026',
    status: 'E-imzalı',
  ),
  AcademicDocument(
    id: 'transcript',
    title: 'Transkript',
    updatedAt: '4 Ağustos 2026',
    status: 'Güncel',
  ),
  AcademicDocument(
    id: 'course-registration',
    title: 'Ders Kayıt Belgesi',
    updatedAt: '12 Şubat 2026',
    status: 'Onaylı',
  ),
];

const mockAcademicCalendar = <AcademicCalendarEntry>[
  AcademicCalendarEntry(
    date: '9-13 Eylül',
    title: 'Ders kayıt haftası',
    description: 'Danışman onayları aynı hafta içinde tamamlanır.',
  ),
  AcademicCalendarEntry(
    date: '23 Eylül',
    title: 'Güz dönemi ders başlangıcı',
    description: 'Haftalık ders programı ilk gün güncellenir.',
  ),
  AcademicCalendarEntry(
    date: '6-17 Ocak',
    title: 'Final sınavları',
    description: 'Sınav salonları akademik modülde yayınlanır.',
  ),
];

const mockAdvisor = AdvisorInfo(
  name: 'Prof. Dr. Mehmet Kaya',
  title: 'Bilgisayar Mühendisliği Bölümü',
  email: 'mehmet.kaya@ohu.edu.tr',
  office: 'Mühendislik Fakültesi B Blok 214',
  hours: 'Salı 13:30-15:30, Perşembe 10:00-12:00',
);

const mockDiningWeek = <DiningMenu>[
  DiningMenu(
    day: 'Pazartesi',
    date: '5 Ağustos',
    items: ['Mercimek çorbası', 'Tavuk kavurma', 'Pirinç pilavı', 'Cacık'],
    calories: 890,
    allergens: ['Süt', 'Gluten'],
    vegetarian: false,
    hours: '11:30-14:00 / 17:00-19:00',
  ),
  DiningMenu(
    day: 'Salı',
    date: '6 Ağustos',
    items: ['Ezogelin çorbası', 'Sebzeli türlü', 'Bulgur pilavı', 'Ayran'],
    calories: 760,
    allergens: ['Süt'],
    vegetarian: true,
    hours: '11:30-14:00 / 17:00-19:00',
  ),
  DiningMenu(
    day: 'Çarşamba',
    date: '7 Ağustos',
    items: ['Yayla çorbası', 'Etli nohut', 'Makarna', 'Komposto'],
    calories: 930,
    allergens: ['Süt', 'Gluten'],
    vegetarian: false,
    hours: '11:30-14:00 / 17:00-19:00',
  ),
];

const mockLibraryBooks = <LibraryBook>[
  LibraryBook(
    id: 'clean-code',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    location: 'Merkez Kütüphane 005.1/MAR',
    available: true,
    summary: 'Bakımı kolay yazılım geliştirme prensipleri.',
  ),
  LibraryBook(
    id: 'database-systems',
    title: 'Database System Concepts',
    author: 'Silberschatz, Korth, Sudarshan',
    location: 'Mühendislik Koleksiyonu 005.74/SIL',
    available: false,
    summary: 'İlişkisel veritabanı, sorgu işleme ve transaction konuları.',
  ),
  LibraryBook(
    id: 'flutter-action',
    title: 'Flutter in Action',
    author: 'Eric Windmill',
    location: 'E-kitap koleksiyonu',
    available: true,
    summary: 'Flutter ile modern mobil arayüz geliştirme.',
  ),
];

const mockBorrowedBooks = <BorrowedBook>[
  BorrowedBook(
    title: 'Introduction to Algorithms',
    dueDate: '12 Ağustos 2026',
    remainingDays: 7,
  ),
  BorrowedBook(
    title: 'Modern Operating Systems',
    dueDate: '19 Ağustos 2026',
    remainingDays: 14,
  ),
];

const mockTransportLines = <TransportLine>[
  TransportLine(
    id: 'line-campus-center',
    name: 'Merkez - Kampüs',
    stops: ['Merkez', 'Bor Yolu', 'Mühendislik', 'Kongre Merkezi'],
    times: ['08:00', '08:30', '09:00', '09:30', '10:00'],
    duration: '22 dk',
  ),
  TransportLine(
    id: 'line-station-campus',
    name: 'Otogar - Kampüs',
    stops: ['Otogar', 'Yeni Terminal', 'Rektörlük', 'Merkez Kütüphane'],
    times: ['08:15', '08:45', '09:15', '09:45'],
    duration: '28 dk',
  ),
];

const mockCareerJobs = <CareerJob>[
  CareerJob(
    id: 'job-mobile-intern',
    title: 'Mobil Uygulama Stajyeri',
    company: 'Kapadokya Teknoloji',
    type: 'Staj',
    location: 'Niğde / Hibrit',
    deadline: '22 Ağustos 2026',
    description: 'Flutter bilen, ürün geliştirme sürecine katılacak stajyer.',
  ),
  CareerJob(
    id: 'job-data-analyst',
    title: 'Veri Analisti Adayı',
    company: 'Anadolu Veri',
    type: 'Yarı zamanlı',
    location: 'Uzaktan',
    deadline: '30 Ağustos 2026',
    description: 'SQL ve raporlama araçlarıyla çalışacak öğrenci asistanı.',
  ),
];

const mockLostFoundItems = <LostFoundItem>[
  LostFoundItem(
    id: 'lost-wallet',
    title: 'Siyah cüzdan',
    type: 'Bulunan',
    location: 'Merkez Kütüphane danışma',
    date: '5 Ağustos 2026',
    description: 'İçinde öğrenci kartı bulunan siyah cüzdan teslim edildi.',
  ),
  LostFoundItem(
    id: 'lost-headphone',
    title: 'Kablosuz kulaklık',
    type: 'Kayıp',
    location: 'Mühendislik kantini',
    date: '4 Ağustos 2026',
    description: 'Beyaz renkli kutusuyla birlikte kayboldu.',
  ),
];

const mockFavorites = <FavoriteItem>[
  FavoriteItem(
    title: 'Program 1',
    subtitle: 'Pazartesi ve Çarşamba ağırlıklı ders programı',
    category: 'Akademik',
  ),
  FavoriteItem(
    title: 'Flutter ile Kampüs Uygulamaları',
    subtitle: '18 Mayıs, Kongre Merkezi',
    category: 'Etkinlik',
  ),
  FavoriteItem(
    title: 'Merkez - Kampüs',
    subtitle: 'Favori ulaşım hattı',
    category: 'Kampüs',
  ),
];

const mockNotificationPreferences = <NotificationPreference>[
  NotificationPreference(
    id: 'courses',
    title: 'Ders hatırlatmaları',
    subtitle: 'Ders başlamadan 15 dakika önce bildir',
    enabled: true,
  ),
  NotificationPreference(
    id: 'exams',
    title: 'Sınav bildirimleri',
    subtitle: 'Sınav tarihi ve salon değişiklikleri',
    enabled: true,
  ),
  NotificationPreference(
    id: 'events',
    title: 'Etkinlikler',
    subtitle: 'Takip ettiğin toplulukların etkinlikleri',
    enabled: true,
  ),
  NotificationPreference(
    id: 'announcements',
    title: 'Duyurular',
    subtitle: 'Üniversite ve fakülte duyuruları',
    enabled: false,
  ),
];
