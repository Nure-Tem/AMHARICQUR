import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/navigation/app_router.dart';
import '../core/services/annotation_service.dart';
import '../core/services/book_content_service.dart';
import '../core/services/reading_position_service.dart';
import '../core/services/search_service.dart';
import '../core/services/settings_service.dart';
import '../data/datasources/local/daos/book_content_dao.dart';
import '../data/datasources/local/daos/bookmark_dao.dart';
import '../data/datasources/local/daos/highlight_dao.dart';
import '../data/datasources/local/daos/note_dao.dart';
import '../data/datasources/local/daos/reading_history_dao.dart';
import '../data/datasources/local/daos/search_dao.dart';
import '../data/datasources/local/daos/settings_dao.dart';
import '../data/datasources/local/database/app_database.dart';
import '../data/repositories/book_content_repository_impl.dart';
import '../data/repositories/bookmark_repository_impl.dart';
import '../data/repositories/highlight_repository_impl.dart';
import '../data/repositories/note_repository_impl.dart';
import '../data/repositories/reading_history_repository_impl.dart';
import '../data/repositories/search_repository_impl.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/entities/app_settings.dart';
import '../domain/repositories/repositories.dart';

// ─── Database ───────────────────────────────────────────────────────────────
// Overridden in main() after async initialization.

final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError(
    'AppDatabase not initialized. Override databaseProvider in main().',
  );
});

// ─── DAOs ───────────────────────────────────────────────────────────────────

final bookContentDaoProvider = Provider<BookContentDao>((ref) {
  return BookContentDaoImpl(ref.watch(databaseProvider));
});

final bookmarkDaoProvider = Provider<BookmarkDao>((ref) {
  return BookmarkDaoImpl(ref.watch(databaseProvider));
});

final highlightDaoProvider = Provider<HighlightDao>((ref) {
  return HighlightDaoImpl(ref.watch(databaseProvider));
});

final noteDaoProvider = Provider<NoteDao>((ref) {
  return NoteDaoImpl(ref.watch(databaseProvider));
});

final readingHistoryDaoProvider = Provider<ReadingHistoryDao>((ref) {
  return ReadingHistoryDaoImpl(ref.watch(databaseProvider));
});

final searchDaoProvider = Provider<SearchDao>((ref) {
  return SearchDaoImpl(ref.watch(databaseProvider));
});

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return SettingsDaoImpl(ref.watch(databaseProvider));
});

// ─── Repositories ───────────────────────────────────────────────────────────

final bookContentRepositoryProvider = Provider<BookContentRepository>((ref) {
  return BookContentRepositoryImpl(ref.watch(bookContentDaoProvider));
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepositoryImpl(ref.watch(bookmarkDaoProvider));
});

final highlightRepositoryProvider = Provider<HighlightRepository>((ref) {
  return HighlightRepositoryImpl(ref.watch(highlightDaoProvider));
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(noteDaoProvider));
});

final readingHistoryRepositoryProvider =
    Provider<ReadingHistoryRepository>((ref) {
  return ReadingHistoryRepositoryImpl(ref.watch(readingHistoryDaoProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(searchDaoProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsDaoProvider));
});

// ─── Services ─────────────────────────────────────────────────────────────────

final bookContentServiceProvider = Provider<BookContentService>((ref) {
  return BookContentServiceImpl(ref.watch(bookContentRepositoryProvider));
});

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchServiceImpl(ref.watch(searchRepositoryProvider));
});

final readingPositionServiceProvider = Provider<ReadingPositionService>((ref) {
  return ReadingPositionServiceImpl(ref.watch(readingHistoryRepositoryProvider));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsServiceImpl(ref.watch(settingsRepositoryProvider));
});

final bookmarkServiceProvider = Provider<BookmarkService>((ref) {
  return BookmarkServiceImpl(ref.watch(bookmarkRepositoryProvider));
});

final highlightServiceProvider = Provider<HighlightService>((ref) {
  return HighlightServiceImpl(ref.watch(highlightRepositoryProvider));
});

final noteServiceProvider = Provider<NoteService>((ref) {
  return NoteServiceImpl(ref.watch(noteRepositoryProvider));
});

// ─── App State ────────────────────────────────────────────────────────────────

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final service = ref.watch(settingsServiceProvider);
    return service.load();
  }

  Future<void> updateSettings(AppSettings settings) async {
    final service = ref.read(settingsServiceProvider);
    await service.save(settings);
    state = AsyncData(settings);
  }
}

// ─── Navigation ───────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) => createAppRouter());
