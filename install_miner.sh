#!/bin/bash
set -e

MINER_NAME=$1
MINER_VERSION=$2
DOWNLOAD_URL=$3
INSTALL_PATH=$4

echo "📦 Устанавливаем $MINER_NAME $MINER_VERSION..."

# Скачиваем
if ! wget -q "$DOWNLOAD_URL" -O "/tmp/${MINER_NAME}.tar.gz"; then
    echo "❌ Ошибка скачивания $MINER_NAME"
    return 1
fi

# Создаем папку
mkdir -p "$INSTALL_PATH"

# Распаковываем
if ! tar -xzf "/tmp/${MINER_NAME}.tar.gz" -C "$INSTALL_PATH" --strip-components=1; then
    echo "❌ Ошибка распаковки $MINER_NAME"
    rm -f "/tmp/${MINER_NAME}.tar.gz"
    return 1
fi

# Делаем исполняемым (ищем бинарный файл)
find "$INSTALL_PATH" -type f -executable -name "$MINER_NAME" -o -name "$MINER_NAME*" | head -1 | xargs chmod +x

# Очищаем
rm -f "/tmp/${MINER_NAME}.tar.gz"

echo "✅ $MINER_NAME $MINER_VERSION установлен в $INSTALL_PATH"
