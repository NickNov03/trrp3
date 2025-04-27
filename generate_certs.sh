#!/bin/bash

# Создание директории
mkdir -p certs
cd certs

echo "Генерируем ключ CA..."
openssl genrsa -out ca.key 4096

echo "Генерируем сертификат CA..."
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 -out ca.crt \
  -subj "/CN=Test CA"

echo "Генерируем ключ сервера..."
openssl genrsa -out server.key 4096

echo "Генерируем запрос на сертификат сервера..."
openssl req -new -key server.key -out server.csr \
  -subj "/CN=89.169.36.129"

echo "Подписываем сертификат сервера сертификатом CA..."
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256

echo "Генерируем ключ клиента..."
openssl genrsa -out client.key 4096

echo "Генерируем запрос на сертификат клиента..."
openssl req -new -key client.key -out client.csr \
  -subj "/CN=client"

echo "Подписываем сертификат клиента сертификатом CA..."
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out client.crt -days 365 -sha256

# Удаляем временные файлы CSR
rm server.csr
rm client.csr

echo "Готово! Сертификаты находятся в папке certs/"
