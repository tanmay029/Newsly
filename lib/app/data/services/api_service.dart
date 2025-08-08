import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../utils/constants.dart';

class ApiService extends GetxService {
  late dio.Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(dio.LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<dio.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on dio.DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case dio.DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case dio.DioExceptionType.connectionError:
        return 'No internet connection. Please check your connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
