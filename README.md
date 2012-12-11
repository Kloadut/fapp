FAPP - YunoHost Free Application's Portal
=========================================
#### Plateforme de contribution et de consultation simplifiée d'app pour YunoHost

**Remarque:** Le site sera multilingue (l'intégration I18n de padrino suffit)

## Modèles
#### User
* nick (clé)
* password
* email
* is_admin
* is_maintainer
* is_tester

#### Comment 
* id (clé)
* app_id (relation avec App)
* nick
* body

#### App 
* app_id (clé)
* author_mail
* author_password
* name
* dependencies (optionnal)
* description (optionnal)
* maintainer (optionnal)
* git_url
* git_branch
* git_commit

#### Request 
* app_id (clé, relation avec App)
*  initial_repo
* target_repo
* git_url
* git_branch
* git_commit
* status
* treated_by (relation avec User, optionnal)

*Le tout avec timestamp!*


## Controllers

#### Contribuer une nouvelle app 
**URL:** GET /app/new

**Items sur la page :**
- Formulaire contenant :
 * URL du repo git de l'appli YunoHost (qui contient les sources,  les scripts spécifiques à l'install sur YunoHost, l'icône et le  manifest)
 * La branche
 * La revision (shawan du commit)
 * Email
 * Mot de passe (pour l'édition et les demandes de mise à jour de l'app)
 * Un captcha (un human captcha mathématique de préférence)


#### Enregistrer l'app
**URL:** POST /app/new

**Actions:**
- Vérifier le captcha
- Fetch le dépôt git indiqué dans la request
- Garde le manifest et l'icône
- Parse le manifest (yaml) pour ne garder que le nom, l'auteur, la  description et les dépendances
- Enregistrer l'app en base, dans le repo "community" (mdp hashé MD5)
- Mailer l'adresse new-app@yunohost.org avec les informations et le type de la request (+ le lien /request/id/validate)
- Mailer l'adresse mail du créateur de l'app pour lui indiquer que l'app a été ajoutée (avec le lien)
- Rediriger vers la page de l'app


#### Lister les requests
**URL:** GET /request/list (accessible pour les admins uniquement)

**Items à afficher:**
- Liste des requêtes paginées par date (éventuellement tri par nom)
- Boutons "valider" et "rejeter" au niveau de chaque request


#### Valider la request
**URL:** GET /request/id/validate (accessible uniquement par les testers)

**Actions:**
- Fetch le dépôt git indiqué dans la request
- Garde le manifest et l'icône
- Parse le manifest (yaml) pour ne garder que le nom, l'auteur, la  description (et quelques autres info à préciser) et les enregistre en  base comme 'app' (avec la date)
- Enregistre également le mot de passe et l'email fourni à la request (email dispo pour les admins)
- Passer le statut de la request à "Validée" avec le nom de l'admin qui l'a traité
- Mailer le créateur de la request pour lui indiquer que la request a été traité avec un lien vers la page de son app

**Items à afficher:**
- "La requête a bien été traité"


#### Lister les apps
**URL:** GET /app/list (accessible à tout le monde)

**Items à afficher:**
- Liste paginée (avec nom, icones, description et date de mise à jour)
- Recherche
- Optionnal : filtres (derniere app, derniere mise à jour, dernier commentaire)


#### Voir une app
**URL:** GET /app/appid (l'appid sera en fait nom.auteur)

**Items à afficher:**
- Infos de l'app (pour le moment nom, auteur, description et icone et date de création + màj)
- Lien "Mettre à jour cette app"
- Liste des commentaires de cette app
- Lien vers 'flux RSS des commentaires de cette app' ( GET /comment/appid/list en XML )
- Formulaire d'ajout de commentaire avec:
 * Pseudo
 * Commentaire
 * Captcha
 * Optionnal: système de notation de l'app ? :D


#### Ajouter un commentaire
**URL:** POST /comment/appid/new

**Actions:**
- Vérifier le captcha
- Enregistrer le commentaire en BDD avec la date


#### Ecran de mise à jour d'une app
**URL:** GET /app/appid/edit

**Items à afficher:**
- Formulaire contenant:
 * Ancien mot de passe
 * L'URL du git (Optionnel)
 * La branche (Optionnel)
 * La revision (Optionnel)
 * Nouvel email (Optionnel)
 * Nouveau mot de passe (Optionnel)
 * Captcha


#### Mettre à jour une app
**URL:** POST /app/appid

**Actions:**
- Vérifier le captcha
- Enregistrer la request de type "update app" en base (mdp hashé MD5)
- Mailer l'adresse new-request@yunohost.org avec les informations et le type de la request (+ le lien /request/id/validate)
- Mailer l'adresse mail du créateur de la request pour lui indiquer que la request a été prise en compte


#### Listing "RAW" des applis
**URL:** GET /app/list/raw

**Items à retourner (en yaml json par exemple):**

*Exemple :* http://kload.fr/fapp
- Date de mise à jour (timestamp)
- Appid
- Repo (community, testing ou stable)
- Lien vers le repo git
- Branche
- Revision
- Lien vers le manifest
- Lien vers l'icône
**Note:** Cette liste devrait être mise en cache


#### Ecran de réinitialisation du mot de passe
**URL:** GET /app/appid/dafuq-password

**Items à afficher:**
- Formulaire de demande d'email
- Captcha


#### Envoi de la demande de réinitialisation
**URL:** POST /app/appid/dafuq-password

**Actions:**
- Vérifier le captcha
- Création d'un token
- Envoi d'un email contenant le lien /dafuq-password/<token>


#### Réinitialiser le mot de passe
**URL:** GET /app/appid/dafuq-password/<token>

**Actions:**
- Vérifier la présence du token en base
- Changer le mot de passe par un aléatoire
- Mailer le nouveau mot de passe avec le lien vers "Mettre à jour l'app"
**Items à afficher:**
- "Votre mot de passe a bien été réinitialisé, merci de check vos mail modafaka"

