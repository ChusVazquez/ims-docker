# Partimos de la imagen oficial de Odoo 18 para Docker
FROM odoo:18.0

USER root

#Instalar dependencias
RUN apt-get update && \
    apt-get install -y \
        python3-debugpy \
        python3-lxml \
        python3-lxml-html-clean \
        python3-phonenumbers \
        git \
        xfonts-base \
        fontconfig \
        wget \
        && \
    #Paquetes .deb
    wget http://es.archive.ubuntu.com/ubuntu/pool/universe/x/xfonts-75dpi/xfonts-75dpi_1.0.4+nmu1.1_all.deb -O /tmp/xfonts-75dpi.deb && \
    dpkg -i /tmp/xfonts-75dpi.deb && \
    wget http://launchpadlibrarian.net/668074287/libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb -O /tmp/libssl1.1.deb && \
    dpkg -i /tmp/libssl1.1.deb && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb -O /tmp/wkhtmltox.deb && \
    dpkg -i /tmp/wkhtmltox.deb && \
    #Limpieza
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*.deb

#Clonar el repo
#TODO ¿permitir configurarlas también en el secrets?
ARG REPO_URL=https://github.com/ElPuig/IMS.git
ARG REPO_BRANCH=fer-dev

RUN git clone ${REPO_URL} --branch ${REPO_BRANCH} /mnt/extra-addons/IMS && \
    chown -R odoo:odoo /mnt/extra-addons/IMS

#Copiar los scripts
COPY entrypoint.sh /entrypoint.sh
COPY init-odoo.sh /init-odoo.sh

RUN chmod +x /entrypoint.sh && \
    chmod +x /init-odoo.sh && \
    mkdir -p /etc/odoo && \
    chown odoo:odoo /etc/odoo

USER odoo

ENTRYPOINT ["/entrypoint.sh"]