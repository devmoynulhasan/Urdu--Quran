import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'app_const.dart';
import 'local_storage.dart';

class BaseClient {
  static Dio? _dio;

  static Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  // ✅ Dio instance বানানো
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConst.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConst.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConst.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ✅ Interceptor — token যোগ + error handle
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  // ✅ GET
  static Future<Response?> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // ✅ POST
  static Future<Response?> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // ✅ PUT
  static Future<Response?> put(
      String endpoint, {
        dynamic data,
      }) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // ✅ DELETE
  static Future<Response?> delete(
      String endpoint, {
        dynamic data,
      }) async {
    try {
      final response = await dio.delete(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // ✅ Error Handler
  static void _handleError(DioException error) {
    String message = 'Something went wrong';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server not responding';
        break;
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            message = 'Bad request';
            break;
          case 401:
            message = 'Unauthorized';
            LocalStorage.removeToken(); // ✅ Token মুছে দাও
            Get.offAllNamed('/login'); // ✅ Login এ পাঠাও
            break;
          case 403:
            message = 'Forbidden';
            break;
          case 404:
            message = 'Not found';
            break;
          case 500:
            message = 'Server error';
            break;
        }
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = error.message ?? 'Unknown error';
    }

    // ✅ GetX Snackbar দিয়ে error দেখাও
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFD32F2F),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
    );
  }
}