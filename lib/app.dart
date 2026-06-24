import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/enums/theme_mode_preference.dart';
import 'core/theme/app_theme.dart';
import 'di/injection.dart';

/// Root application widget.
class AmharicQurApp extends ConsumerWidget {
  const AmharicQurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

    final themeMode = settingsAsync.maybeWhen(
      data: (settings) => switch (settings.themeMode) {
        ThemeModePreference.system => ThemeMode.system,
        ThemeModePreference.light => ThemeMode.light,
        ThemeModePreference.dark => ThemeMode.dark,
      },
      orElse: () => ThemeMode.system,
    );

    return MaterialApp.router(
      title: 'Amharic Qur',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('am'),
      ],
    );
  }
}
