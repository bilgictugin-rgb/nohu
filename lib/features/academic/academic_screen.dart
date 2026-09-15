import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_design.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      const _AcademicOption(
        'Ders Programım',
        'Haftalık takvim ve derslik bilgileri',
        AppIcons.schedule,
        AppColors.petrol,
        '/academic/schedule',
      ),
      const _AcademicOption(
        'Notlarım',
        'Dönem ortalaması, GNO ve açıklanmayan notlar',
        AppIcons.grades,
        AppColors.petrol,
        '/academic/grades',
      ),
      const _AcademicOption(
        'Sınavlar',
        'Tarih, saat, bina ve salon bilgisi',
        AppIcons.clock,
        AppColors.petrol,
        '/academic/exams',
      ),
      const _AcademicOption(
        'Devamsızlık Takibim',
        'Kişisel takip ve resmi kayıt karşılaştırması',
        AppIcons.attendance,
        AppColors.petrol,
        '/academic/attendance',
      ),
      const _AcademicOption(
        'Akademik Takvim',
        'Kayıt, ders ve sınav tarihleri',
        AppIcons.schedule,
        AppColors.petrol,
        '/academic/calendar',
      ),
      const _AcademicOption(
        'Belgelerim',
        'Öğrenci belgesi, transkript ve ders kaydı',
        AppIcons.documents,
        AppColors.petrol,
        '/academic/documents',
      ),
      const _AcademicOption(
        'Danışmanım',
        'Prof. Dr. Mehmet Kaya ile iletişim',
        AppIcons.advisor,
        AppColors.petrol,
        '/academic/advisor',
      ),
    ];

    return AppScaffold(
      body: ListView(
        children: [
          const AppHeader(
            meta: '2024-2025 Bahar Dönemi',
            title: 'Akademik',
            subtitle: 'Derslerini, notlarını ve resmi işlemlerini takip et.',
            compact: true,
          ),
          const HeroCard(
            meta: '2024-2025 Bahar',
            title: 'Akademik durum',
            subtitle:
                'Derslerini, notlarını ve resmi belgelerini tek akışta takip et.',
            icon: AppIcons.academic,
            color: AppColors.indigo,
            accent: AppColors.teal,
          ),
          const SizedBox(height: AppSpacing.s16),
          const Row(
            children: [
              Expanded(
                child: AcademicSummaryCard(
                  label: 'GNO',
                  value: '3.24',
                  color: AppColors.petrol,
                ),
              ),
              SizedBox(width: AppSpacing.s12),
              Expanded(
                child: AcademicSummaryCard(
                  label: 'Kredi',
                  value: '120',
                  color: AppColors.indigo,
                ),
              ),
              SizedBox(width: AppSpacing.s12),
              Expanded(
                child: AcademicSummaryCard(
                  label: 'Dönem',
                  value: '+0.18',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          FilledButton.icon(
            onPressed: () => context.go('/academic/schedule-builder'),
            icon: const AppIcon(AppIcons.schedule),
            label: const Text('Yeni Program Oluştur'),
          ),
          const AppSectionTitle(title: 'Akademik işlemler'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.s12,
              mainAxisSpacing: AppSpacing.s12,
              childAspectRatio: 1.04,
            ),
            itemBuilder: (context, index) {
              final option = options[index];
              return FeatureCard(
                title: option.title,
                subtitle: option.subtitle,
                icon: option.icon,
                color: option.color,
                height: index == 0 ? 156 : null,
                onTap: () => context.go(option.route),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AcademicOption {
  const _AcademicOption(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.route,
  );

  final String title;
  final String subtitle;
  final Object icon;
  final Color color;
  final String route;
}
