import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/campus_models.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref
        .read(mockRepositoryProvider)
        .getCourseSectionById(courseId);
    if (course == null) {
      return const _NotFoundScreen(
        title: 'Ders bulunamadı',
        icon: Icons.menu_book_outlined,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(course.code)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              color: AppColors.indigo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${course.instructor} · Şube ${course.branch}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.today_outlined,
                    title: 'Gün ve saat',
                    subtitle: '${course.dayName} · ${course.timeLabel}',
                  ),
                  _InfoTile(
                    icon: Icons.meeting_room_outlined,
                    title: 'Derslik',
                    subtitle: course.room,
                  ),
                  const _InfoTile(
                    icon: Icons.check_circle_outline,
                    title: 'Devam durumu',
                    subtitle: '1 devamsızlık, 3 hak kaldı',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Ders içeriği',
              children: const [
                Text('Hafta 1-3: Algoritma analizi ve karmaşıklık'),
                Text('Hafta 4-7: Listeler, ağaçlar ve grafikler'),
                Text('Hafta 8-14: Sıralama, arama ve uygulama projesi'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.goNamed('scheduleBuilder'),
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Program oluştur'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _showSnack(
                      context,
                      '${course.instructor} için mesaj taslağı hazırlandı.',
                    ),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Danışmana sor'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GradesScreen extends ConsumerStatefulWidget {
  const GradesScreen({super.key});

  @override
  ConsumerState<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends ConsumerState<GradesScreen> {
  var _term = '2024-2025 Bahar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notlarım')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<GradeRecord>>(
          future: ref.read(mockRepositoryProvider).getGrades(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final grades = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _term,
                  decoration: const InputDecoration(
                    labelText: 'Dönem',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '2024-2025 Bahar',
                      child: Text('2024-2025 Bahar'),
                    ),
                    DropdownMenuItem(
                      value: '2024-2025 Güz',
                      child: Text('2024-2025 Güz'),
                    ),
                  ],
                  onChanged: (value) => setState(() {
                    _term = value ?? _term;
                  }),
                ),
                const SizedBox(height: 12),
                AppCard(
                  color: AppColors.indigo,
                  child: Row(
                    children: const [
                      Expanded(
                        child: _SummaryMetric(
                          value: '3.42',
                          label: 'Dönem ortalaması',
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(value: '3.24', label: 'GNO'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                for (final grade in grades) ...[
                  _GradeCard(grade: grade),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  var _showPast = false;
  final _reminders = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sınavlar')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<ExamRecord>>(
          future: ref.read(mockRepositoryProvider).getExams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final exams = (snapshot.data ?? [])
                .where((item) => item.past == _showPast)
                .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      label: Text('Yaklaşan'),
                      icon: Icon(Icons.upcoming_outlined),
                    ),
                    ButtonSegment(
                      value: true,
                      label: Text('Geçmiş'),
                      icon: Icon(Icons.history_outlined),
                    ),
                  ],
                  selected: {_showPast},
                  onSelectionChanged: (value) =>
                      setState(() => _showPast = value.first),
                ),
                const SizedBox(height: 12),
                for (final exam in exams) ...[
                  _ExamCard(
                    exam: exam,
                    reminder: _reminders.contains(exam.id),
                    onReminderChanged: (value) {
                      setState(() {
                        value
                            ? _reminders.add(exam.id)
                            : _reminders.remove(exam.id);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class AcademicCalendarScreen extends ConsumerWidget {
  const AcademicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akademik Takvim')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<AcademicCalendarEntry>>(
          future: ref.read(mockRepositoryProvider).getAcademicCalendar(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final entries = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final entry in entries) ...[
                  AppCard(
                    child: _InfoTile(
                      icon: Icons.event_outlined,
                      title: entry.title,
                      subtitle: '${entry.date} · ${entry.description}',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  AcademicDocument? _preview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Belgelerim')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<AcademicDocument>>(
          future: ref.read(mockRepositoryProvider).getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final documents = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (_preview != null) ...[
                  AppCard(
                    color: AppColors.indigo.withValues(alpha: 0.10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Belge önizlemesi',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('${_preview!.title} · ${_preview!.status}'),
                        Text('Güncelleme: ${_preview!.updatedAt}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                for (final document in documents) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoTile(
                          icon: Icons.description_outlined,
                          title: document.title,
                          subtitle:
                              '${document.status} · ${document.updatedAt}',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    setState(() => _preview = document),
                                icon: const Icon(Icons.visibility_outlined),
                                label: const Text('Önizle'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: () => _showSnack(
                                  context,
                                  '${document.title} indirme için hazırlandı.',
                                ),
                                icon: const Icon(Icons.download_outlined),
                                label: const Text('İndir'),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Paylaş',
                              onPressed: () => _showSnack(
                                context,
                                '${document.title} paylaşım bağlantısı hazır.',
                              ),
                              icon: const Icon(Icons.ios_share_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class AdvisorScreen extends ConsumerStatefulWidget {
  const AdvisorScreen({super.key});

  @override
  ConsumerState<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends ConsumerState<AdvisorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  var _slot = 'Salı 13:30';
  var _sent = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final advisor = ref.read(mockRepositoryProvider).getAdvisor();
    return Scaffold(
      appBar: AppBar(title: const Text('Danışmanım')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.indigo,
                    child: Icon(Icons.person, color: Colors.white, size: 42),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advisor.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(advisor.title),
                        Text(advisor.email),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.apartment_outlined,
                    title: 'Ofis',
                    subtitle: advisor.office,
                  ),
                  _InfoTile(
                    icon: Icons.schedule_outlined,
                    title: 'Görüşme saatleri',
                    subtitle: advisor.hours,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Randevu talep formu',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _slot,
                      decoration: const InputDecoration(
                        labelText: 'Uygun saat',
                        prefixIcon: Icon(Icons.event_available_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Salı 13:30',
                          child: Text('Salı 13:30'),
                        ),
                        DropdownMenuItem(
                          value: 'Salı 14:30',
                          child: Text('Salı 14:30'),
                        ),
                        DropdownMenuItem(
                          value: 'Perşembe 10:30',
                          child: Text('Perşembe 10:30'),
                        ),
                      ],
                      onChanged: (value) => _slot = value ?? _slot,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _message,
                      minLines: 3,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Görüşme konusu',
                        prefixIcon: Icon(Icons.edit_note_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Kısa bir görüşme konusu yaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        setState(() => _sent = true);
                      },
                      icon: const Icon(Icons.send_outlined),
                      label: const Text('Randevu talep et'),
                    ),
                    if (_sent) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Randevu talebin danışmanına iletildi. Yanıt geldiğinde bildirim alacaksın.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.grade});

  final GradeRecord grade;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${grade.courseCode} · ${grade.courseName}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Metric(label: 'Vize', value: _score(grade.midterm)),
              _Metric(label: 'Final', value: _score(grade.finalExam)),
              _Metric(label: 'Bütünleme', value: _score(grade.makeup)),
              _Metric(label: 'Harf', value: grade.letter ?? 'Bekleniyor'),
            ],
          ),
          const SizedBox(height: 10),
          Text(grade.status),
        ],
      ),
    );
  }

  String _score(int? value) => value == null ? 'Açıklanmadı' : '$value';
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({
    required this.exam,
    required this.reminder,
    required this.onReminderChanged,
  });

  final ExamRecord exam;
  final bool reminder;
  final ValueChanged<bool> onReminderChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoTile(
            icon: Icons.error_outline,
            title: '${exam.courseName} · ${exam.type}',
            subtitle:
                '${exam.date} · ${exam.time} · ${exam.building} ${exam.room}',
          ),
          SwitchListTile(
            value: reminder,
            onChanged: onReminderChanged,
            title: const Text('Hatırlatıcı'),
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          FilledButton.tonalIcon(
            onPressed: () => _showSnack(
              context,
              '${exam.courseName} sınavı takvimine eklendi.',
            ),
            icon: const Icon(Icons.event_available_outlined),
            label: const Text('Takvime ekle'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(icon: icon, color: AppColors.indigo, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(subtitle),
              ],
            ),
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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: EmptyState(
          icon: icon,
          title: title,
          message: 'Seçilen kayıt bulunamadı.',
        ),
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
