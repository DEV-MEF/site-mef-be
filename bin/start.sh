cd $(dirname "$0")/..
# cp templates/.env ./
APP_LOG=/var/log/app.log
CRON_LOG=/var/log/cron.log

touch "${APP_LOG}"
touch "${CRON_LOG}"

echo "#Syncronized cronjob table" > /etc/crontabs/root
cat /etc/cron.d/* >> /etc/crontabs/root
echo "" >> /etc/crontabs/root

crond
source bin/backup.sh

# Criar o arquivo de log

APP_MODE_LC=$(echo "$APP_MODE" | tr '[:upper:]' '[:lower:]')

echo "USING MODE $ ${APP_MODE_LC}"
if [ "$APP_MODE_LC" = "test" ] || [ "$APP_MODE_LC" = "prod" ]; then
  echo "RUNNING BUILD VERSION"
  npm run start > "${APP_LOG}" 2>&1 &
else
  echo "RUNNING DEVELOP VERSION"
  npm run develop > "${APP_LOG}" 2>&1 &
fi

## Manter o container ativo, exibindo o log com o tail
tail -f "${APP_LOG}" "${CRON_LOG}"
