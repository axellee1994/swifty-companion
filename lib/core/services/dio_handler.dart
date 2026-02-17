import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioHandler {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Private constructor
  DioHandler._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.intra.42.fr',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ) {
    
    // Automatically adds the Bearer token to every request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            print("🚨 Token expired or invalid!");
            // Later, you can add logic here to trigger a re-authentication
          }
          return handler.next(e);
        },
      ),
    );

    // 2Logs the request AFTER the header is added
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  static void setup() {
    GetIt.instance.registerLazySingleton(() => DioHandler._internal());
  }
}