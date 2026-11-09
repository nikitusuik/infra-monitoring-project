#!/bin/bash

LOG_FILE="access.log"

# Генерируем тестовые логи, если файла ещё нет
if [ ! -f "$LOG_FILE" ]; then
    echo "Создаём тестовый файл логов..."

    for i in $(seq 1 350); do
        case $((i % 5)) in
            0) IP="192.168.1.10"; STATUS=200; METHOD="GET"; PATH_URL="/api/users" ;;
            1) IP="192.168.1.10"; STATUS=200; METHOD="GET"; PATH_URL="/api/users" ;;
            2) IP="10.0.0.5"; STATUS=401; METHOD="POST"; PATH_URL="/api/login" ;;
            3) IP="172.16.0.8"; STATUS=404; METHOD="GET"; PATH_URL="/api/data" ;;
            4) IP="192.168.1.20"; STATUS=500; METHOD="GET"; PATH_URL="/api/status" ;;
        esac

        printf '%s - - [15/Aug/2026:10:15:%02d] "%s %s HTTP/1.1" %s\n' \
            "$IP" "$((i % 60))" "$METHOD" "$PATH_URL" "$STATUS"
    done > "$LOG_FILE"
fi

echo "=== АНАЛИЗ ЛОГОВ ==="

echo
echo "Общее количество запросов:"
wc -l < "$LOG_FILE"

echo
echo "Топ-3 IP-адреса:"
grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$LOG_FILE" |
    awk '{print $1}' |
    sort |
    uniq -c |
    sort -nr |
    head -n 3

echo
echo "Количество запросов с кодами 4xx:"
awk '$NF ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE"

echo
echo "Количество запросов с кодами 5xx:"
awk '$NF ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE"
