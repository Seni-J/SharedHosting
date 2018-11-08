echo "Enter the new username : "
read username

echo "Enter the domain name for this site : "
read domain

echo "Enter the new username password : "
read -s password

echo "Enter the actual mysql root password : "
read -s rootpwd

# ajoute un utilisateur
adduser --disabled-password --gecos "" $username
echo $username":"$password|chpasswd

# Add little php homepage on the future user repertory
echo "Configuration du site"
mkdir -p /var/www/$domain/html

echo "Ajout d'une page internet"
touch /var/www/$domain/html/index.php
cat > /var/www/$domain/html/index.php <<TEXTBLOCK
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
chmod 770 /home/$username

# create php pool
echo "- Configuring php pool"
touch /etc/php/7.0/fpm/pool.d/$username.conf
cat > /etc/php/7.0/fpm/pool.d/$username.conf <<TEXTBLOCK
[$domain]
user = $username
group = $username
listen = /run/php/php7.0-fpm-$username.sock
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
    listen 80 ;
    listen [::]:80 ;

    root /var/www/$username/html;

    # Add index.php to the list if you are using PHP
    index index.html index.htm index.php;

    server_name $domain;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
    	include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm-$username.sock;
    }
}
TEXTBLOCK

# enable the new site
ln -s /etc/nginx/sites-available/$username.conf /etc/nginx/sites-enabled/

# utilisateur mariaDB
echo "- Creating Database"
mysql -uroot -proot <<EOF
CREATE DATABASE db_$username;
CREATE USER '$username'@'%' IDENTIFIED BY '$password';
GRANT ALL privileges on db_$username.* to '$username'@'%' identified by '$password';
FLUSH privileges;
EOF

#echo "- Creating database"
#echo "CREATE DATABASE DB_"$username";" > /tmp.sql
#echo "GRANT ALL privileges on nomDB.* to "$username"@'localhost' identified by "$password";" >> /tmp.sql

#mysql -u "root" -p $rootpwd < /tmp.sql

# bloquer accès au home aux autres utilisateurs
chmod 700 /home/$username

# bloquer accès au répertoire du site aux autres utilisateurs
chmod 711 /var/www/$domain

# assigner l'utilisateur à son home
chown $username:$username /home/$username

# assigner le site à l'utilisateur
chown $username:$username /var/www/$domain

# permet à l'utilisateur de modier le contenu de son
chmod 751 /var/www/$domain/html/

# affiche la page internet de l'utilisateur
chmod 640 /var/www/$domain/html/*

# ajout du groupe pour les autres utilisateurs puissent voir le site
chgrp www-data /var/www/$domain/html/*

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

