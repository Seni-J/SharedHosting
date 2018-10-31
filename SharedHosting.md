# SharedHosting 

### Par Senistan Jegarajasingam et Jérémy Gfeller 

## Installation VMware Workstation

  - File → New → Virtual Machine
  - Virtual Machine Configuration → Custom (advanced)
  - Hardware compatibility → Workstation *[dernière version]*
  - Install operating system from → I will install the operating system later
  - Guest Operating System → 2. Linux → Debian *[dernière version]* 64-bit
  - Name → *sharedhosting*
  - Number of processors → 1
  - Memory → 512 MB
  - Network Connection → Use network address translation (NAT)
  - I/O Controller Types → LSI Logic (Recommended)
  - Virtual Disk Type → SCSI (Recommended)
  - Disk → Create a new virtual disk
  - Disk Size → Maximum disk size (in GB) → 30.0
      - Store virtual disk as a single file
  - Disk File → *sharedhosting*.vmdk
  - Customize Hardware
    - Enlever → USB Controller
    - Enlever → Sound Card
    - Enlever → Printer
    - New CD/DVD (IDE) → Use ISO image → *[image ISO d'installation de DEBIAN]*

### Installation linux

- Lancer la VM → Install 
- Sélectionner Français →  Suisse →  Suisse romand
- Nom de la machine : SharedHost 
- Domaine : -
- Mot de passe root : *[au choix de l'admin]*
- Nom complet du nouvel utilisateur : *[au choix de l'admin]*
- Identifiant pour le compte : *[au choix de l'admin]*
- Mot de passe de l'utilisateur : *[au choix de l'admin]*

### Partition des disques 

- Sélectionnez **Manuel** puis sur **Enter** pour continuer 
- Sélectionner le disque **SCSI1** puis sur **Enter** pour continuer 
- Fait-il créer une nouvelle table des partitions sur ce disque ? Sélectionnez **OUI** et appuyez sur **Entrée** pour continuer.

### Création de la partition SWAP

- Sélectionnez **Espace libre** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Créer une nouvelle partition** et appuyez sur **Entrée** pour continuer.
- Entrez la valeur **512M** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Primaire** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Début** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Utiliser comme** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **espace d'échange (swap)** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Fin du paramétrage de cette partition** et appuyez sur **Entrée** pour continuer.

### Création de la partition / (racine)

- Sélectionnez **Espace libre** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Créer une nouvelle partition** et appuyez sur **Entrée** pour continuer.
- Entrez la valeur **10 GB** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Primaire** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Début** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Utiliser comme** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **système de fichiers journalisés ext4** et appuyez sur **Entrée** pour continuer.
- Contrôlez la valeur **Point de montage** soit égale à **/**
- Sélectionnez **Indicateur d'amorçage** et appuyez sur **Entrée**. La valeur va passer à présent.
- Sélectionnez **Fin du paramétrage de cette partition** et appuyez sur **Entrée** pour continuer.

### Création de la partition /home

- Sélectionnez **Espace libre** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Créer une nouvelle partition** et appuyez sur **Entrée** pour continuer.
- Laissez la valeur proposée et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Primaire** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Utiliser comme** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **système de fichiers journalisés ext4** et appuyez sur **Entrée** pour continuer.
- Contrôlez la valeur **Point de montage** soit égale à **/home**
- Sélectionnez **Fin du paramétrage de cette partition** et appuyez sur **Entrée** pour continuer.
- Sélectionnez **Terminer le partitionnement et appliquer les changements** et appuyez sur **Entrée** pour continuer.
- Faut-il appliquer les changements sur les disques ? Sélectionnez **Oui** et appuyez sur **Entrée** pour continuer.

### Installation

- Sélectionnez **Fin du paramétrage de cette partition** et appuyez sur **Entrée** pour continuer.
- Faut-il analyser un autre CD ou DVD? Sélectionnez **Non** et appuyez sur **Entrée** pour continuer.
- Faut-il continuer sans miroir sur le réseau ? Sélectionnez **Oui** et appuyez sur **Entrée** pour continuer. Nous le configurons plus tard.
- Souhaitez-vous participer à l'étude statistique ? Sélectionnez **Non** et appuyez sur **Entrée** pour continuer. Nous le configurons plus tard.
- À l'aide de la **barre d'espace** désélectionnez. Appuyez sur **Entrée** pour continuer
- Installer le programme de démarrage GRUB ? Sélectionnez **Oui** et sélectionnez **/dev/sda**
- Terminer l'installation, cliquer sur **continuer**

## Configuration de Debian 

### Installation des packages 

#### Commande à taper 

- Editer le fichier pour modifier la connexion au serveur pour les téléchargements des paquets 

> nano /etc/apt/sources.list

- Rajouter cette ligne dans le fichier et mettre en commentaire toutes les autres avec un "#"

> deb http://debian.ethz.ch/debian stable main contrib non-free

- Mettre à jour le dépôt

> apt-get update && apt-get upgrade

- Installation de sudo 

> apt-get install sudo 

- Configurer le fichier sudoers en étant connecté avec root

>nano /etc/sudoers

- Ajouter dans le fichier 

> *[user]* ALL=(ALL:ALL) ALL

### Installation de SSH

- Commande à taper en sudo ou root 

> apt-get install openssh-server

- Reprendre l'adresse IP du serveur avec la commande 

> ip addr

## Installation de Nginx et PHP-FPM

- Commande pour installer Nginx et PHP-FPM

> sudo apt-get install nginx php-fpm

- Lancer le serveur à chaque demarrage de la VM

>sudo systemctl enable nginx

## Installation de MariaDB

Pour installer MariaDB, suivez les commandes suivantes:

```
sudo apt-get install software-properties-common dirmngr
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.mva-n.net/mariadb/repo/10.3/debian stretch main'
```

Une fois que les clés ont été ajoutés et que la liste des sources a été mise à jour, installez MariaDB:

```
sudo apt-get update
sudo apt-get install mariadb-server
```

Saisir ensuite le mot de passe souhaité pour la base de donnée MariaDB.

Vérifier que la connexion à la base de donnée est fonctionnelle avec la commande

> mysql -p

* Le paramètre -p est requis pour rentrer le mot de passe. Rentrer votre mot de passe.

Nous allons finaliser la configuration. Tapez la commande suivante:

> sudo mysql_secure_installation

Rentrez votre mot de passe. Ensuite, le mot de passe de la base de donnée root est demandée. Saisissez là aussi.

Nous aurons ensuite une série de question. La première question :

> Change the root password ? [Y/n]

Nous pouvons mettre "n" car nous avons déjà un mot de passe.

Deuxième question :

> Remove anonymous users? [Y/n]

Tapez "Y" et appuyez sur la touche entrée.

Troisième question :

> Disallow root login remotely? [Y/n] 

Tapez "Y" et appuyez sur la touche entrée.

Quatrième question :

> Remove test database and access to it? [Y/n] 

Tapez "Y" et appuyez sur la touche entrée.

Cinquième question :

> Reload privilege tables now? [Y/n]

Tapez "Y" et appuyez sur la touche entrée.

## Création de l'utilisateur

Se connecter en root avec la commande : su

Création de l'utilisateur 

> adduser `nom d'utilsateur`

Insérer un mot de passe temporaire et confirmer le ensuite

Plusieurs données vous seront demandés, libre à vous de les remplir ou non.

Tapez la commande suivante pour forcer l'utilisateur à changer son mot de passe au premier login

> sudo passwd -e `nom d'utilsateur`

Maintenant on va bloquer l'accès des autres utilisateurs sur le répertoire du nouvel utilisateur créé précédemment avec la commande suivant 

> chmod 700 /home/repertoire_du_nouvel_utilisateur

## Création d'une base de données 

Connectez vous à la base de donnée MariaDB. Pour ce faire, saisir la commande suivante :

> sudo mysql -u root -p

Une fois connecté, nous allons créer un utilisateur pour une base de donnée.

> CREATE USER 'nomUtilisateur' IDENTIFIED BY 'motdepasse';

Nous allons aussi créer une base de donnée pour que l'utilisateur puisse l'utiliser.

> CREATE DATABASE nomdb;

## Configuration de NGinx

Créeons un site pour un utilisateur 

> sudo mdkir -p /var/www/site1.monserver.com/html 

Changer le propriétaire du dossier 

> sudo chown  utilisateur:utilisateur -R /var/www/site1.monserver.com/html

Créeons un fichier index.html pour le site de l'utilisateur

> nano /var/www/site1.monserver.com/html/index.html

Inserez ceci dans le fichier 

```
<html>
    <head>
     <title>Site_1</title>
    </head>
    <body>
     <h1>Hello world!!! bienvenue sur mon <strong>Mon site1</strong></h1>
    </body>
</html>
```

Créer le fichier de configuration pour le site

> sudo nano /etc/nginx/sites-avalaible/site1

Copié les lignes ci-dessous pour chaque nouveau fichier de configuration

```
server {
    listen 80 ;
    listen [::]:80 ;

    # SSL configuration
    #
    # listen 443 ssl default_server;
    # listen [::]:443 ssl default_server;
    #
    # Self signed certs generated by the ssl-cert package
    # Don't use them in a production server!
    #
    # include snippets/snakeoil.conf;

    root /var/www/site1.monserver.com/html;

    # Add index.php to the list if you are using PHP
    index index.html index.htm ;

    server_name site1.monserver.com;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
    }
}
```

Etant donné que notre serveur est en local, modifiez le fichier host sur Windows ou sur Linux 

Sur Linux 

> sudo nano /etc/hosts

Inserez les lignes suivantes 

> ip_du_serveur `nom de domaine du site`

Sur Windows éditez le fichier suivant qui se trouve là 

> C:\Windows\System32\drivers\etc

Inserez les lignes suivantes 

> ip_du_serveur `nom de domaine du site`

Créer un lien symbolique pour pouvoir accéder au site

> sudo ln -s /etc/nginx/sites-available/site1 /etc/nginx/sites-enabled/

redémarrer ensuite le serveur 

> sudo service nginx restart

Tester ensuite la configuration sur un navigateur en mettant la ligne suivante dans la barre de recherche 

> site.monserveur.com

# Isolation des utilisateurs

Pour chaque utilisateur, il faut limiter l'accès à l'home uniquement pour l'utilisateur concerné.

> sudo chmod 700 /home/nomutilisateur

Faire la même commande excepté que cette fois-ci, cela sera le dossier du site de l'utilisateur qui se trouve dans /var/www.

> sudo chmod 711 /var/www/siteutilisateur

## Séparation des pools

  

