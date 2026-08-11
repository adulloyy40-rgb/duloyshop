import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      _authInterceptor(),
      _errorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshToken = await _secureStorage.read(key: 'refresh_token');
          if (refreshToken != null) {
            try {
              final response = await _dio.post('/auth/refresh', data: {
                'refresh_token': refreshToken,
              });
              final newToken = response.data['access_token'];
              await _secureStorage.write(key: 'access_token', value: newToken);
              
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              final cloneReq = await _dio.fetch(opts);
              return handler.resolve(cloneReq);
            } catch (e) {
              await _secureStorage.deleteAll();
            }
          }
        }
        return handler.next(error);
      },
    );
  }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String message = 'Terjadi kesalahan';
        
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            message = 'Koneksi timeout. Periksa jaringan Anda.';
            break;
          case DioExceptionType.badResponse:
            message = error.response?.data?['message'] ?? 
                     'Error ${error.response?.statusCode}';
            break;
          case DioExceptionType.connectionError:
            message = 'Tidak dapat terhubung ke server';
            break;
          default:
            message = error.message ?? 'Terjadi kesalahan tidak dikenal';
        }
        
        return handler.next(error.copyWith(
          error: message,
        ));
      },
    );
  }
}
