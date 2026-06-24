import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/repositories.dart';

/// Application settings read/write.
abstract class SettingsService {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}

class SettingsServiceImpl implements SettingsService {
  SettingsServiceImpl(this._repository);

  final SettingsRepository _repository;

  @override
  Future<AppSettings> load() => _repository.getSettings();

  @override
  Future<void> save(AppSettings settings) => _repository.saveSettings(settings);
}
