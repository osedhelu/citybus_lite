import 'package:citybus_lite/config/http/client.dart';
import 'package:dio/dio.dart';
import 'package:citybus_lite/features/home/domain/domain.dart';
import 'package:citybus_lite/config/http/error.dart';

class HomeDatasourceImpl implements HomeDataSource {
  final _dio = DioClient().dio;

  @override
  Future<bool> test() async {
    try {
      final response = await _dio.get("/test");
      if (response.statusCode != 200) {
        throw Exception();
      }
      return true;
    } on DioException catch (e) {
      final codeState = e.response?.statusCode ?? 0;
      if (codeState == 400) {
        throw CustomError(message: "Error de conexión");
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: "Revise su conexión a internet");
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
