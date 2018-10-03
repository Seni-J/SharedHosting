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

Saisir lensuite le mot de passe souhaité pour la base de donnée MariaDB.

