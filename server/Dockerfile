# Используем официальный Python + Node.js образ
FROM python:3.12-slim

# Установим Node.js
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y openssl && \
    apt-get clean

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем весь проект в контейнер
COPY . .

# Установим зависимости Python
RUN pip install --no-cache-dir grpcio grpcio-tools pyyaml psycopg2-binary

# Открываем порт для gRPC
EXPOSE 20000

# Запускаем сервер
CMD ["python", "server.py"]
