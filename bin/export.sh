#!/bin/bash
BACKUP_HOME="/backups"
BACKUP_SOURCES="${BACKUP_HOME}/apps-${PROJECT:-dev}/sources"

# Configurações
mkdir -p "${BACKUP_SOURCES}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_SOURCES}/backup_source_${TIMESTAMP}.tar.gz"
LATEST="${BACKUP_SOURCES}/${PROJECT}-latest.tar.gz"

echo "📌 Iniciando backup do source file..."

tar -cv -C /opt/app \
    src public/uploads database config types \
    | gzip -9 > "${BACKUP_FILE}"

tar -cv -C /opt/app \
    src public/uploads database config types \
    | gzip -9 > "${LATEST}"


echo "✅ Backup de source salvo em ${BACKUP_FILE}"

# Remove backups locais mais antigos (mantém apenas os últimos 7 dias)
find "${BACKUP_SOURCES}" -type f -name "backup_source_*.sql.gz" -mtime "+${BACKUP_KEEPFILES:-15}" -exec rm {} \;

