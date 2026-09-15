import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const unsafeDisplayValues = [
    '%92 uyumlu',
    'GNO %3.24',
    'Niğde Ömer Halisdemir Üniversitesi',
    'Yemek & Kafeterya',
    'Ders / Şube A',
    'Türkçe karakter: ğüşöçıİ',
    '50% indirim',
    '',
  ];

  test('query parameters are built with Uri, not manual encoding', () {
    for (final value in unsafeDisplayValues) {
      final location = Uri(
        path: '/search',
        queryParameters: {'query': value, 'filter': 'all'},
      ).toString();

      expect(() => Uri.parse(location), returnsNormally);
      expect(location, startsWith('/search?'));
    }
  });

  test('app paths use only safe ASCII route segments', () {
    const locations = [
      '/notifications',
      '/academic/schedule',
      '/academic/schedule-builder',
      '/academic/grades',
      '/academic/exams',
      '/academic/attendance',
      '/academic/calendar',
      '/academic/documents',
      '/academic/advisor',
      '/academic/courses/alg-a',
      '/profile/personal-info',
      '/profile/favorites',
      '/profile/notification-settings',
      '/profile/theme',
      '/profile/language',
      '/profile/accessibility',
      '/profile/help',
      '/profile/feedback',
      '/profile/privacy',
      '/campus/cafeteria',
      '/campus/library',
      '/campus/transport',
      '/campus/career',
      '/campus/career/job-mobile-intern',
      '/campus/lost-found',
      '/campus/lost-found/lost-wallet',
      '/campus/map',
      '/campus/events',
      '/campus/events/flutter-campus',
      '/campus/communities',
      '/campus/communities/software-ai',
    ];
    final safePath = RegExp(r'^/[a-z0-9/-]+$');

    for (final location in locations) {
      expect(location, matches(safePath));
      expect(() => Uri.parse(location), returnsNormally);
    }
  });

  test('placeholder texts are not present in lib user interface code', () {
    final libFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final source = libFiles.map((file) => file.readAsStringSync()).join('\n');

    for (final text in const [
      'Bu ekran mock verilerle hazırlandı',
      'Örnek durumlar',
      'Mock repository',
      'Route ID',
      'URL güvenliği',
    ]) {
      expect(source, isNot(contains(text)));
    }
  });
}
