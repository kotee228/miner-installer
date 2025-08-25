#!/bin/bash
set -e

MINER_NAME=$1
MINER_VERSION=$2
DOWNLOAD_URL=$3
INSTALL_PATH=$4

echo "📦 Устанавливаем $MINER_NAME $MINER_VERSION..."
echo "📥 URL: $DOWNLOAD_URL"
echo "📁 Путь: $INSTALL_PATH"

# Создаем папку
mkdir -p "$INSTALL_PATH"

# Скачиваем
echo "⬇️ Скачиваем архив..."
if ! wget -q --timeout=30 --tries=3 "$DOWNLOAD_URL" -O "/tmp/${MINER_NAME}.tar.gz"; then
    echo "❌ Ошибка скачивания $MINER_NAME"
    exit 1
fi

# Проверяем, что архив скачался
if [ ! -s "/tmp/${MINER_NAME}.tar.gz" ]; then
    echo "❌ Пустой архив для $MINER_NAME"
    rm -f "/tmp/${MINER_NAME}.tar.gz"
    exit 1
fi

# Распаковываем
echo "📂 Распаковываем архив..."
if ! tar -xzf "/tmp/${MINER_NAME}.tar.gz" -C "$INSTALL_PATH" --strip-components=1; then
    echo "❌ Ошибка распаковки $MINER_NAME"
    rm -f "/tmp/${MINER_NAME}.tar.gz"
    exit 1
fi

# Делаем исполняемым (ищем бинарные файлы)
echo "🔧 Даем права на выполнение..."
find "$INSTALL_PATH" -type f \( -name "$MINER_NAME" -o -name "$MINER_NAME*" -o -perm -u=x -a ! -name "*.so" \) | head -5 | while read file; do
    if [ -f "$file" ] && [ ! -d "$file" ]; then
        chmod +x "$file"
        echo "   ✅ Исполняемый файл: $(basename "$file")"
    fi
done

# Очищаем
rm -f "/tmp/${MINER_NAME}.tar.gz"

echo "✅ $MINER_NAME $MINER_VERSION установлен в $INSTALL_PATH"
echo "📋 Содержимое папки:"
ls -la "$INSTALL_PATH"
