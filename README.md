# GithubParser
Сервис, который хранит и обновляет список трендовых репозиториев на Github

# Requirements
* docker (tested on 19.03.12)
* docker-compose (tested on 1.25.3)
* elixir (tested on 1.10)
* erlang (tested on 22.3)
* nodejs (tested on 8.10.0)
* python3 (testd on 3.6.9)

# Запуск

Для запуска сервиса необходимо выполнить команду:
```
make docker-run
```
SPA и API доступны по адресу: `http://localhost:4000/`

## Github token
Github ограничивает RPS для неавторизованных пользователей.
Поэтому для корректной работы необходимо указать свой токен.
Сделать это можно в файле `docker-compose.yml`, добавив его в это место:
```
  github_parser:
    image: github_parser:staging
    environment:
      CREATE_DB_ON_INIT: 1
      DB_HOST: postgres
      DB_USER: postgres
      DB_PASS: postgres
      DB_NAME: github_parser
      GITHUB_TOKEN: *YOUR_TOKEN*
```

# Тесты

Для запуска тестов необходимо выполнить команду:
```
make test-docker
```

# CLI Client
Для работы с CLI клиентом необходим `python3`. 

## Подготовка
Перед запуском необходимо перейти в директорию `/cli` и выполнить команду:
```
python3 -m pip install -r requirements.txt
```

## Получение всех репозиториев
```
python3 ./parser_client.py getRepos
```

## Получить репозиторий по id или title
```
python3 ./parser_client.py getRepoBy -q *id_or_title*
```

## Запустить принудительное обновление списка репозиториев
```
python3 ./parser_client.py updateRepos
```