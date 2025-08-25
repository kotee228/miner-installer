#!/bin/bash
set -e

MINER_NAME=$1
MINER_VERSION=$2
DOWNLOAD_URL=$3
INSTALL_PATH=$4

echo "📦 Устанавливаем $MINER_NAME $MINER_VERSION..."

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

# Делаем ВСЕ файлы в папке исполняемыми (на всякий случай)
echo "🔧 Даем права на выполнение..."
find "$INSTALL_PATH" -type f -exec chmod +x {} \; 2>/dev/null || true

# Особые случаи для конкретных майнеров
case $MINER_NAME in
    "rigel")
        # Для rigel ищем конкретный файл
        if [ -f "$INSTALL_PATH/rigel" ]; then
            chmod +x "$INSTALL_PATH/rigel"
            echo "   ✅ Исполняемый файл: rigel"
        fi
        ;;
    "lolminer")
        # Для lolminer ищем lolMiner
        if [ -f "$INSTALL_PATH/lolMiner" ]; then
            chmod +x "$INSTALL_PATH/lolMiner"
            echo "   ✅ Исполняемый файл: lolMiner"
        fi
        ;;
    "t-rex")
        # Для t-rex ищем t-rex
        if [ -f "$INSTALL_PATH/t-rex" ]; then
            chmod +x "$INSTALL_PATH/t-rex"
            echo "   ✅ Исполняемый файл: t-rex"
        fi
        ;;
esac

# Очищаем
rm -f "/tmp/${MINER_NAME}.tar.gz"

echo "✅ $MINER_NAME $MINER_VERSION установлен в $INSTALL_PATH"
echo "📋 Содержимое папки:"
ls -la "$INSTALL_PATH"
