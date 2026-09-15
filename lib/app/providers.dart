import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock/mock_data.dart';
import '../data/repositories/mock_campus_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden.'),
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final value = ref.read(sharedPreferencesProvider).getString('themeMode');
    return switch (value) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };
    await ref.read(sharedPreferencesProvider).setString('themeMode', value);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

final mockRepositoryProvider = Provider<MockCampusRepository>(
  (ref) => MockCampusRepository(),
);

class NotificationSettingsController extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    final preferences = ref.read(sharedPreferencesProvider);
    return {
      for (final item in mockNotificationPreferences)
        item.id: preferences.getBool('notification_${item.id}') ?? item.enabled,
    };
  }

  Future<void> setEnabled(String id, bool value) async {
    state = {...state, id: value};
    await ref
        .read(sharedPreferencesProvider)
        .setBool('notification_$id', value);
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsController, Map<String, bool>>(
      NotificationSettingsController.new,
    );
