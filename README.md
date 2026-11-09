# Infra Monitoring Project

Учебный DevOps-проект для проверки доступности API, анализа HTTP-логов и запуска сервисов через Docker Compose.

## Используемые технологии

Bash, Git, GitHub, Wireshark, Docker Compose, Nginx, GitHub Actions, SSH.

## Файлы проекта

- `check_api.sh` — проверка доступности API.
- `analyze_logs.sh` — анализ HTTP-логов.
- `compose.yaml` — запуск контейнеров.
- `nginx.conf` — настройка Nginx.
- `.github/workflows/ci.yml` — автоматическая проверка скриптов.
- `http_capture.pcapng` — захваченный HTTP-трафик.

## Проверка API

```bash
./check_api.sh https://httpbin.org/status/200
```

При ответе HTTP 200 скрипт сообщает об успешной проверке и возвращает код 0. При ошибке возвращает код 1.

## Анализ логов

```bash
./analyze_logs.sh access.log
```

Скрипт выводит количество записей, три наиболее активных IP-адреса и количество ответов с кодами 4xx и 5xx.

## Docker Compose

Для запуска сервисов:

```bash
docker compose up -d
```

Для проверки:

```bash
docker compose ps
curl http://localhost
```

Nginx принимает запросы на порту 80 и передаёт их HTTP Echo на порт 8080.

Ожидаемый ответ:

```text
Monitoring Service Active
```

На рабочем компьютере доступ через localhost пока не работает из-за невыясненных сетевых ограничений. Работа Nginx и API проверена внутри сети Docker.

Остановка контейнеров:

```bash
docker compose down
```

## SSH и передача файлов

Создание SSH-ключа:

```bash
ssh-keygen -t ed25519
```

Копирование открытого ключа на сервер:

```bash
ssh-copy-id user@server
```

Подключение к серверу:

```bash
ssh user@server
```

Передача файла:

```bash
scp file.txt user@server:/home/user/
```

Передача каталога через архив:

```bash
tar -czf project.tar.gz infra-monitoring-project/
scp project.tar.gz user@server:/home/user/
```

## GitHub Actions

При создании Pull Request в ветку `main` автоматически запускаются проверки:

- Синтаксис Bash-скриптов через `bash -n`.
- Проверка доступности тестового API.

## Анализ HTTP-трафика

Трафик записан с помощью Wireshark в файл `http_capture.pcapng`.

В захвате присутствуют запросы GET и ответы HTTP 200.

Использованные IP-адреса:

- `172.18.0.4` — тестовый клиент.
- `172.18.0.3` — Nginx.
- `172.18.0.2` — HTTP Echo.

Для просмотра HTTP-запросов используется фильтр `http`.
