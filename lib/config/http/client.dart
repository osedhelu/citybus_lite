import 'package:citybus_lite/config/constant/environment.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal()
    : _dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          validateStatus: (status) {
            return status != null && status < 500;
          },
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.response?.statusCode == 401) {
            // Manejar el error de autenticación
            return handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: 'Sesión expirada o no autorizada',
                response: e.response,
                type: DioExceptionType.badResponse,
              ),
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
