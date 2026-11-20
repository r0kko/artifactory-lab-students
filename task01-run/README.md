# Запуск стенда JFrog Artifactory

## Подготовка

Команда `docker version` показала версии клиента и сервера. Стенд запущен из корня репозитория с помощью Docker Compose.

## Запуск Artifactory и PostgreSQL

Для запуска использована локальная копия `docker-compose.yml`. В ней порты опубликованы на `127.0.0.1`, а для подключения к PostgreSQL задан отдельный пароль.

```text
$ docker compose --project-directory . -f "$LAB_COMPOSE" up -d --quiet-pull
```

Compose сначала дождался готовности PostgreSQL. Artifactory подключается к нему по адресу `jdbc:postgresql://postgres:5432/artifactory` из `JF_SHARED_DATABASE_URL`.

## Проверка контейнеров

```text
$ docker compose ps --format 'table {{.Name}}\t{{.Service}}\t{{.Status}}'
NAME                   SERVICE       STATUS
artifactory            artifactory   Up About a minute (healthy)
artifactory-postgres   postgres      Up 2 minutes (healthy)
```

Оба контейнера находятся в статусе `Up`. Для API назначен адрес `127.0.0.1:8081`, для веб-интерфейса — `127.0.0.1:8082`.

<div><hr></div>

# Задание 1. Запуск стенда

**Что делаем:** поднимаем Artifactory из готового compose-файла.

**Зачем:** всё занятие проходит на этом стенде. Пока он не запущен,
дальше двигаться нельзя.

## Шаг 1. Проверьте, что Docker работает

Откройте терминал и выполните:

```bash
docker version
```

- Если видите версии клиента и сервера — всё хорошо.
- Если ошибка — запустите Docker Desktop (или `colima start`) и повторите.

## Шаг 2. Перейдите в корень репозитория

```bash
cd artifactory-lab-students
```

Убедитесь, что вы на месте — рядом должен лежать `docker-compose.yml`:

```bash
ls docker-compose.yml
```

## Шаг 3. Запустите стенд

```bash
docker compose up -d
```

Команда поднимет два контейнера: `artifactory` и `artifactory-postgres`
(Artifactory хранит свои данные в базе PostgreSQL — откройте
`docker-compose.yml` и найдите, как приложение узнаёт про базу:
переменные `JF_SHARED_DATABASE_*`).

## Шаг 4. Проверьте, что контейнеры запущены

```bash
docker compose ps
```

## Результат

В выводе две строки: `artifactory` и `artifactory-postgres`, статус `Up`.

**В отчёт:** вывод `docker compose ps`.

## Если не получилось

- `ports are not available` — порты 8081/8082 заняты. Скажите преподавателю
  или поменяйте левую часть портов в `docker-compose.yml` на `18081`/`18082`.
- Образ скачивается долго — это нормально, он ~1.5 ГБ.
