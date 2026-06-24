import '../../../domain/entities/app_settings.dart';
import '../../../domain/repositories/repositories.dart';
import '../datasources/local/daos/settings_dao.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dao);

  final SettingsDao _dao;

  @override
  Future<AppSettings> getSettings() => _dao.getSettings();

  @override
  Future<void> saveSettings(AppSettings settings) => _dao.saveSettings(settings);
}
