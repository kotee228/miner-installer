# miner-installer
Установка майнеров под Hive OS

Инструкции:

Файл miners.json - это ключ к управлению:

🎯 Как установить разные комбинации:
1. Установить только 1 майнер (только rigel):
```json
"default_miners": ["rigel"]
```
2. Установить 2 майнера (rigel + lolminer):
```json
"default_miners": ["rigel", "lolminer"]
```

🔧 Как добавить новый майнер:
1. Добавляем запись в секцию miners:
```json
"nbminer": {
  "version": "42.3",
  "url": "https://github.com/NebuTech/NBMiner/releases/download/v42.3/NBMiner_42.3_Linux.tgz",
  "install_path": "/hive/miners/nbminer/42.3"
}
```
2. Добавляем в default_miners если нужно:
```json
"default_miners": ["rigel", "nbminer"]
```

🚀 Как использовать:
1. Базовая установка (по умолчанию):
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/kotee228/miner-installer/main/install.sh)"
```
Установит майнеры из default_miners

2. Установка конкретного майнера (если нужно):
```bash
# Скачиваем скрипт установки одного майнера
curl -s -o /tmp/install_miner.sh https://raw.githubusercontent.com/kotee228/miner-installer/main/install_miner.sh
chmod +x /tmp/install_miner.sh

# Устанавливаем конкретный майнер
/tmp/install_miner.sh "rigel" "1.22.2" "https://github.com/..." "/hive/miners/rigel/1.22.2"
```
