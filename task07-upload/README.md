# Публикация артефакта myapp 1.0.0

## Подготовка и загрузка

Скопировал `myapp-1.0.0.tar.gz` из задания 6. Перед запуском задал `ARTIFACTORY_PASSWORD` в окружении. `upload.sh` передал пароль в `curl` через стандартный ввод и загрузил архив в репозиторий `myapp-local`.

## Ответ Artifactory

```text
$ ./upload.sh
{
  "repo" : "myapp-local",
  "path" : "/myapp/1.0.0/myapp-1.0.0.tar.gz",
  "created" : "2026-11-27T10:26:41.777Z",
  "createdBy" : "admin",
  "downloadUri" : "http://127.0.0.1:8081/artifactory/myapp-local/myapp/1.0.0/myapp-1.0.0.tar.gz",
  "mimeType" : "application/x-gzip",
  "size" : "358",
  "checksums" : {
    "sha1" : "10e5c0f43a73ad6a099aed6dec03a52dd83a2dce",
    "md5" : "9d4fde62485a3796eba743713f9d890c",
    "sha256" : "3705f873cdb68c6cd6ab894c9f57e87d2907b49201dd81e84ebb391d27f9a486"
  },
  "originalChecksums" : {
    "sha256" : "3705f873cdb68c6cd6ab894c9f57e87d2907b49201dd81e84ebb391d27f9a486"
  },
  "uri" : "http://127.0.0.1:8081/artifactory/myapp-local/myapp/1.0.0/myapp-1.0.0.tar.gz"
}
HTTP 201
```

Artifactory подтвердил загрузку кодом `HTTP 201`. Размер на сервере составил 358 байт, а значение `checksums.sha256` совпало с SHA-256 локального архива.

<div><hr></div>

# Задание 7. Публикация артефакта

**Что делаем:** загружаем архив в Artifactory готовым скриптом — нужно
только вписать пароль.

**Зачем:** это главное действие всей лабораторной — публикация (upload)
артефакта в хранилище.

## Шаг 1. Скопируйте архив из задания 6

```bash
cd ../task07-upload
cp ../task06-build-app/myapp-1.0.0.tar.gz .
```

## Шаг 2. Впишите пароль в скрипт

Откройте файл `upload.sh` в редакторе и ВПИШИТЕ свой пароль:

```bash
PASSWORD="____"
```

после знака `=` в кавычках вместо `____`.

## Шаг 3. Запустите скрипт

```bash
chmod +x upload.sh
./upload.sh
```

(`chmod +x` делает файл исполняемым — нужно один раз.)

## Шаг 4. Разберите ответ сервера

Если всё хорошо, придёт JSON, например:

```json
{
  "repo" : "myapp-local",
  "path" : "/myapp/1.0.0/myapp-1.0.0.tar.gz",
  "size" : "208",
  "checksums" : { "sha1" : "...", "md5" : "...", "sha256" : "..." }
}
```

Artifactory сам посчитал контрольные суммы при загрузке.

## Результат

Файл опубликован по адресу `myapp-local/myapp/1.0.0/`.

**В отчёт:** JSON из ответа сервера.

## Если не получилось

- `401` — неверный пароль в `upload.sh`;
- `404` — репозиторий не создан, вернитесь к заданию 4;
- `No such file` — забыли шаг 1 (архив не в этой папке).
