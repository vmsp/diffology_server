# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"

  config.vm.network "forwarded_port", guest: 80, host: 4000
  # config.vm.network "private_network", type: "dhcp"

  # config.vm.synced_folder ".", "/vagrant", disabled: true
  # config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "file", source: "./box/nginx_development.conf", destination: "/tmp/nginx_development.conf"

  config.vm.provision "file", source: "~/.bashrc",    destination: "~/.bashrc"
  config.vm.provision "file", source: "~/.tmux.conf", destination: "~/.tmux.conf"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get install -y \
      curl \
      gnupg2

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    apt-get update && apt-get install -y \
      build-essential \
      fcgiwrap \
      git \
      liblzma-dev \
      libpq-dev \
      nginx-light \
      nodejs \
      patch \
      postgresql \
      ruby \
      ruby-dev \
      tmux \
      yarn \
      zlib1g-dev

    rm /etc/nginx/sites-enabled/default

    sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
    sed -i 's/sendfile on/sendfile off/g' /etc/nginx/nginx.conf

    mv /tmp/nginx_development.conf /etc/nginx/sites-enabled/diffology.com.conf
    systemctl reload-or-restart nginx

    systemctl enable nginx
    systemctl enable fcgiwrap

    mkdir -p /var/www/repos
    chown vagrant:vagrant /var/www/repos

    gem install bundler:2.0.2

    sudo -u postgres createuser -s vagrant

    # cd /vagrant
    # bundle

    # bin/rails db:create
    # bin/rails db:migrate
    # bin/rails s
  SHELL
end
