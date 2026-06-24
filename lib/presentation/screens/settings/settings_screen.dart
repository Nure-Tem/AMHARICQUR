import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/theme_mode_preference.dart';
import '../../../di/injection.dart';
import '../../../domain/entities/app_settings.dart';

/// Settings screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            const _SectionHeader('Appearance'),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme Mode'),
              subtitle: Text(_themeModeName(settings.themeMode)),
              onTap: () => _showThemeModeDialog(context, ref, settings),
            ),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font Scale'),
              subtitle: Slider(
                value: settings.readerFontScale,
                min: 0.8,
                max: 1.5,
                divisions: 14,
                label: settings.readerFontScale.toStringAsFixed(1),
                onChanged: (value) {
                  ref.read(appSettingsProvider.notifier).updateSettings(
                        settings.copyWith(readerFontScale: value),
                      );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.format_line_spacing),
              title: const Text('Line Height'),
              subtitle: Slider(
                value: settings.readerLineHeight,
                min: 1.2,
                max: 2.0,
                divisions: 16,
                label: settings.readerLineHeight.toStringAsFixed(1),
                onChanged: (value) {
                  ref.read(appSettingsProvider.notifier).updateSettings(
                        settings.copyWith(readerLineHeight: value),
                      );
                },
              ),
            ),
            const _SectionHeader('Reading'),
            SwitchListTile(
              secondary: const Icon(Icons.screen_lock_portrait),
              title: const Text('Keep Screen On'),
              subtitle: const Text('Prevent screen dimming while reading'),
              value: settings.keepScreenOn,
              onChanged: (value) {
                ref.read(appSettingsProvider.notifier).updateSettings(
                      settings.copyWith(keepScreenOn: value),
                    );
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  String _themeModeName(ThemeModePreference mode) {
    switch (mode) {
      case ThemeModePreference.system:
        return 'System Default';
      case ThemeModePreference.light:
        return 'Light';
      case ThemeModePreference.dark:
        return 'Dark';
    }
  }

  void _showThemeModeDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeModePreference.values.map((mode) {
            return ListTile(
              title: Text(_themeModeName(mode)),
              leading: Radio<ThemeModePreference>(
                value: mode,
                groupValue: settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appSettingsProvider.notifier).updateSettings(
                          settings.copyWith(themeMode: value),
                        );
                    Navigator.pop(context);
                  }
                },
              ),
              onTap: () {
                ref.read(appSettingsProvider.notifier).updateSettings(
                      settings.copyWith(themeMode: mode),
                    );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
