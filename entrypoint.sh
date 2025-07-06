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

INIT_FLAG="/var/lib/odoo/.initialized"

if [ ! -f "$INIT_FLAG" ]; then
    echo ">>> Configuración inicial de Odoo <<<"
    
    odoo --init=${MODULES_TO_INSTALL:-IMS} \
         --without-demo=all \
         --stop-after-init \
         --database=${DB_NAME:-odoo_main} \
         --admin-passwd="${MASTER_PASSWORD}" \
         --email="${ADMIN_EMAIL}" \
         --password="${ADMIN_PASSWORD}"

    touch "$INIT_FLAG"
fi

exec odoo "$@"