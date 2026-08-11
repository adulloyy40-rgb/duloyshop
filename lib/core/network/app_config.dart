import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfig {
  AppConfig._();

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String defaultServerUrl =
      'http://192.168.215.121:8000';

  static const String serverUrlKey =
      'server_url';

  /// Mengambil URL server yang tersimpan.
  ///
  /// Jika belum pernah disimpan, gunakan server default.
  static Future<String> getServerUrl() async {
    final savedUrl = await _storage.read(
      key: serverUrlKey,
    );

    if (savedUrl == null || savedUrl.trim().isEmpty) {
      return defaultServerUrl;
    }

    return normalizeUrl(savedUrl);
  }

  /// Menyimpan URL server.
  static Future<void> saveServerUrl(
    String url,
  ) async {
    final normalizedUrl = normalizeUrl(url);

    await _storage.write(
      key: serverUrlKey,
      value: normalizedUrl,
    );
  }

  /// Menghapus URL server yang tersimpan.
  static Future<void> resetServerUrl() async {
    await _storage.delete(
      key: serverUrlKey,
    );
  }

  /// Membersihkan URL agar konsisten.
  ///
  /// Contoh:
  /// http://192.168.1.10:8000/
  /// menjadi:
  /// http://192.168.1.10:8000
  static String normalizeUrl(String url) {
    var result = url.trim();

    if (result.endsWith('/')) {
      result = result.substring(
        0,
        result.length - 1,
      );
    }

    if (result.endsWith('/api')) {
      result = result.substring(
        0,
        result.length - 4,
      );
    }

    return result;
  }

  /// URL lengkap API.
  static Future<String> getApiBaseUrl() async {
    final serverUrl = await getServerUrl();

    return '$serverUrl/api';
  }
}
