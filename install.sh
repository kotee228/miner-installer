#!/bin/bash
set -e

echo "🎯 Установщик майнеров для HiveOS"
echo "=========================================="

# Проверяем наличие jq
if ! command -v jq &> /dev/null; then
    echo "❌ jq не установлен. Устанавливаем..."
    apt-get update && apt-get install -y jq
fi

# Скачиваем конфигурацию
CONFIG_URL="https://raw.githubusercontent.com/kotee228/miner-installer/main/miners.json"
MINER_SCRIPT_URL="https://raw.githubusercontent.com/kotee228/miner-installer/main/install_miner.sh"

# Скачиваем скрипт установки
echo "📥 Загружаем конфигурацию..."
curl -s -o /tmp/miners.json "$CONFIG_URL"
curl -s -o /tmp/install_miner.sh "$MINER_SCRIPT_URL"
chmod +x /tmp/install_miner.sh

# Читаем конфиг с помощью jq
DEFAULT_MINERS=$(jq -r '.default_miners[]' /tmp/miners.json 2>/dev/null)

if [ -z "$DEFAULT_MINERS" ]; then
    echo "❌ Ошибка парсинга JSON файла"
    exit 1
fi

# Установка майнеров
echo "🔧 Устанавливаем майнеры..."
for miner in $DEFAULT_MINERS; do
    echo "🔄 Обрабатываем майнер: $miner"
    
    # Получаем данные о майнере с помощью jq
    version=$(jq -r ".miners.\"$miner\".version" /tmp/miners.json 2>/dev/null)
    url=$(jq -r ".miners.\"$miner\".url" /tmp/miners.json 2>/dev/null)
    path=$(jq -r ".miners.\"$miner\".install_path" /tmp/miners.json 2>/dev/null)
    
    if [ -n "$version" ] && [ -n "$url" ] && [ -n "$path" ] && [ "$version" != "null" ] && [ "$url" != "null" ] && [ "$path" != "null" ]; then
        echo "📦 Установка: $miner версии $version"
        echo "📥 URL: $url"
        echo "📁 Путь: $path"
        /tmp/install_miner.sh "$miner" "$version" "$url" "$path"
    else
        echo "⚠️ Ошибка конфига для $miner"
        echo "   version: $version"
        echo "   url: $url"
        echo "   path: $path"
    fi
done

# Очистка
rm -f /tmp/miners.json /tmp/install_miner.sh

echo ""
echo "✅ Установка завершена!"
echo "📁 Майнеры установлены в /hive/miners/"
