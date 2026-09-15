import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/attendance_models.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final _personalStatus = <String, PersonalAttendanceStatus>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devamsızlık Takibim')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<AttendanceCourse>>(
          future: ref.read(mockRepositoryProvider).getAttendance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            if (snapshot.hasError) {
              return ErrorState(message: snapshot.error.toString());
            }
            final courses = snapshot.data ?? [];
            if (courses.isEmpty) {
              return const EmptyState(
                icon: Icons.assignment_outlined,
                title: 'Kayıt yok',
                message: 'Bu dönem için devamsızlık kaydı bulunamadı.',
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                AppCard(
                  color: AppColors.coral.withValues(alpha: 0.09),
                  border: BorderSide(
                    color: AppColors.coral.withValues(alpha: 0.35),
                  ),
                  child: const Row(
                    children: [
                      AppIconBadge(
                        icon: Icons.info_outline,
                        color: AppColors.coral,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Kişisel kayıtlar resmi değildir. Akademisyen kaydıyla fark varsa düzeltme talebi oluşturabilirsin.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                for (final course in courses) ...[
                  _AttendanceCourseCard(
                    course: course,
                    selectedStatus:
                        _personalStatus[course.code] ??
                        PersonalAttendanceStatus.attended,
                    onStatusChanged: (status) =>
                        setState(() => _personalStatus[course.code] = status),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceCourseCard extends StatelessWidget {
  const _AttendanceCourseCard({
    required this.course,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final AttendanceCourse course;
  final PersonalAttendanceStatus selectedStatus;
  final ValueChanged<PersonalAttendanceStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final progress = course.limit == 0 ? 0.0 : course.usedRight / course.limit;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIconBadge(
                icon: Icons.assignment_outlined,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(course.code),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RecordBox(
                  label: 'Kişisel kayıt',
                  value: '${course.personalAbsences} devamsızlık',
                  badge: 'Resmi değildir',
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RecordBox(
                  label: 'Resmi kayıt',
                  value: course.officialEntered
                      ? '${course.officialAbsences} devamsızlık'
                      : 'Akademisyen henüz kayıt girmedi',
                  badge: 'Akademisyen',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Kendi kaydını güncelle',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in PersonalAttendanceStatus.values)
                ChoiceChip(
                  selected: selectedStatus == status,
                  label: Text(status.label),
                  onSelected: (_) => onStatusChanged(status),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  backgroundColor: AppColors.coral.withValues(alpha: 0.14),
                  color: progress > 0.7 ? AppColors.coral : AppColors.success,
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              Text('${course.usedRight}/${course.limit} hak'),
            ],
          ),
          const SizedBox(height: 6),
          Text('Kalan hak: ${course.remainingRight}'),
          if (course.hasMismatch) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.coral.withValues(alpha: 0.32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: AppColors.coral,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Uyuşmazlık uyarısı',
                        style: TextStyle(
                          color: AppColors.coral,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final difference in course.differences)
                    Text('• $difference'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showSnack(
                            context,
                            '${course.name} için kayıt tarihleri karşılaştırıldı.',
                          ),
                          icon: const Icon(Icons.compare_outlined),
                          label: const Text('Tarihleri karşılaştır'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _showSnack(
                            context,
                            '${course.name} için düzeltme talebi oluşturuldu.',
                          ),
                          icon: const Icon(Icons.edit_note_outlined),
                          label: const Text('Düzeltme talebi'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _RecordBox extends StatelessWidget {
  const _RecordBox({
    required this.label,
    required this.value,
    required this.badge,
    required this.color,
  });

  final String label;
  final String value;
  final String badge;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(value),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
