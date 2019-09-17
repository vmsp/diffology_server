#!/bin/sh

set -eux

# These packaged need to be installed first for the directories below to exist.
apt-get update
apt-get install -y \
        curl \
        gnupg2 \
        nginx-light

# This is needed so that the `deploy` user, used by capistrano, can successfully
# restart the enumerated services without a password input.
cat > /etc/sudoers.d/deploy <<'EOF'
%deploy ALL=NOPASSWD: /usr/bin/systemctl reload-or-restart nginx
%deploy ALL=NOPASSWD: /usr/bin/systemctl reload-or-restart puma.service
%deploy ALL=NOPASSWD: /usr/bin/systemctl stop puma.service
%deploy ALL=NOPASSWD: /usr/bin/systemctl start puma.service
EOF

# This configuration expects the app to follow Capistrano's default directory
# structure.
cat > /etc/nginx/sites-enabled/diffology.com.conf <<'EOF'
upstream app {
    server unix:/var/www/diffology/shared/tmp/sockets/puma.sock;
}

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/diffology/current/public;

    access_log /var/www/diffology/shared/log/nginx.access.log;
    error_log  /var/www/diffology/shared/log/nginx.error.log;

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
    }

    location = /authorization {
        # internal;

        proxy_pass http://app/authorization;
        proxy_pass_request_body off;

        proxy_set_header Content-Length "";
        proxy_set_header X-Original-URI $request_uri;
    }

    location ~ /repos(/.*) {
        gzip off;
        client_max_body_size 0;

        auth_request /authorization;

        fastcgi_pass unix:/run/fcgiwrap.socket;

        fastcgi_param SCRIPT_FILENAME /usr/lib/git-core/git-http-backend;
        fastcgi_param GIT_HTTP_EXPORT_ALL "";
        fastcgi_param GIT_PROJECT_ROOT /var/www/repos;
        fastcgi_param REMOTE_USER $remote_user;
        fastcgi_param PATH_INFO $1;
        include /etc/nginx/fastcgi_params;
    }

    error_page 500 502 503 504 /500.html;
}
EOF

# TODO(vitor): Remove RAILS_MASTER_KEY
cat > /etc/systemd/system/puma.service <<'EOF'
[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/diffology/current
ExecStart=/usr/local/bin/bundle exec puma -C /var/www/diffology/current/config/puma/production.rb /var/www/diffology/current/config.ru
Restart=always

Environment=RAILS_ENV=production
Environment=RAILS_MASTER_KEY=22abbdd3a37acabac54d655766aa3a1e

[Install]
WantedBy=multi-user.target
EOF

adduser deploy  # INTERACTIVE
adduser deploy sudo

# APT

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update
apt-get install -y \
        acl \
        build-essential \
        fcgiwrap \
        git \
        liblzma-dev \
        libpq-dev \
        nodejs \
        patch \
        postgresql \
        ruby \
        ruby-dev \
        tmux \
        yarn \
        zlib1g-dev

# Nginx

rm -f /etc/nginx/sites-enabled/default

# Dirs

mkdir -p /var/www/repos
mkdir -p /var/www/diffology

chown www-data:www-data /var/www/repos
chown deploy:deploy /var/www/diffology

# Postgres

if ! psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='www-data'"; then
  # TODO(vitor): Check default user permissions
  sudo -u postgres createuser -s deploy
  sudo -u postgres createuser -s www-data
  sudo -u postgres createdb -O www-data diffology_production
fi

# SystemD

systemctl daemon-reload

systemctl enable nginx
systemctl enable fcgiwrap
systemctl enable puma.service

systemctl reload-or-restart nginx
systemctl reload-or-restart puma.service

# Ruby

gem install bundler
