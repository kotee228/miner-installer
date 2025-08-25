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
