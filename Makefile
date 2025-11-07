dev:
	flutter pub run build_runner build --delete-conflicting-outputs; \
	dart run build_runner watch; \
lint: 
	dart run custom_lint
update_splash:
	dart run flutter_native_splash:create --path=native_splash.yaml
generate: 
	@echo "Configurando firma de la aplicación..."
	@chmod +x update_version.sh
	@./update_version.sh
	flutter build appbundle --release
	@echo "✅ APK generado en: build/app/outputs/flutter-apk/app-release.apk"
run:
	flutter run
clean:
	flutter clean
	rm -rf .dart_tool/build
	flutter pub get
clean_gradle:
	chmod +x clean_android.sh
	./clean_android.sh
name_change:
	@read -p "Ingresa el nuevo nombre del paquete (ej: com.osedhelu.fstcommunity.new): " package_name; \
	dart run change_app_package_name:main $$package_name
new_feature:
	@read -p "Ingresa el nombre de la nueva feature (en minúsculas con guiones bajos): " feature_name; \
	./scripts/create_feature.sh $$feature_name

clean_all:
	rm -rf ~/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin && \
	rm -rf android/.gradle && \
	rm -rf build && \
	flutter clean && \
	cd android && \
	./gradlew clean && \
	cd .. && \
	flutter pub get
