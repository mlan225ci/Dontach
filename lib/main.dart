import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:dontach/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/app_shell.dart';
import 'services/locale_storage.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DontachApp());
}

class DontachApp extends StatefulWidget {
  const DontachApp({super.key});

  @override
  State<DontachApp> createState() => _DontachAppState();
}

class _DontachAppState extends State<DontachApp> {
  final LocaleStorage _localeStorage = LocaleStorage();
  Locale? _locale;

  void _onLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dontach',
      debugShowCheckedModeBanner: false,
      locale: _locale ?? const Locale('en'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: AppShell(
        localeStorage: _localeStorage,
        onLocaleChanged: _onLocaleChanged,
      ),
    );
  }
}
