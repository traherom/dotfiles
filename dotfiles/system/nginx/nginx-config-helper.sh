#!/bin/bash
dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$dir" || exit 1

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo
    echo "If /etc/letsencrypt/live/<domain>/cert.pem exists, use the <domain>.conf file"
    echo "in the given dotfiles/system/nginx/sites-available/ directory. "
    echo "Otherwise, use bootstrap.conf from the same directory." 
    exit 1
fi

domain="$1"

# test_flag=--test-cert

src_bootstrap_conf="$dir/sites-available/letsencrypt-bootstrap.conf"
src_full_conf="$dir/sites-available/$domain.conf"
live_bootstrap_conf="/etc/nginx/sites-enabled/letsencrypt-bootstrap.conf"
live_full_conf="/etc/nginx/sites-enabled/$domain.conf"
certbot_certs="/etc/letsencrypt/live/$domain/cert.pem"

if [ ! -e "$src_full_conf" ]; then
    echo "$src_full_conf does not exist but it was requested for nginx configuration"
    exit 2
fi

# Link up base config
echo "Copying base nginx config"
cp nginx.conf /etc/nginx/nginx.conf || exit 1
rm -f /etc/nginx/sites-enabled/default

# Register with LE if needed
if [ ! -f /etc/letsencrypt/.registered$test_flag ]; then
    echo "Registering with Let's Encrypt for $domain"
    certbot -n register $test_flag --agree-tos --email ryan@moreharts.com || exit 1
    touch /etc/letsencrypt/.registered || exit 1
fi

if [ ! -e "$certbot_certs" ]; then
    echo "Certificates not found"
    cp "$src_bootstrap_conf" "$live_bootstrap_conf" || exit 1
    systemctl restart nginx || exit 1
    sleep 5

    # Get initial cert
    echo "Generating initial certificate for $domain"
    certbot -n --nginx certonly $test_flag -d "$domain" || exit 1
fi

echo "Certificates in place, using live config"
cp "$src_full_conf" "$live_full_conf" || exit 1
systemctl restart nginx || exit 1

# Enable automatic renewal
if ! grep certbot crontab -l; then
    echo "Adding crontab entry"
    (crontab -l ; echo "22 14 * * * /bin/bash -lc 'certbot -q renew'")| crontab -
fi

exit 0