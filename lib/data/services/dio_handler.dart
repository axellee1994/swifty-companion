import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHandler {
  final Dio dio;

  // Private constructor
  DioHandler._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.intra.42.fr',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ) {
    // Added logger for terminal
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  // Global setup function
  static void setup() {
    GetIt.instance.registerLazySingleton(() => DioHandler._internal());
  }
}