import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  static const _key = 'jwt_token';
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() => _storage.read(key: _key);
  Future<void> saveToken(String token) => _storage.write(key: _key, value: token);
  Future<void> clearToken() => _storage.delete(key: _key);
  Future<bool> hasToken() async => await _storage.read(key: _key) != null;
}
