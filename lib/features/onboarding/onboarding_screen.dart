import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_design.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  Future<void> _redirect() async {
    final preferences = ref.read(sharedPreferencesProvider);
    final onboardingDone = preferences.getBool('onboardingDone') ?? false;
    final remembered = preferences.getBool('rememberedLogin') ?? false;
    await Future<void>.delayed(const Duration(milliseconds: 520));
    if (!mounted) return;
    context.go(
      onboardingDone ? (remembered ? '/home' : '/login') : '/onboarding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NohuLogoMark(width: 218, height: 104, showBorder: false),
              const SizedBox(height: AppSpacing.s24),
              Text(
                'NOHÜ Kampüs',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Öğrenci yaşamın tek yerde',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.s24),
              SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  var _index = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.school_outlined,
      title: 'Akademik hayatın burada',
      text: 'Derslerin, sınavların ve notların tek yerde.',
      color: AppColors.indigo,
    ),
    _OnboardingPage(
      icon: Icons.explore_outlined,
      title: 'Kampüsü keşfet',
      text: 'Etkinliklerden yemek menüsüne ihtiyacın olan her şey.',
      color: AppColors.green,
    ),
    _OnboardingPage(
      icon: Icons.calendar_month_outlined,
      title: 'Programını kendin oluştur',
      text: 'Derslerini seç, sana uygun programları bul.',
      color: AppColors.lavender,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(sharedPreferencesProvider).setBool('onboardingDone', true);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.s12,
            AppSpacing.page,
            AppSpacing.s20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const NohuLogoMark(width: 82, height: 42, showBorder: false),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: const Text('Geç')),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) => _pages[index],
                ),
              ),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: _index == index ? 26 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: AppSpacing.s8),
                        decoration: BoxDecoration(
                          color: _index == index
                              ? colors.primary
                              : colors.primary.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: isLast
                        ? _finish
                        : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOut,
                          ),
                    icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
                    label: Text(isLast ? 'Başlayalım' : 'İleri'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 164,
          height: 164,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.hero),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Center(
            child: EducationIllustration(size: 128, color: color, icon: icon),
          ),
        ),
        const SizedBox(height: AppSpacing.s32),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
