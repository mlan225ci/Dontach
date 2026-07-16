import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dontach/l10n/app_localizations.dart';

import 'package:dontach/main.dart';
import 'package:dontach/screens/setup_pin_screen.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('fr'),
    home: child,
  );
}

void main() {
  testWidgets('Dontach affiche MaterialApp au démarrage', (WidgetTester tester) async {
    await tester.pumpWidget(const DontachApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('SetupPinScreen affiche le clavier PIN', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(SetupPinScreen(onConfigured: () {})),
    );

    expect(find.text('Code Dontach'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });
}
