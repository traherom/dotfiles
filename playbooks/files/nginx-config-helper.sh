#!/bin/bash
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo
    echo "If /etc/letsencrypt/live/<domain>/cert.pem exists, use the <domain>.conf file"
    echo "in the given dotfiles/system/nginx/sites-available/ directory. "
    echo "Otherwise, use bootstrap.conf from the same directory." 
    exit 1
fi

domain="$1"

nginx_dotfiles_base=$(realpath "$dir/../../dotfiles/system/nginx/")
bootstrap_conf="$nginx_dotfiles_base/sites-available/bootstrap.conf"
available_conf="$nginx_dotfiles_base/sites-available/$domain.conf"
live_conf="/etc/nginx/sites-enabled/$domain.conf"
certbot_certs="/etc/letsencrypt/live/$domain/cert.pem"

if [ ! -e "$available_conf" ]; then
    echo "$available_conf does not exist but it was requested for nginx configuration"
    exit 2
fi

# Link up base config
echo "Linking base nginx config"
bash "$dir/linker.sh" "$nginx_dotfiles_base/nginx.conf" "/etc/nginx/nginx.conf" || exit 1
rm -f /etc/nginx/sites-enabled/default

# Register with LE if needed
if [ ! -f /etc/letsencrypt/.registered ]; then
    echo "Registering with Let's Encrypt for $domain"
    certbot -n register --agree-tos --email ryan@moreharts.com || exit 1
    touch /etc/letsencrypt/.registered || exit 1
fi

if [ ! -e "$certbot_certs" ]; then
    echo "Certificates not found, generating and using bootstrap config"
    cat "$bootstrap_conf" | sed "s/DOMAIN/$domain/" >"$live_conf" 
    systemctl restart nginx || exit 1
    sleep 5

    # Get initial cert
    echo "Generating initial certificate for $domain"
    certbot -n --nginx certonly -d "$domain" || exit 1
fi

echo "Certificates in place, using live config"
cp "$available_conf" "$live_conf" || exit 1
systemctl restart nginx || exit 1

# Enable automatic renewal
if ! grep certbot crontab -l; then
    echo "Adding crontab entry"
    (crontab -l ; echo "0 14 * * * /bin/bash -lc 'certbot -q renew'")| crontab -
fi