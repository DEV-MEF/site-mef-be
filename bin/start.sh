cd $(dirname "$0")/..
# cp templates/.env ./
APP_LOG=/var/log/app.log
CRON_LOG=/var/log/cron.log

touc "${APP_LOG}"
touc "${CRON_LOG}"

echo "#Syncronized cronjob table" > /etc/crontabs/root
cat /etc/cron.d/* >> /etc/crontabs/root
echo "" >> /etc/crontabs/root

crond
source bin/backup.sh

# Criar o arquivo de log

# Iniciar o Strapi em background e redirecionar a saída para o arquivo de log
npm run develop > "${APP_LOG}" 2>&1 &

# Manter o container ativo, exibindo o log com o tail
tail -f "${APP_LOG}" "${CRON_LOG}"
