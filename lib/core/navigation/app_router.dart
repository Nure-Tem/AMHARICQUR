import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/about/about_screen.dart';
import '../../presentation/screens/bookmarks/bookmarks_screen.dart';
import '../../presentation/screens/highlights/highlights_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/reader/reader_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/toc/toc_screen.dart';
import 'app_routes.dart';

/// Application router configuration.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.toc,
        name: 'toc',
        builder: (context, state) => const TocScreen(),
      ),
      GoRoute(
        path: AppRoutes.reader,
        name: 'reader',
        builder: (context, state) {
          final blockId = int.tryParse(
            state.uri.queryParameters[RouteParams.contentBlockId] ?? '',
          );
          final sortOrder = int.tryParse(
            state.uri.queryParameters[RouteParams.sortOrder] ?? '',
          );
          final scrollOffset = double.tryParse(
            state.uri.queryParameters[RouteParams.scrollOffset] ?? '',
          );
          return ReaderScreen(
            initialBlockId: blockId,
            initialSortOrder: sortOrder,
            initialScrollOffset: scrollOffset,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookmarks,
        name: 'bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: AppRoutes.highlights,
        name: 'highlights',
        builder: (context, state) => const HighlightsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text(state.error?.toString() ?? 'Unknown route'),
      ),
    ),
  );
}

/// Navigation helpers.
extension AppNavigation on BuildContext {
  void goToHome() => go(AppRoutes.home);
  void goToToc() => go(AppRoutes.toc);
  void goToSearch() => go(AppRoutes.search);
  void goToBookmarks() => go(AppRoutes.bookmarks);
  void goToHighlights() => go(AppRoutes.highlights);
  void goToSettings() => go(AppRoutes.settings);
  void goToAbout() => go(AppRoutes.about);

  void goToReader({
    int? blockId,
    int? sortOrder,
    double? scrollOffset,
  }) {
    final params = <String, String>{};
    if (blockId != null) params[RouteParams.contentBlockId] = '$blockId';
    if (sortOrder != null) params[RouteParams.sortOrder] = '$sortOrder';
    if (scrollOffset != null) {
      params[RouteParams.scrollOffset] = '$scrollOffset';
    }
    final uri = Uri(path: AppRoutes.reader, queryParameters: params);
    go(uri.toString());
  }
}
