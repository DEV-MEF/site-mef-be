#!/bin/bash
BACKUP_HOME="/backups"
BACKUP_SOURCES="${BACKUP_HOME}/apps-${PROJECT:-dev}/sources"

# Configurações
mkdir -p "${BACKUP_SOURCES}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LATEST="${BACKUP_SOURCES}/${PROJECT}-latest.tar.gz"
BACKUP_FILE="${BACKUP_SOURCES}/backup_source_${TIMESTAMP}.tar.gz"
BACKUP_FOREVER="${BACKUP_SOURCES}/forever_source_${TIMESTAMP}.tar.gz"


echo "📌 Iniciando backup do source file..."
echo "📌 Backup sendo executado no modo $1"

# Efetua o dump apenas se não houver argumentos ou se o primeiro for "backup"
if [ $# -eq 0 ] || [ "$1" = "latest" ]; then
    echo "🔄 Executando backup latest..."

    tar -cv -C /opt/app \
        src public/uploads database config types \
        | gzip -9 > "${LATEST}"

    echo "✅ Backup salvo em ${BACKUP_FILE}"
else
    echo "⚠️ Argumento recebido ($1) não exige backup latest. Backup latest não foi efetuado."
fi


# Efetua o dump apenas se não houver argumentos ou se o primeiro for "backup"
if [ $# -eq 0 ] || [ "$1" = "persistent" ]; then
    echo "🔄 Executando backup persistente..."

    tar -cv -C /opt/app \
        src public/uploads database config types \
        | gzip -9 > "${BACKUP_FILE}"
        echo "✅ Backup salvo em ${BACKUP_FILE}"
else
    echo "⚠️ Argumento recebido ($1) não exige backup persistente. Backup persistente não foi efetuado."
fi


# Efetua o dump apenas se não houver argumentos ou se o primeiro for "backup"
if [ "$1" = "forever" ]; then
    echo "🔄 Executando backup Permanente..."

    tar -cv -C /opt/app \
        src public/uploads database config types \
        | gzip -9 > "${BACKUP_FOREVER}"

    echo "✅ Backup salvo em ${BACKUP_FOREVER}"
else
    echo "⚠️ Argumento recebido ($1) não exige backup forever. Backup forever não foi efetuado."
fi


echo "✅ Backup de source salvo em ${BACKUP_FILE}"

# Remove backups locais mais antigos (mantém apenas os últimos 7 dias)
find "${BACKUP_SOURCES}" -type f -name "backup_source_*.sql.gz" -mtime "+${BACKUP_KEEPFILES:-15}" -exec rm {} \;

