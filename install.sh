#!/bin/bash
set -e

echo "🎯 Установщик майнеров для HiveOS"
echo "=========================================="

# Скачиваем конфигурацию
CONFIG_URL="https://raw.githubusercontent.com/kotee228/miner-installer/main/miners.json"
MINER_SCRIPT_URL="https://raw.githubusercontent.com/kotee228/miner-installer/main/install_miner.sh"

# Скачиваем скрипт установки
echo "📥 Загружаем конфигурацию..."
curl -s -o /tmp/miners.json "$CONFIG_URL"
curl -s -o /tmp/install_miner.sh "$MINER_SCRIPT_URL"
chmod +x /tmp/install_miner.sh

# Простой парсинг JSON - находим default_miners
MINERS_CONFIG=$(cat /tmp/miners.json)
DEFAULT_MINERS=$(echo "$MINERS_CONFIG" | grep '"default_miners"' | sed 's/.*\[//;s/\].*//' | tr -d '" ' | tr ',' '\n')

if [ -z "$DEFAULT_MINERS" ]; then
    echo "❌ Не удалось найти default_miners"
    exit 1
fi

echo "🔧 Устанавливаем майнеры..."

# Установка майнеров
for miner in $DEFAULT_MINERS; do
    echo "🔄 Обрабатываем майнер: $miner"
    
    # Извлекаем данные для каждого майнера
    miner_block=$(echo "$MINERS_CONFIG" | sed -n "/\"$miner\": {/,/}/p")
    
    version=$(echo "$miner_block" | grep '"version"' | head -1 | cut -d'"' -f4)
    url=$(echo "$miner_block" | grep '"url"' | head -1 | cut -d'"' -f4)
    path=$(echo "$miner_block" | grep '"install_path"' | head -1 | cut -d'"' -f4)
    
    if [ -n "$version" ] && [ -n "$url" ] && [ -n "$path" ] && [ "$version" != "null" ]; then
        /tmp/install_miner.sh "$miner" "$version" "$url" "$path"
    else
        echo "⚠️ Ошибка конфига для $miner"
    fi
done

# Очистка
rm -f /tmp/miners.json /tmp/install_miner.sh

echo ""
echo "✅ Установка завершена!"
echo "📁 Майнеры установлены в /hive/miners/"
