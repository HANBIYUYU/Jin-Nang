import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AudioCacheManager extends CacheManager {
  static const _key = 'jin_nang_audio';

  static final AudioCacheManager _instance = AudioCacheManager._();
  factory AudioCacheManager() => _instance;

  AudioCacheManager._()
      : super(Config(
          _key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 500,
        ));
}
