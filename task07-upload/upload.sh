#!/usr/bin/env bash
# upload.sh — публикация готового архива в Artifactory
set -o pipefail
: "${ARTIFACTORY_PASSWORD:?Задайте ARTIFACTORY_PASSWORD для локального Artifactory}"
VERSION="1.0.0"
ARCHIVE="myapp-$VERSION.tar.gz"

password=${ARTIFACTORY_PASSWORD//\\/\\\\}
password=${password//\"/\\\"}
password=${password//$'\n'/\\n}
password=${password//$'\r'/\\r}
# Передаём Basic Auth через stdin, чтобы пароль не оказался в аргументах curl.
printf 'user = "admin:%s"\n' "$password" |
  curl --config - --basic --noproxy '*' --fail-with-body --silent --show-error \
    --connect-timeout 3 --max-time 30 --upload-file "$ARCHIVE" \
    --write-out '%{stderr}HTTP %{http_code}\n' \
    "http://127.0.0.1:8081/artifactory/myapp-local/myapp/$VERSION/$ARCHIVE"
