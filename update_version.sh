#!/bin/bash

# Incrementar versionCode en pubspec.yaml
current_version_code=$(grep "versionCode:" pubspec.yaml | sed -n 's/versionCode: \([0-9]*\)/\1/p')
if [ -z "$current_version_code" ]; then
    current_version_code=1
fi
current_version=$(grep "version:" pubspec.yaml | sed -n 's/version: \([0-9.]*\)/\1/p')
if [ -z "$current_version" ]; then
    current_version="1.0.0+1"
fi
new_version=$(echo "$current_version" | awk -F. '{print $1"."$2"."$3+1}')
new_version_code=$((current_version_code + 1))
sed -i '' "s/version: .*/version: $new_version+$new_version_code/" pubspec.yaml
sed -i '' "s/versionCode: .*/versionCode: $new_version_code/" pubspec.yaml
echo "✅ VersionCode incrementado a: $new_version_code"

# Actualizar local.properties
echo "✅ local.properties actualizado con versionCode: $new_version_code" 