import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_router.dart';

/// Home screen — entry hub for reading features.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HomeTile(
            icon: Icons.play_arrow_rounded,
            title: 'Continue Reading',
            subtitle: 'Resume where you left off',
            onTap: () => context.goToReader(),
          ),
          _HomeTile(
            icon: Icons.list_alt_rounded,
            title: 'Table of Contents',
            onTap: context.goToToc,
          ),
          _HomeTile(
            icon: Icons.search_rounded,
            title: 'Search',
            subtitle: 'Arabic, Amharic, titles',
            onTap: context.goToSearch,
          ),
          _HomeTile(
            icon: Icons.bookmark_rounded,
            title: 'Bookmarks',
            onTap: context.goToBookmarks,
          ),
          _HomeTile(
            icon: Icons.highlight_rounded,
            title: 'Highlights & Notes',
            onTap: context.goToHighlights,
          ),
          _HomeTile(
            icon: Icons.settings_rounded,
            title: 'Settings',
            onTap: context.goToSettings,
          ),
          _HomeTile(
            icon: Icons.info_outline_rounded,
            title: 'About',
            onTap: context.goToAbout,
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
