#!/bin/bash

# Проверка наличия URL
if [ -z "$1" ]; then
    echo "Укажите URL для проверки"
    echo "Пример: ./check_api.sh https://httpbin.org/status/200"
    exit 1
fi

URL="$1"

# Выполняем запрос и получаем HTTP-код
HTTP_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 5 --max-time 15 "$URL")

# Проверяем результат
if [ "$HTTP_CODE" = "200" ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $HTTP_CODE"
    exit 1
fi
