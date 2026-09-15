import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_design.dart';
import '../../data/mock/mock_data.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNumber = TextEditingController(text: studentNumber);
  final _password = TextEditingController(text: 'nohu123');
  var _obscure = true;
  var _remember = true;

  @override
  void dispose() {
    _studentNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setBool('onboardingDone', true);
    await preferences.setBool('rememberedLogin', _remember);
    if (mounted) context.go('/home');
  }

  Future<void> _continueAsGuest() async {
    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setBool('onboardingDone', true);
    await preferences.setBool('rememberedLogin', false);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s24,
                AppSpacing.page,
                AppSpacing.s24,
              ),
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: NohuLogoMark(
                    width: 218,
                    height: 104,
                    showBorder: false,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  'NOHÜ Kampüs',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.s8),
                Text(
                  'Tekrar hoş geldin',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.s6),
                Text(
                  'Ders, kampüs kartı ve günlük öğrenci akışını hesabından takip et.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.s24),
                AppCard(
                  elevated: true,
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.compact,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                color: colors.primary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Oturum aç',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.s4),
                                  Text(
                                    'Öğrenci numaran ve şifrenle devam et.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s20),
                        TextFormField(
                          controller: _studentNumber,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Öğrenci numarası',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Öğrenci numarası zorunludur';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _obscure
                                  ? 'Şifreyi göster'
                                  : 'Şifreyi gizle',
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Şifre zorunludur';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Row(
                          children: [
                            Checkbox(
                              value: _remember,
                              onChanged: (value) =>
                                  setState(() => _remember = value ?? false),
                            ),
                            const Expanded(child: Text('Beni hatırla')),
                            TextButton(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Şifre yenileme bağlantısı öğrenci e-postana gönderildi.',
                                      ),
                                    ),
                                  ),
                              child: const Text('Şifremi unuttum'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        FilledButton.icon(
                          onPressed: _login,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: AppColors.indigo,
                          ),
                          icon: const Icon(Icons.login_outlined),
                          label: const Text('Giriş Yap'),
                        ),
                        const SizedBox(height: AppSpacing.s10),
                        OutlinedButton.icon(
                          onPressed: _continueAsGuest,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Misafir olarak devam et'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: colors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Text(
                          'Öğrenci numaran kayıtlı olarak geldi, istersen değiştirebilirsin.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
