# Проверка готовности JFrog Artifactory

## Health endpoint

Запрос к `/router/api/v1/system/health` на локальном стенде вернул `HTTP 200`. В JSON роутер сообщил `HEALTHY`, все 9 обязательных сервисов также вернули `HEALTHY`.

```text
$ curl --noproxy '*' -fsS --connect-timeout 3 --max-time 10 \
    -w '\nHTTP %{http_code}\n' http://127.0.0.1:8082/router/api/v1/system/health
HTTP 200

Поля state и message объекта router
{
  "state": "HEALTHY",
  "message": "OK"
}
```

Полный ответ health endpoint записан в `results.txt`.

## Веб-интерфейс

Отдельный запрос к `/ui/` вернул `HTTP 200` и тип содержимого `text/html`.

```text
$ curl --noproxy '*' -fsS --connect-timeout 3 --max-time 10 -o /dev/null \
    -w 'HTTP %{http_code}\nContent-Type: %{content_type}\n' http://127.0.0.1:8082/ui/
HTTP 200
Content-Type: text/html; charset=utf-8
```

<div><hr></div>

# Задание 2. Ожидание готовности

**Что делаем:** ждём, пока Artifactory полностью запустится, и проверяем
это через health-endpoint.

**Зачем:** Artifactory — большое Java-приложение. Контейнер стартует за
секунды, а вот сам сервис внутри поднимается 3–7 минут (при первом запуске
создаётся схема базы данных). Учимся проверять готовность сервиса,
а не гадать.

## Шаг 1. Запросите статус

```bash
curl http://localhost:8082/router/api/v1/system/health
```

Возможные ответы:
- ошибка соединения или пусто — сервис ещё не слушает порт;
- код 503 — сервис слушает, но ещё инициализируется;
- код 200 и JSON со статусами — **готово**.

## Шаг 2. Повторяйте проверку

Раз в 30–60 секунд запускайте команду из шага 1, пока не придёт код 200.

Хотите видеть, что происходит внутри? Откройте второй терминал:

```bash
docker compose logs -f
```

(выйти — `Ctrl+C`, контейнеры продолжат работать).

## Шаг 3. Убедитесь, что UI отвечает

```bash
curl -o /dev/null -w "%{http_code}\n" http://localhost:8082/ui/
```

Должно быть `200`.

## Результат

Health-проверка возвращает 200, UI отдаёт 200.

**В отчёт:** вывод health-проверки с кодом 200.

> Такая проверка называется healthcheck. В настоящих системах её выполняет
> оркестратор (Kubernetes, Docker) автоматически — посмотрите блок
> `healthcheck` в `docker-compose.yml`.
