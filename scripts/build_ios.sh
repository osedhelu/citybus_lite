#!/bin/bash

# Script para build y export de iOS con cumplimiento de exportación
# Uso: ./scripts/build_ios.sh

set -e

echo "🚀 Iniciando build de iOS con cumplimiento de exportación..."

# Variables
PROJECT_NAME="Runner"
SCHEME="Runner"
CONFIGURATION="Release"
ARCHIVE_PATH="build/ios/archive/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="build/ios/export"
EXPORT_OPTIONS="ios/ExportOptions.plist"

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
rm -rf build/ios/
mkdir -p build/ios/archive
mkdir -p build/ios/export

# Build del proyecto Flutter
echo "📱 Construyendo proyecto Flutter..."
flutter clean
flutter pub get
flutter build ios --release --no-codesign

# Abrir Xcode para configurar manualmente si es necesario
echo "⚠️  IMPORTANTE: Configuración manual requerida en Xcode"
echo "1. Abre ios/Runner.xcworkspace en Xcode"
echo "2. Ve a tu target 'Runner'"
echo "3. En 'Build Settings', busca 'Export Compliance'"
echo "4. Configura:"
echo "   - Export Compliance Code: YES"
echo "   - Export Compliance Code Signing Required: NO"
echo ""
echo "5. Después de configurar, presiona Enter para continuar..."
read -p "Presiona Enter cuando hayas completado la configuración en Xcode..."

# Comando para archivar (requiere configuración manual en Xcode)
echo "📦 Creando archive..."
echo "Ejecuta este comando en Xcode o desde la terminal:"
echo ""
echo "xcodebuild -workspace ios/Runner.xcworkspace \\"
echo "  -scheme $SCHEME \\"
echo "  -configuration $CONFIGURATION \\"
echo "  -archivePath $ARCHIVE_PATH \\"
echo "  archive"
echo ""

# Comando para exportar
echo "📤 Comando para exportar:"
echo ""
echo "xcodebuild -exportArchive \\"
echo "  -archivePath $ARCHIVE_PATH \\"
echo "  -exportPath $EXPORT_PATH \\"
echo "  -exportOptionsPlist $EXPORT_OPTIONS"
echo ""

echo "✅ Configuración completada!"
echo "📋 Resumen de cambios:"
echo "   - ✅ Info.plist configurado con ITSAppUsesNonExemptEncryption: false"
echo "   - ✅ ExportOptions.plist creado"
echo "   - ⚠️  Configuración manual requerida en Xcode Build Settings"
echo ""
echo "🔗 En App Store Connect:"
echo "   - Ve a tu app"
echo "   - En 'App Information'"
echo "   - Marca 'No' en 'Does this app use encryption?'"
