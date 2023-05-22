# 1. Качаем бинарный файлик и кладем его в /usr/local/bin

$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 2. Даем права на выполнение бинарного файла

$ sudo chmod +x /usr/local/bin/docker-compose
