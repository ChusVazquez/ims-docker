#!/bin/bash
SECRETS_FILE="./.odoo-secrets.env"

echo ">>> Configuración interactiva de IMS en Docker <<<"
echo "Indroducir el valor o dejar valor por defecto entre []"

read -p "Usuario PostgreSQL [odoo]: " DB_USER
read -sp "Password PostgreSQL [odoo]: " DB_PASSWORD
echo
read -sp "Master Password Odoo [IMSMasterPassword]: " MASTER_PASSWORD
echo
read -p "Email administrador [admin@ims.dev]: " ADMIN_EMAIL
read -sp "Password administrador [IMSAdminPassword]: " ADMIN_PASSWORD
echo

#Guardar valores en .odoo-secrets.env
cat > "$SECRETS_FILE" <<EOF
DB_USER=${DB_USER:-odoo}
DB_PASSWORD=${DB_PASSWORD:-odoo}
MASTER_PASSWORD=${MASTER_PASSWORD:-IMSMasterPassword}
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@ims.dev}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-IMSAdminPassword}
EOF

echo "Configuración guardada en: $SECRETS_FILE"

chmod 644 .odoo-secrets.env  #Restricción de permisos en el secrets

#Levantar contenedores
docker compose up -d