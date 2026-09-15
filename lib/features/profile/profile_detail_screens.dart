import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_icon_badge.dart';
import '../../core/widgets/app_states.dart';
import '../../data/models/campus_models.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone;
  late final TextEditingController _address;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(mockRepositoryProvider).getStudentProfile();
    _phone = TextEditingController(text: profile.phone);
    _address = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.read(mockRepositoryProvider).getStudentProfile();
    return Scaffold(
      appBar: AppBar(title: const Text('Profili Düzenle')),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              AppCard(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.indigo,
                      child: Icon(Icons.person, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(profile.number),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) => value == null || value.trim().length < 10
                    ? 'Geçerli telefon gir'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _address,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Adres gir' : null,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  _showSnack(context, 'Profil bilgilerin kaydedildi.');
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInfoScreen extends ConsumerWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(mockRepositoryProvider).getStudentProfile();
    return Scaffold(
      appBar: AppBar(title: const Text('Kişisel Bilgilerim')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.person_outline,
                    title: 'Ad Soyad',
                    subtitle: profile.name,
                  ),
                  _InfoTile(
                    icon: Icons.badge_outlined,
                    title: 'Öğrenci numarası',
                    subtitle: profile.number,
                  ),
                  _InfoTile(
                    icon: Icons.school_outlined,
                    title: 'Fakülte ve bölüm',
                    subtitle: '${profile.faculty} · ${profile.department}',
                  ),
                  _InfoTile(
                    icon: Icons.mail_outline,
                    title: 'E-posta',
                    subtitle: profile.email,
                  ),
                  _InfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Telefon',
                    subtitle: profile.phone,
                  ),
                  _InfoTile(
                    icon: Icons.home_outlined,
                    title: 'Adres',
                    subtitle: profile.address,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorilerim'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Akademik'),
              Tab(text: 'Etkinlik'),
              Tab(text: 'Kampüs'),
            ],
          ),
        ),
        body: SafeArea(
          top: false,
          child: FutureBuilder<List<FavoriteItem>>(
            future: ref.read(mockRepositoryProvider).getFavorites(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingState();
              }
              final favorites = snapshot.data ?? [];
              return TabBarView(
                children: [
                  _FavoriteList(
                    items: favorites
                        .where((item) => item.category == 'Akademik')
                        .toList(),
                  ),
                  _FavoriteList(
                    items: favorites
                        .where((item) => item.category == 'Etkinlik')
                        .toList(),
                  ),
                  _FavoriteList(
                    items: favorites
                        .where((item) => item.category == 'Kampüs')
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Bildirim Ayarları')),
      body: SafeArea(
        top: false,
        child: FutureBuilder<List<NotificationPreference>>(
          future: ref.read(mockRepositoryProvider).getNotificationPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingState();
            }
            final preferences = snapshot.data ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                for (final item in preferences) ...[
                  AppCard(
                    child: SwitchListTile(
                      value: settings[item.id] ?? item.enabled,
                      onChanged: (value) => ref
                          .read(notificationSettingsProvider.notifier)
                          .setEnabled(item.id, value),
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                      secondary: const Icon(
                        Icons.notifications_active_outlined,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                FilledButton.icon(
                  onPressed: () =>
                      _showSnack(context, 'Bildirim ayarların kaydedildi.'),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Kaydet'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tema')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                children: [
                  _ThemeModeTile(
                    value: ThemeMode.system,
                    selected: mode,
                    onSelected: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value),
                    title: const Text('Sistem'),
                    icon: Icons.settings_suggest_outlined,
                  ),
                  _ThemeModeTile(
                    value: ThemeMode.light,
                    selected: mode,
                    onSelected: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value),
                    title: const Text('Açık'),
                    icon: Icons.light_mode_outlined,
                  ),
                  _ThemeModeTile(
                    value: ThemeMode.dark,
                    selected: mode,
                    onSelected: (value) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value),
                    title: const Text('Koyu'),
                    icon: Icons.dark_mode_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  var _language = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dil')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                children: [
                  _LanguageChoiceTile(
                    value: 'Türkçe',
                    selected: _language,
                    onSelected: (value) => setState(() => _language = value),
                    title: const Text('Türkçe'),
                  ),
                  _LanguageChoiceTile(
                    value: 'English',
                    selected: _language,
                    onSelected: (value) => setState(() => _language = value),
                    title: const Text('English'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _showSnack(
                context,
                'Dil tercihin $_language olarak kaydedildi.',
              ),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  var _fontSize = 1.0;
  var _highContrast = false;
  var _reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erişilebilirlik')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yazı boyutu: ${(_fontSize * 100).round()}%'),
                  Slider(
                    value: _fontSize,
                    min: 0.85,
                    max: 1.25,
                    divisions: 4,
                    onChanged: (value) => setState(() => _fontSize = value),
                  ),
                  SwitchListTile(
                    value: _highContrast,
                    onChanged: (value) => setState(() => _highContrast = value),
                    title: const Text('Yüksek kontrast'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    value: _reduceMotion,
                    onChanged: (value) => setState(() => _reduceMotion = value),
                    title: const Text('Hareketi azalt'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _showSnack(
                context,
                'Erişilebilirlik tercihlerin bu oturum için uygulandı.',
              ),
              icon: const Icon(Icons.check),
              label: const Text('Uygula'),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yardım ve SSS')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const AppCard(
              child: Row(
                children: [
                  AppIconBadge(
                    icon: Icons.school_outlined,
                    color: AppColors.indigo,
                    size: 52,
                  ),
                  SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOHÜ Kampüs',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: AppSpacing.s4),
                        Text('Sürüm 1.0.0 · Öğrenci yaşam prototipi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const AppCard(
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text('Şifremi nasıl değiştiririm?'),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Öğrenci bilgi sistemi üzerinden şifre yenileme adımlarını izleyebilirsin.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () =>
                  _showSnack(context, 'Destek talebi taslağı hazırlandı.'),
              icon: const Icon(Icons.support_agent_outlined),
              label: const Text('Destek talebi oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  var _category = 'Öneri';
  var _sent = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geri Bildirim')),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Öneri', child: Text('Öneri')),
                  DropdownMenuItem(value: 'Hata', child: Text('Hata')),
                  DropdownMenuItem(value: 'Teşekkür', child: Text('Teşekkür')),
                ],
                onChanged: (value) =>
                    setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _message,
                minLines: 5,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: 'Mesajın',
                  prefixIcon: Icon(Icons.edit_note_outlined),
                ),
                validator: (value) => value == null || value.trim().length < 10
                    ? 'En az 10 karakter yaz'
                    : null,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  setState(() => _sent = true);
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Gönder'),
              ),
              if (_sent) ...[
                const SizedBox(height: 12),
                const AppCard(
                  child: Text(
                    'Geri bildirimin alındı. İnceleme sonucu uygulama içinden bildirilecek.',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  var _biometric = true;
  var _activity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik ve Güvenlik')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            AppCard(
              child: Column(
                children: [
                  SwitchListTile(
                    value: _biometric,
                    onChanged: (value) => setState(() => _biometric = value),
                    title: const Text('Biyometrik giriş'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile(
                    value: _activity,
                    onChanged: (value) => setState(() => _activity = value),
                    title: const Text('Etkinlik geçmişimi sakla'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktif oturum',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 8),
                  Text('Windows Chrome · Niğde · Bugün 11:42'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notifications = [
      ('Lineer Cebir sınav salonu açıklandı', 'Bugün 09:12'),
      ('Yemekhane menüsü güncellendi', 'Bugün 08:00'),
      ('Flutter etkinliği için katılım hatırlatıcısı', 'Dün 18:30'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (final item in notifications) ...[
              AppCard(
                child: _InfoTile(
                  icon: Icons.notifications_none_outlined,
                  title: item.$1,
                  subtitle: item.$2,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile({
    required this.value,
    required this.selected,
    required this.onSelected,
    required this.title,
    required this.icon,
  });

  final ThemeMode value;
  final ThemeMode selected;
  final ValueChanged<ThemeMode> onSelected;
  final Widget title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final checked = value == selected;
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(AppRadius.surface),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          children: [
            AppIconBadge(
              icon: icon,
              color: checked ? AppColors.indigo : AppColors.graphite,
              size: 38,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(child: title),
            Icon(
              checked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: checked ? Theme.of(context).colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageChoiceTile extends StatelessWidget {
  const _LanguageChoiceTile({
    required this.value,
    required this.selected,
    required this.onSelected,
    required this.title,
  });

  final String value;
  final String selected;
  final ValueChanged<String> onSelected;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final checked = value == selected;
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(AppRadius.surface),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          children: [
            Expanded(child: title),
            Icon(
              checked
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: checked ? Theme.of(context).colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  const _FavoriteList({required this.items});

  final List<FavoriteItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: 'Favori yok',
        message: 'Bu sekmede kayıtlı favori bulunmuyor.',
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final item in items) ...[
          AppCard(
            child: _InfoTile(
              icon: Icons.favorite,
              title: item.title,
              subtitle: item.subtitle,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
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
      padding: const EdgeInsets.only(bottom: 8),
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

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
