import 'package:citybus_lite/features/home/infrastructure/repositories/home_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.

class InterfaceHomeProvider {
  Future<bool> test() async => false;
}

final helloWorldProvider = Provider<InterfaceHomeProvider>(
  (_) => HomeProvider(),
);

class HomeProvider implements InterfaceHomeProvider {
  @override
  Future<bool> test() async {
    final repository = HomeRepositoryImpl();
    final result = await repository.test();
    return result;
  }
}
