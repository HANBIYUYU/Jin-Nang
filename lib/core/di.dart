import 'auth/token_store.dart';
import 'network/api_client.dart';
import 'audio/audio_cache_manager.dart';

class Di {
  Di._();

  static final tokenStore = TokenStore();
  static final api = ApiClient(tokenStore);
  static final audioCache = AudioCacheManager();
}
