import 'package:key_value_storage/key_value_storage.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

/// [Hive]를 감싸서 모든 어댑터를 등록하고 모든 키를 하나의 장소에서 관리할 수 있도록 합니다.
/// 이 클래스를 사용하려면, 단순히 그 중 하나의 노출된 상자, 예를 들어 [quoteListPageBox]를 풀어서 그 안에서 작업을 실행하면 됩니다. 예를 들면:
/// ```
/// (await quoteListPageBox).clear();
/// ```
/// Hive에 비원시(primitive) 유형을 저장하려면 증분 [typeId]를 사용해야 합니다. 이러한 모든 모델과 상자의 키를 단일 패키지에 모아 사용하면 충돌을 피할 수 있습니다.
class KeyValueStorage {
  static const _quoteListPagesBoxKey = 'quote-list-pages';
  static const _favoriteQuoteListPagesBoxKey = 'favorite-quote-list-pages';
  static const _darkModePreferenceBoxKey = 'dark-mode-preference';

  final HiveInterface _hive;

  KeyValueStorage({
    @visibleForTesting HiveInterface? hive,
  }) : _hive = hive ?? Hive {
    try {
      _hive
        ..registerAdapter(QuoteListPageCMAdapter())
        ..registerAdapter(QuoteCMAdapter())
        ..registerAdapter(DarkModePreferenceCMAdapter());
    } catch (_) {
      throw Exception(
        'You shouldn\'t have more than one [KeyValueStorage] instance in your '
        'project',
      );
    }
  }

  Future<Box<QuoteListPageCM>> get quoteListPageBox {
    return _openHiveBox<QuoteListPageCM>(
      _quoteListPagesBoxKey,
      isTemporary: true,
    );
  }

  Future<Box<QuoteListPageCM>> get favoriteQuoteListPageBox {
    return _openHiveBox<QuoteListPageCM>(
      _favoriteQuoteListPagesBoxKey,
      isTemporary: true,
    );
  }

  Future<Box<DarkModePreferenceCM>> get darkModePreferenceBox {
    return _openHiveBox<DarkModePreferenceCM>(
      _darkModePreferenceBoxKey,
      isTemporary: false,
    );
  }

  Future<Box<T>> _openHiveBox<T>(
    String boxKey, {
    required bool isTemporary,
  }) async {
    if (_hive.isBoxOpen(boxKey)) {
      return _hive.box(boxKey);
    } else {
      final directory = await (isTemporary
          ? getTemporaryDirectory()
          : getApplicationDocumentsDirectory());

      return _hive.openBox<T>(boxKey, path: directory.path);
    }
  }
}
