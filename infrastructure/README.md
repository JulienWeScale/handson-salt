# Automatisation de l'infrastructure du hands on salt

## Prérequis

L'infrastructure se crée dans un projet google cloud. Elle repose sur une image
paramètrable dont l'os de base est Centos 7.1. Pour la partie DNS il faut avoir crée
une zone pour le sous-domaine gcp.wescale.fr. Pour que la délégation fonctionne, il faudra
s'assurer que les DNS google sont bien enregistré en NS dans le fichier de zone principal.



## Compte de service

le compte de service du projet est fournie sous forme chiffrée dans `gcloud.json.gpg`
pour la déchiffrer lancez :

```shell
$ gpg -d gcloud.json.gpg
```

Pour chiffrer la clef il faut lancer la commande :

```shell
$ gpg --symmetric gcloud.json
```

Dans les deux cas il faudra fournir la passphrase.


## Organisation Terraform

Cette infrastructure est créée via terraform. Les fichiers descriptifs sont :
* common.tf - Déclaration du provider google compute engine et des ressources de base de l'infrastructure
              (réseau, firewall, master central)
* teams.tf - Déclaration des machines par équipe
* params.tf - Déclaration des paramétres (nom d'image, nombre d'équipes, dns, ...)

## Infrastructure

L'infrastructure du handson crée un réseau et des règles de firewall valables autorisant
l'accés ssh et web depuis l'extérieure et autorisant tout trafique réseau en interne.
Les machines :
* central-master (serveur master salt pour tte l'infrastructure)
* teamX-master (serveur master salt pour l'infrastructure de l'équipe X)
* teamX-haproxy (serveur haproxy pour l'infrastructure de l'équipe X)
* teamX-tomcat[1-2] (serveur tomcat pour l'infrastructure de l'équipe X)
* teamX-redis (serveur redis pour l'infrastructure de l'équipe X)


## Utilisation

Téléchargez terraform : [https://www.terraform.io/downloads.html]

Ajoutez Terraform au PATH de votre système.

Puis lancez :

```shell
$ terraform plan
$ terraform apply
```

Pour détruire l'infrastructure il faudra lancer :

```shell
$ terraform destroy
```

## Accès aux instances

Pour se connecter aux instances il faut utiliser un client ssh avec la clef privé fournie
dans ce répertoire.
Pour déchiffrer la clef lancez:

```shell
$ gpg -d salt-handson.gpg
```

Seul les machines master ont une ip publique et sont donc accessible par internet.

Pour le teamX-master lancez:

```shell
$ ssh -i salt-handson wescale@teamX-master.gcp.wescale.fr
```

