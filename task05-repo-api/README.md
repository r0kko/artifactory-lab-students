# Список репозиториев Artifactory через REST API

## Запрос списка

Отправил `GET /artifactory/api/repositories` на `127.0.0.1:8081` с Basic Auth пользователя `admin`. Параметры входа переданы через стандартный ввод с помощью `curl --config -`.

```text
$ curl --config - --basic --noproxy '*' -fsS --connect-timeout 3 --max-time 10 \
    -w '\nHTTP %{http_code}\n' http://127.0.0.1:8081/artifactory/api/repositories
[ {
  "key" : "example-repo-local",
  "description" : "Example artifactory repository",
  "type" : "LOCAL",
  "url" : "http://127.0.0.1:8081/artifactory/example-repo-local",
  "packageType" : "Generic"
}, {
  "key" : "myapp-local",
  "description" : "",
  "type" : "LOCAL",
  "url" : "http://127.0.0.1:8081/artifactory/myapp-local",
  "packageType" : "Generic"
} ]
HTTP 200
```

## Проверка результата

API вернул `HTTP 200` и список из 2 репозиториев. В записи `myapp-local` поле `type` равно `LOCAL`, а `packageType` равно `Generic`.

<div><hr></div>

# Задание 5. Список репозиториев через API

**Что делаем:** первый запрос к REST API — проверяем из терминала,
что репозиторий создан.

**Зачем:** всё, что делается мышкой в интерфейсе, можно сделать из
командной строки — а значит, автоматизировать.

## Шаг 1. Выполните запрос

ВПИШИТЕ свой пароль вместо `____` (после двоеточия, без пробела):

```bash
curl -u admin:____ http://localhost:8081/artifactory/api/repositories
```

Разбор команды:
- `curl` — программа для HTTP-запросов;
- `-u admin:пароль` — логин и пароль (Basic Auth);
- дальше — адрес API.

## Шаг 2. Разберите ответ

Придёт JSON-список. Найдите в нём блок своего репозитория:

```json
{
  "key" : "myapp-local",
  "type" : "LOCAL",
  "packageType" : "Generic"
}
```

## Шаг 3 (по желанию). Попробуйте создать репозиторий через API

```bash
curl -u admin:ВАШ_ПАРОЛЬ -X PUT \
  -H "Content-Type: application/json" \
  -d '{"rclass": "local", "packageType": "generic"}' \
  http://localhost:8081/artifactory/api/repositories/test-api-local
```

Вы получите ответ `This REST API is available only in Artifactory Pro`.
Это **не ошибка**: в бесплатной версии управлять репозиториями можно только
через интерфейс, а работать с файлами — и через API (что мы и будем делать).

## Результат

В списке репозиториев есть `myapp-local`.

**В отчёт:** вывод команды из шага 1.

## Если не получилось

- `401 Unauthorized` — неверный пароль (нужен тот, что задан в задании 3).
- `000` / нет соединения — стенд не запущен, вернитесь к заданию 1.
