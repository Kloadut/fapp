FAPP - YunoHost Free Application's Portal
=========================================

### Description
FAPP est un portail Web permettant de consulter et de contribuer facilement des Apps pour YunoHost. N'importe qui pourra, sans s'enregistrer, ajouter son application (Web et/ou non), en renseignant simplement son repo Git, son email et un mot de passe pour sa page d'App.
Le repo Git devra contenir le manifest de l'App, et les informations (nom, icône, description, dépendances, etc.) seront visible sur la page de l'App.

Par défaut, l'App sera placée parmis la liste "community" sans modération, et sera disponible sur toutes les instances YunoHost ayant choisie d'utiliser la liste "community".

Par la suite, le contributeur de l'App pour demander à ce que son App soit placée dans la liste "testing", si il considère l'App assez stable. Un validateur s'occupera alors de vérifier le code et le fonctionnement de celle-ci.

Enfin, si l'App dans "testing" est considérée comme assez robuste, un mainteneur est assigné à l'App qui est placée dans la liste "stable".


**Remarque:** Le site sera multilingue (l'intégration I18n de padrino suffit)

**Remarque 2:** Les captcha seront en JS (calcul côté client)

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
* list
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
* type (grant ou update)
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
 * Un captcha


#### Enregistrer l'app
**URL:** POST /app/new

**Actions:**
- Vérifier le captcha
- Fetch le dépôt git indiqué dans la request
- Garde le manifest et l'icône (stockés avec des URL publiques)
- Parse le manifest (yaml) pour ne garder que le nom, l'auteur, la  description et les dépendances
- Enregistrer l'app en base, dans la liste "community" (mdp hashé MD5)
- Mailer l'adresse new-app@yunohost.org avec les informations et le type de la request (+ le lien /request/id/validate)
- Mailer l'adresse mail du créateur de l'app pour lui indiquer que l'app a été ajoutée (avec le lien)
- Rediriger vers la page de l'app


#### Lister les apps
**URL:** GET /app/list (accessible à tout le monde)

**Items à afficher:**
- Liste paginée (avec nom, icones, description, liste et date de mise à jour)
- Recherche (dans le nom/description/app_id)
- Optionnal : filtres (derniere app, derniere mise à jour, dernier commentaire)


#### Voir une app
**URL:** GET /app/appid (l'appid sera de la forme nom.auteur)

**Items à afficher:**
- Infos de l'app (pour le moment nom, auteur, description, dépendances, icône et date de création + màj)
- Lien "Update App's informations"
- Lien "Grant to 'testing'" (ou stable)
- Liste des commentaires de cette App
- Lien vers 'flux RSS des commentaires de cette App' ( GET /comment/appid/list en XML )
- Formulaire d'ajout de commentaire avec:
 * Pseudo
 * Commentaire
 * Captcha
 * Prochainement: système de notation de l'app ? :D


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
 * L'icône (Optionnel)
 * Nouvel email (Optionnel)
 * Nouveau mot de passe (Optionnel)
 * Captcha


#### Mettre à jour une app
**URL:** POST /app/appid

**Actions:**
- Vérifier le captcha
- Vérifier le mot de passe

Si l'App est dans une liste autre que community
- Enregistrer la request de type "update" en base (mdp hashé MD5)
- Mailer l'adresse new-request@yunohost.org avec les informations et le type de la request (+ le lien /request/<id>)
- Mailer l'adresse mail du créateur de la request pour lui indiquer que la request a été prise en compte

Sinon
- Enregistrer les modifications de l'App directement


#### Ecran de demande de promotion de liste
**URL:** GET /app/appid/grant

**Items à afficher:**
- Informations du Git de l'App (url, branch et sha1)
- Formulaire contenant:
 * Ancien mot de passe
 * Captcha
 * Bouton "Request pull on 'testing'" (ou stable)


#### Promotion de liste
**URL:** POST /app/appid/grant

**Actions:**
- Vérifier le captcha
- Vérifier le mot de passe
- Enregistrer la request de type "grant" en base
- Mailer l'adresse new-request@yunohost.org avec les informations et le type de la request (+ le lien /request/<id>)
- Mailer l'adresse mail du créateur de la request pour lui indiquer que la request a été prise en compte


#### Listing "RAW" des applis
**URL:** GET /app/list/raw

**Items à retourner (en yaml json par exemple):**

*Exemple :* http://kload.fr/fapp
- Date de mise à jour (timestamp)
- Appid
- List (community, testing ou stable)
- Lien vers le repo git
- Branche
- Revision
- Lien vers le manifest
- Lien vers l'icône

**Note:** Cette liste devrait être mise en cache


#### Lister les requests
**URL:** GET /request/list (accessible pour les admins uniquement)

**Items à afficher:**
- Liste des requêtes paginées par date (éventuellement tri par nom)
- Boutons "valider" et "rejeter" au niveau de chaque request


#### Voir la request
**URL:** GET /request/<id> (accessible pour les admins uniquement)

**Items à afficher:**
- Informations du Git de la request (url, branche, sha1)
- Boutons "valider" et "rejeter"


#### Valider la request
**URL:** POST /request/<id>/validate (accessible uniquement par les testers)

**Actions:**
- Fetch le dépôt git indiqué dans la request
- Garde le manifest et l'icône (stockés avec des URL publiques)
- Parse le manifest (yaml) pour ne garder que le nom, l'auteur, la description et les dépendances
- Enregistrer l'app en base, dans la liste kivabien (mdp hashé MD5)
- Mailer l'adresse mail du créateur de l'app pour lui indiquer que l'app a été ajoutée (avec le lien)
- Rediriger vers la page de l'app


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

