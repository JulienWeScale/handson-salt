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
* xxxx.tf - Déclaration des machines par équipe

## Utilisation

Téléchargez terraform : [https://www.terraform.io/downloads.html]

Ajoutez Terraform au PATH de votre système.

Puis lancez :

```shell
$ terraform plan
$ terraform apply
```