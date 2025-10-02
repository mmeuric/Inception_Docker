#!/bin/bash
# **************************************************************************** #
#                               Inception tester                               #
# **************************************************************************** #

# 🔧 Paramètres
LOGIN="mmeuric"   # ton login 42
DOMAIN="${LOGIN}.42.fr"
COMPOSE_FILE="srcs/docker-compose.yml"
DATA_DIR="/home/${USER}/data"

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "\n${YELLOW}🔎 Vérification des conteneurs...${RESET}"
docker compose -f $COMPOSE_FILE ps

echo -e "\n${YELLOW}🔎 Vérification des volumes...${RESET}"
docker volume ls

for v in mariadb_volume wordpress_volume; do
    echo -e "\n➡️ Inspecting volume: $v"
    docker volume inspect $v | grep "Mountpoint"
done

echo -e "\n${YELLOW}🔎 Vérification des chemins locaux...${RESET}"
for d in mariadb wordpress static_html adminer; do
    if [ -d "$DATA_DIR/$d" ]; then
        echo -e "✅ $DATA_DIR/$d existe"
    else
        echo -e "❌ $DATA_DIR/$d manquant"
    fi
done

echo -e "\n${YELLOW}🔎 Test accès HTTP (80) -> doit échouer...${RESET}"
if curl -s -o /dev/null -w "%{http_code}" http://$DOMAIN | grep -q "000"; then
    echo -e "${GREEN}✅ Port 80 bloqué (attendu)${RESET}"
else
    echo -e "${RED}❌ Port 80 accessible, mauvaise config !${RESET}"
fi

echo -e "\n${YELLOW}🔎 Test accès HTTPS (443)...${RESET}"
curl -k -I https://$DOMAIN 2>/dev/null | head -n 5

echo -e "\n${YELLOW}🔎 Vérification certificat SSL (TLS 1.2/1.3)...${RESET}"
echo | openssl s_client -connect ${DOMAIN}:443 -servername ${DOMAIN} 2>/dev/null | \
    openssl x509 -noout -text | grep -E "TLSv1.3|TLSv1.2" || \
    echo -e "${RED}❌ Aucun TLS v1.2/v1.3 détecté${RESET}"

echo -e "\n${YELLOW}🔎 Vérification WordPress via PHP-FPM...${RESET}"
docker exec wordpress php -v || echo -e "${RED}❌ WordPress non accessible${RESET}"

echo -e "\n${YELLOW}🔎 Vérification MariaDB...${RESET}"
docker exec mariadb mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" || \
    echo -e "${RED}❌ Impossible d’accéder à MariaDB${RESET}"

echo -e "\n${GREEN}✅ Tests terminés.${RESET}"
echo -e "⚠️  Vérifie manuellement dans ton navigateur : https://${DOMAIN}\n"
