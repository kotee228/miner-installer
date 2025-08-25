#!/bin/bash
set -e

echo "🎯 Установщик майнеров для HiveOS"
echo "=========================================="

# Скачиваем конфигурацию
CONFIG_URL="https://raw.githubusercontent.com/ваш-аккаунт/miner-installer/main/miners.json"
MINER_SCRIPT_URL="https://raw.githubusercontent.com/ваш-аккаунт/miner-installer/main/install_miner.sh"

# Скачиваем скрипт установки
echo "📥 Загружаем конфигурацию..."
curl -s -o /tmp/miners.json "$CONFIG_URL"
curl -s -o /tmp/install_miner.sh "$MINER_SCRIPT_URL"
chmod +x /tmp/install_miner.sh

# Читаем конфиг
MINERS_CONFIG=$(cat /tmp/miners.json)
DEFAULT_MINERS=$(echo "$MINERS_CONFIG" | grep -o '"default_miners":\[[^]]*\]' | grep -o '\[.*\]' | tr -d '[]"' | tr ',' '\n')

# Установка майнеров
echo "🔧 Устанавливаем майнеры..."
for miner in $DEFAULT_MINERS; do
    miner_data=$(echo "$MINERS_CONFIG" | grep -A 4 "\"$miner\"")
    version=$(echo "$miner_data" | grep '"version"' | cut -d'"' -f4)
    url=$(echo "$miner_data" | grep '"url"' | cut -d'"' -f4)
    path=$(echo "$miner_data" | grep '"install_path"' | cut -d'"' -f4)
    
    if [ -n "$version" ] && [ -n "$url" ] && [ -n "$path" ]; then
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
