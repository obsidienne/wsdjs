# Photo

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `Wsdjs` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:Wsdjs, "~> 0.1.0"}]
    end
    ```

  2. Ensure `Wsdjs` is started before your application:

    ```elixir
    def application do
      [applications: [:photo]]
    end
    ```


To restore a database from a clever app dump: pg_restore -h localhost -p 5432 -U claudio -d wsdjs_dev --format=c -c {YOUR_BACKUP_FILE}


## Définitions
 - __PUBLIC__: pas besoin de s'authentifié = utilisateur lambda externe sans profil
 - __PRIVE__: nécessite d'être authentifié = auditeurs/danseurs/pros WCS/Deejay basic avec profil réduit
 - __SECRET__: nécessite d'être authentifié et autorisé = Deejays VIP actuels avec profil évolué

## Restrictions

PUBLIC
- Home page (FAIT)
- Instant hit sur Home page sous l'appellation "Deejays' pick" (FAIT)
- Top 10 (et pas Top 20) du mois M-3 (mois M, M-1 et M-2 sont secrets) sur Home page (A FAIRE)
- Profil deejay ayant suggéré mais pas la liste de ses suggestions passées (FAIT)
- Lire une suggestion dans Youtube ou autre soundcloud...  (FAIT)
- Hidden track caché (FAIT)
- Accès aux Top 10 de M-3, M-4 et M-5 seulement soit 3 mois glissants seulement (A FAIRE)

PRIVE
- Home page (FAIT)
- Instant hit sur Home page sous l'appellation "Deejays' pick" (FAIT)
- Top 10 (et pas Top 20) du mois M-3 (mois M, M-1 et M-2 sont secrets) sur Home page (A FAIRE)
- Profil deejay ayant suggéré avec la liste de ses suggestions UNIQUEMENT incluses dans les Top 10 (FAIT)
- Lire une suggestion dans Youtube ou autre soundcloud...  (FAIT)
- Hidden track caché (FAIT)
les musiques proposées le 
- Accès aux Top 10 sur 2 ans à partir de M-3 seulement soit 24 mois glissants seulement (A FAIRE)

SECRET
- Home page (FAIT)
- Instant hit sur Home page sous l'appellation "Deejays' pick" (NON ACCESSIBLE mais FAIT)
- Top 10 (et pas Top 20) du mois M-3 (mois M, M-1 et M-2 sont secrets) sur Home page (A FAIRE)
- Profil deejay ayant suggéré avec la liste de toutes les suggestions SANS RESTRICTIONS (FAIT)
- Lire une suggestion dans Youtube ou autre soundcloud...  (FAIT)
- Hidden track visible (FAIT)
- Accès à tous les Top 10 depuis le début
Toutes les règles actuelles de WSDJS restent les mêmes et restent inchangées

## Synthèse temporelle
- mois M (SECRET) : non terminé et suggestions en cours jusqu'au 31
- mois M-1 (SECRET) : terminé et en cours de vote
- mois M-2 (SECRET) : terminé, voté et résultats uniquement accessibles aux VIP pendant 1 mois
- mois M-3 (PUBLIC) : terminé, voté et résultats accessibles à tous

## Dj VIP uniquement
- Le bouton "Instant hit" est uniquement réservé à l'admin WSDJS car cela relève de la stratégie globale de diffusion de la radio et pas des Deejays
- Le bouton "Hidden track" est accessible aux DJ VIP et à l'Admin

## public track
Il permet aux Deejays VIP de laisser en public leurs morceaux au delà des 3 mois pour les users publics et des 2 années d'ancienneté pour les users authentifiés (donc rendre public de façon sélective titre par titre et non de façon globale car notre base musicale a de la valeur). Il permet aussi aux titres des top 10 deejay VIP ainsi qu'aux anciens morceaux diffusés sur la radio d'être  toujours accessible à tous.
