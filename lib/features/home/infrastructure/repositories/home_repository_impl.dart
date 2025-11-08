import 'package:citybus_lite/features/home/domain/domain.dart';
import 'package:citybus_lite/features/home/infrastructure/datasources/home_datasource_impl.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;

  HomeRepositoryImpl({HomeDataSource? dataSource})
    : dataSource = dataSource ?? HomeDatasourceImpl();

  @override
  Future<bool> test() {
    return dataSource.test();
  }
}
