echo "Enter the new username : "
read username

echo "Enter the domain name for this site : "
read domain

echo "Enter the new username password : "
read -s password

echo "Enter the actual mysql root password : "
read -s rootpwd

read -p "Are you sure (y/n) ? " -n 1 -r


# ajoute un utilisateur
adduser --disabled-password --gecos "" $username
echo $username":"$password|chpasswd

# Add little php homepage on the future user repertory
echo "Configuration du site"
mkdir /var/www/$username/html

echo "Ajout d'une page internet"
touch /var/www/$username/html/index.php
cat > /var/www/$username/html/index.php <<TEXTBLOCK
<div style="text-align: center;">
  <h1>Welcome to our new website !</h1>
  <h3>domain: $domain // username: $username</h3>
  <hr>
</div>

<?php
  phpinfo();
TEXTBLOCK


# Configure rights for the user
echo "- Configuring user rights"
chown -R $username:$username /home/$username
chmod -R 770 /home/$username

# create php pool
echo "- Configuring php pool"
touch /etc/php/7.0/fpm/pool.d/$username.conf
cat > /etc/php/7.0/fpm/pool.d/$username.conf <<TEXTBLOCK
[$username.com]
user = $username
group = $username
listen = /var/run/php7.0-fpm-$username.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru
php_admin_flag[allow_url_fopen] = off
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /
TEXTBLOCK

# config nginx
echo "- Configuring nginx"
touch /etc/nginx/sites-available/$username.conf
cat > /etc/nginx/sites-available/$username.conf <<TEXTBLOCK
server {
  listen 80;

  server_name $domain.com;

  root /var/www/$username/html;
  index index.php index.html;

  location / {
    try_files \$uri \$uri/ /index.php;
  }

  location ~ \.php$ {
    try_files \$uri =404;
    fastcgi_index index.php;
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php7.0-fpm-$username.sock;
  }
}
TEXTBLOCK

# enable the new site
ln -s /etc/nginx/sites-available/$username.conf /etc/nginx/sites-enabled/

# utilisateur mariaDB
echo "- Creating database"
echo "CREATE DATABASE DB_"$username";" > /tmp.sql
echo "GRANT ALL ON DB_"$username".* TO "$username"@localhost IDENTIFIED BY '"$password"';" >> /tmp.sql

mysql -u "root" -p$rootpwd < /tmp.sql

# Restart nginx/php
echo "- Reloading configs"
service nginx reload
service php7.0-fpm reload
echo "- Config reloaded"

# Little sucess message
echo -e "\033[1;32m"
cat <<TEXTBLOCK
--------------------------------------------------------------
                  User sucessfuly created !
                         Enjoy your work !
--------------------------------------------------------------
                    Username : $username
                    Password : ***
                 Domain Name : $domain
                SQL Database : DB_$username

     You can use your identifiers to copy files into your
            dedicated repertory with CP over SSH
--------------------------------------------------------------
TEXTBLOCK
echo -e "\033[0m"

fi
