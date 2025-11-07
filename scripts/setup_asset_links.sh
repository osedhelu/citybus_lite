#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Crear directorio .well-known si no existe
mkdir -p web/.well-known

# Crear el archivo assetlinks.json
cat > web/.well-known/assetlinks.json << EOL
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.osedhelu.fenixcommunity",
      "sha256_cert_fingerprints": [
        "B3:F9:F0:DF:48:81:47:B7:F5:D3:73:86:66:13:71:60:9D:BF:07:5C:C5:90:50:62:F9:0E:B6:FE:C3:86:77:56",
        "2B:20:7A:24:40:37:A9:03:F3:2F:09:A8:66:1F:B6:3A:3D:21:96:50:76:4A:B5:62:68:2A:06:2A:A2:9C:B0:F9"
      ]
    }
  }
]
EOL

# Verificar si el archivo se creó correctamente
if [ -f "web/.well-known/assetlinks.json" ]; then
    echo -e "${GREEN}✓ Archivo assetlinks.json creado exitosamente${NC}"
else
    echo -e "${RED}✗ Error al crear el archivo assetlinks.json${NC}"
    exit 1
fi

# Verificar si existe el archivo nginx.conf
if [ -f "nginx.conf" ]; then
    # Verificar si ya existe la configuración para .well-known
    if ! grep -q "location /.well-known/" nginx.conf; then
        # Agregar la configuración para .well-known al final del archivo
        cat >> nginx.conf << EOL

# Configuración para Digital Asset Links
location /.well-known/ {
    alias /usr/share/nginx/html/.well-known/;
    try_files \$uri \$uri/ =404;
    add_header Content-Type application/json;
}
EOL
        echo -e "${GREEN}✓ Configuración de nginx actualizada${NC}"
    else
        echo -e "${GREEN}✓ La configuración de nginx ya existe${NC}"
    fi
else
    echo -e "${RED}✗ No se encontró el archivo nginx.conf${NC}"
fi

# Modificar el Dockerfile para incluir el archivo assetlinks.json
if [ -f "Dockerfile" ]; then
    # Verificar si ya existe la copia del archivo assetlinks.json
    if ! grep -q "COPY web/.well-known" Dockerfile; then
        # Agregar la copia del archivo antes del CMD
        sed -i '' '/CMD \["nginx", "-g", "daemon off;"\]/i\\
# Copiar el archivo assetlinks.json\\
COPY web/.well-known /usr/share/nginx/html/.well-known\\
' Dockerfile
        echo -e "${GREEN}✓ Dockerfile actualizado para incluir assetlinks.json${NC}"
    else
        echo -e "${GREEN}✓ El Dockerfile ya incluye la copia de assetlinks.json${NC}"
    fi
else
    echo -e "${RED}✗ No se encontró el archivo Dockerfile${NC}"
fi

echo -e "${GREEN}✓ Proceso completado${NC}"
echo "El archivo assetlinks.json está disponible en: web/.well-known/assetlinks.json"
echo "Para reconstruir la imagen Docker, ejecuta:"
echo "docker build -t fstcommunity ." 