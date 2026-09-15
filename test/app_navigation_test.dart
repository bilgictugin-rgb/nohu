import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nohu_kampus/app/nohu_app.dart';
import 'package:nohu_kampus/app/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpNohuApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({
    'onboardingDone': true,
    'rememberedLogin': true,
  });
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const NohuApp(),
    ),
  );
  await tester.pump(const Duration(milliseconds: 700));
  await tester.pumpAndSettle();
  if (find.text('Geç').evaluate().isNotEmpty) {
    await tester.tap(find.text('Geç').first);
    await tester.pumpAndSettle();
  }
  if (find.text('Giriş Yap').evaluate().isNotEmpty &&
      find.textContaining('Merhaba').evaluate().isEmpty) {
    await tester.tap(find.text('Giriş Yap').first);
    await tester.pumpAndSettle();
  }
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await reveal(tester, finder);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 30; i++) {
    if (finder.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder.first);
      await tester.pumpAndSettle();
      return;
    }
    await tester.dragFrom(const Offset(400, 420), const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  if (finder.evaluate().isNotEmpty) {
    await tester.ensureVisible(finder.first);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('Ana Sayfa ve Profil Tugin bilgisini gösterir', (tester) async {
    await pumpNohuApp(tester);

    expect(find.textContaining('Tugin'), findsWidgets);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Tugin Buğra Bilgiç'), findsOneWidget);
  });

  testWidgets('Akademik > Notlarım, Sınavlar ve Belgeler', (tester) async {
    await pumpNohuApp(tester);

    await tester.tap(find.text('Akademik').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Notlarım'));
    expect(find.text('Dönem ortalaması'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Sınavlar'));
    expect(find.text('Takvime ekle'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Belgelerim'));
    expect(find.text('Belge önizlemesi'), findsNothing);
    expect(find.text('Önizle'), findsWidgets);
  });

  testWidgets('Kampüs > Yemekhane ve Kütüphane', (tester) async {
    await pumpNohuApp(tester);

    await tester.tap(find.text('Kampüs').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Yemekhane'));
    await reveal(tester, find.text('Öğün değerlendirme: 4/5'));
    expect(find.text('Öğün değerlendirme: 4/5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Kütüphane'));
    expect(find.text('Kitap arama'), findsOneWidget);
    await reveal(tester, find.text('Ödünç aldıklarım'));
    expect(find.text('Ödünç aldıklarım'), findsOneWidget);
  });

  testWidgets('Ana Sayfa hızlı erişim yalnızca beş öğe gösterir', (
    tester,
  ) async {
    await pumpNohuApp(tester);

    expect(find.text('Yemekhane'), findsWidgets);
    expect(find.text('Notlarım'), findsWidgets);
    expect(find.text('Etkinlikler'), findsWidgets);
    expect(find.text('Devamsızlık'), findsWidgets);
    expect(find.text('Ders Programı'), findsWidgets);
  });

  testWidgets('Profil > Tema ve Favoriler', (tester) async {
    await pumpNohuApp(tester);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Tema'));
    expect(find.text('Sistem'), findsOneWidget);
    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Favorilerim'));
    expect(find.text('Akademik'), findsWidgets);
    expect(find.text('Etkinlik'), findsWidgets);
  });

  testWidgets('Çıkış Yap > Giriş', (tester) async {
    await pumpNohuApp(tester);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Çıkış Yap'));
    await tester.tap(find.widgetWithText(FilledButton, 'Çıkış Yap'));
    await tester.pumpAndSettle();

    expect(find.text('Giriş Yap'), findsWidgets);
    expect(find.text('Misafir olarak devam et'), findsOneWidget);
  });
}
