Ce fichier contient toute la logique métier concernant les accès. Afin d'être certain d'être compris par l'ensemble de l'équipe, ces règles sont écrites en français contrairement au reste de l'appli.

Il faut distinguer plusieurs types d'utilisateurs:
 - les utilisateurs non connectées
 - les utilisateurs connectés
 - L'utilisateur admin
 - les bot (FB utilise un bot par exemple pour ses card)

Il y a aussi plusieurs actions:
 - show: permet d'afficher la page détaillant la ressource (song, top, user)
 - edit: permet de modifier les informations saisies pour une resource
 - delete: permet de supprimer une resources
 - index: permet d'afficher une liste d'un type de resource (toutes les songs par exemple)
 - search: permet de chercher une liste limité en quantité (5 chanson uniquement)

# règles

Par défault un utilisateur peut effectuer toutes les actions sur une ressource qu'il a créée. Les tableaux suivants apporteront des précisions si nécessaire

__profil__

| action        | admin | dj | anonymous | bot |
| ------------  | ----- | -- | --------- | --- |
| create profil | no    | no | no | no |
| show profil   | all   | only dj | only dj | only dj |
| edit profil   | all  | only it's profil | no | no |
| delete profil | no  | no | no | no |

profil creation is done by claudio or phets for the first step waiting subscription

__song__

| action       | admin | dj                | anonymous | bot |
| ------------ | ----- | --                | --------- | --- |
| suggest song | no    | yes               | no        | no |
| edit song    | yes   | dj's suggestions  | no        | no |
| delete song (without votes, opinions, comments) | yes   | dj's suggestions | no | no |
| delete song (with votes, opinions, comments) | yes (cascade delete)   | no | no | no |
| show instant hit| yes | yes | yes | yes |
| show hidden song | yes | dj's only | no | no |
| show song less than 3 months | yes | yes | no | yes |
| show song more than 3 months | yes | yes | yes | yes |
