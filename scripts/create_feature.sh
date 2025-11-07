#!/bin/bash

# Función para convertir snake_case a PascalCase
to_pascal_case() {
    local input="$1"
    echo "$input" | awk -F'_' '{for (i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS=''
}

# Función para validar el nombre de la feature
validate_feature_name() {
    if [[ ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
        echo "Error: El nombre debe estar en minúsculas y solo puede contener letras, números y guiones bajos"
        echo "Ejemplo: update_app, create_user, etc."
        exit 1
    fi
    
    # Validar que no tenga la primera letra duplicada
    if [[ "$1" =~ ^([a-z])\1 ]]; then
        echo "Error: El nombre no puede tener la primera letra duplicada"
        echo "Ejemplo: 'user' en lugar de 'uuser'"
        exit 1
    fi
}

# Verificar si se proporcionó un nombre
if [ -z "$1" ]; then
    echo "Por favor, proporciona un nombre para la feature"
    echo "Uso: ./create_feature.sh nombre_feature"
    exit 1
fi

FEATURE_NAME=$1
validate_feature_name "$FEATURE_NAME"

# Convertir a PascalCase para los nombres de archivos
PASCAL_CASE=$(to_pascal_case "$FEATURE_NAME")
echo "PASCAL_CASE: $PASCAL_CASE"

# Definir la ruta base
BASE_PATH="lib/features"
NEW_FEATURE_PATH="$BASE_PATH/$FEATURE_NAME"

# Verificar si la feature ya existe
if [ -d "$NEW_FEATURE_PATH" ]; then
    echo "Error: La feature '$FEATURE_NAME' ya existe"
    exit 1
fi

# Crear la estructura de directorios
echo "Creando estructura para la feature: $FEATURE_NAME"
mkdir -p "$NEW_FEATURE_PATH"/{infrastructure,domain,presentation}
mkdir -p "$NEW_FEATURE_PATH"/domain/{datasources,entities,repositories}
mkdir -p "$NEW_FEATURE_PATH"/infrastructure/{datasources,repositories}
mkdir -p "$NEW_FEATURE_PATH"/presentation/{providers,screens,widgets}

# Crear archivos de Infrastructure
cat > "$NEW_FEATURE_PATH/domain/datasources/${FEATURE_NAME}_datasource.dart" << EOF
abstract class ${PASCAL_CASE}DataSource {
  Future<bool> test();
}
EOF

cat > "$NEW_FEATURE_PATH/domain/repositories/${FEATURE_NAME}_repository.dart" << EOF
abstract class ${PASCAL_CASE}Repository {
  Future<bool> test();
}
EOF

cat > "$NEW_FEATURE_PATH/domain/entities/${FEATURE_NAME}_entity.dart" << EOF
class ${PASCAL_CASE}Entity {
  final String id;
  final String name;
  ${PASCAL_CASE}Entity({required this.id, required this.name});
}
EOF

cat > "$NEW_FEATURE_PATH/domain/domain.dart" << EOF
export 'datasources/${FEATURE_NAME}_datasource.dart';
export 'entities/${FEATURE_NAME}_entity.dart';
export 'repositories/${FEATURE_NAME}_repository.dart';
EOF

cat > "$NEW_FEATURE_PATH/infrastructure/repositories/${FEATURE_NAME}_repository_impl.dart" << EOF
import 'package:fstcommunity/features/$FEATURE_NAME/domain/domain.dart';
import 'package:fstcommunity/features/$FEATURE_NAME/infrastructure/datasources/${FEATURE_NAME}_datasource_impl.dart';

class ${PASCAL_CASE}RepositoryImpl implements ${PASCAL_CASE}Repository {
  final ${PASCAL_CASE}DataSource dataSource;

  ${PASCAL_CASE}RepositoryImpl({${PASCAL_CASE}DataSource? dataSource})
      : dataSource = dataSource ?? ${PASCAL_CASE}DatasourceImpl();

  @override
  Future<bool> test() {
    return dataSource.test();
  }
}

EOF

cat > "$NEW_FEATURE_PATH/infrastructure/datasources/${FEATURE_NAME}_datasource_impl.dart" << EOF
import 'package:dio/dio.dart';
import 'package:fstcommunity/core/network/dio_client.dart';
import 'package:fstcommunity/features/$FEATURE_NAME/domain/domain.dart';
import 'package:fstcommunity/features/auth/infrastructure/errors/auth_errors.dart';

class ${PASCAL_CASE}DatasourceImpl implements ${PASCAL_CASE}DataSource {
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
EOF

# Crear archivos de Presentation
cat > "$NEW_FEATURE_PATH/presentation/providers/${FEATURE_NAME}_provider.dart" << EOF
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '${FEATURE_NAME}_provider.g.dart';

@riverpod
class ${PASCAL_CASE}Counter extends _\$${PASCAL_CASE}Counter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
EOF

cat > "$NEW_FEATURE_PATH/presentation/screens/${FEATURE_NAME}_screen.dart" << EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fstcommunity/features/$FEATURE_NAME/presentation/providers/${FEATURE_NAME}_provider.dart';

class ${PASCAL_CASE}Screen extends ConsumerWidget {
  const ${PASCAL_CASE}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(${FEATURE_NAME}CounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_CASE}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Contador:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '\$counter',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(${FEATURE_NAME}CounterProvider.notifier).decrement();
                  },
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(${FEATURE_NAME}CounterProvider.notifier).increment();
                  },
                  child: const Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
EOF

cat > "$NEW_FEATURE_PATH/presentation/presentation.dart" << EOF
export 'providers/${FEATURE_NAME}_provider.dart';
export 'screens/${FEATURE_NAME}_screen.dart';
EOF

echo "¡Feature '$FEATURE_NAME' creada exitosamente!"
echo "Ruta: $NEW_FEATURE_PATH" 