#!/bin/bash
set -e

# Cargar variables desde el archivo de secrets
if [ -f "/etc/odoo/.odoo-secrets.env" ]; then
    source /etc/odoo/.odoo-secrets.env
else
    echo "ERROR: El archivo de configuración no existe."
    echo "Ejecuta en tu HOST: ./init-odoo.sh"
    exit 1
fi

#Comprobar que psql está listo (usando netcat, investigar si hay un método mejor)
echo "Esperando a PostgreSQL en $HOST:5432..."
while ! nc -z $HOST 5432; do
  sleep 0.5
done
echo "PostgreSQL está listo!"

INIT_FLAG="/var/lib/odoo/.initialized"

if [ ! -f "$INIT_FLAG" ]; then
    echo "Configurando IMS en Odoo..."
    
    # odoo --init=${MODULES_TO_INSTALL:-IMS} \
    #      --without-demo=all \
    #      --stop-after-init \
    #      --database=${DB_NAME:-odoo_main} \
    #      --admin-passwd="${MASTER_PASSWORD}" \
    #      --email="${ADMIN_EMAIL}" \
    #      --password="${ADMIN_PASSWORD}"

    # odoo -d ${DB_NAME:-ims} \
    #      --init=${MODULES_TO_INSTALL:-ims} \
    #      --without-demo=all \        
    #      --stop-after-init

    # echo "odoo -d ims --stop-after-init -i ims -c /etc/odoo/odoo.conf --without-demo=WITHOUT_DEMO"

    # odoo --db_host="postgres" -d ims --stop-after-init -i IMS -c /etc/odoo/odoo.conf --without-demo=WITHOUT_DEMO 

    odoo --db_host="postgres" \
    --db_user="odoo" \
    --db_password="odoo" \
    -d ims \
    --stop-after-init \
    -i IMS \
    --without-demo=WITHOUT_DEMO

    touch "$INIT_FLAG"
fi

exec odoo "$@"