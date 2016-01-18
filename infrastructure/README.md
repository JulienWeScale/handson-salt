# Automatisation de l'infrastructure du hands on salt

## Compte de service

le compte de service du projet est fournie sous forme chiffrée dans `gcloud.json.gpg`
pour la déchiffrer lancez :

```shell
$ gpg -d gcloud.json.gpg
```

Pour chiffrer la clef il faut lancer la commande :

```shell
$ gpg --symetric gcloud.json
```

Dans les deux cas il faudra fournir la passphrase.

## Organisation Terraform

Cette infrastructure est créée via terraform. Les fichiers descriptifs sont :
* common.tf - Déclaration du provider google compute engine et des ressources de base de l'infrastructure
              (réseau, firewall, master central)
* teams.tf - Déclaration des machines par équipe
* params.tf - Déclaration des paramétres (nom d'image, nombre d'équipes, ...)

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

## Infrast