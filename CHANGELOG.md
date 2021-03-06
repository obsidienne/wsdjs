# version 2.4.0

- move master_proxy to wsdjs_web
- add a scroll system for smarphone
- update dependecies

# version 2.3.0

- remover ua_inspector
- use nodejs to tool-versions and stop using yarn
- remove leaflet
- event as card

# version 2.2.0

- tailwindcss usage
- master proxy
- new design

# version 2.1.0

- split wsdjs_web into wsdjs_web and wsdjs_api
- create a wsdjs_proxy
- create an attachment lib
- refactoring

# version 2.0.0

- change PK from uuid to bigint with hashid

# version 1.9.1

- rename namespace for jobs

# version 1.9.0

- add TOP5 management
- simplify CSS
- update tippyjs
- modify opinion selector (up/down/like)
- add a playlist selector for song
- add a search by filter in song page
- add a search song in playlist
- first 5 songs of a playlist can be in the user front page
- add log out link
- add autoprefixer to webpack
- add a webmanifest (need test in android)

# version 1.8.7

- add a the facebook url to event
- edit playlist name and visibility
- create a user params page
- change the mechanism for updating radio (cron job)
- move job schedules config to env config
- create a radio page
- improve mobile menu
- Float Action Button in mobile configuration
- Design video close button
- Admin can only see his logout button
- Bump elixir and erlang version to match the latest version installed in the server
- Improve the CSS file organization
- add a map in happenings

# version 1.8.6

- specific page for user params
- edit page for playlist public status (remove it from user edit page)

# version 1.8.5

- Use markdown for comment and user description
- Add user count

# version 1.8.4

- activate postgis
- use places.js to find event venue
- better user profil style page

# version 1.8.3

- connect video to event
- vertical rhythm 8px
- webpack4
- Sticky month for song list
- update tooltip
- Improve page titles

# version 1.8.2

- update changelog
- remove admin path for users as members are a public notion
- events CRUD
- use hashID for events and playlists
- https everywhere

# version 1.8.1

- avoid recurvice on song show

# version 1.8

- remove docker and distillery configuration
- remove outdated browser check
- downgrade elixir version to 1.5.2 to allow direct deploy to clever cloud
- use polyfill.io to download fetch, intersectionObserver and fetch.finally when needed
- replace js callback and XMLHTTPRequest by promise and fetch
- replace the loading animation by a donut spin
- remove template for country selector
- use webpack instead brunch
- remove sound control in web player
- move the player to the bottom right and use perfect 16:9 size
- load pjax-api by CDN
- use CSS costum var to have the same values for shadows/colors/etc through all the site
- avatar comment are now a circle

# version 1.7

- add #suggestion# and #likes and tops# playlists
- new design
- replace turbolinks by pjax
- activate BROTLI and GZIP to minify JS et CSS assets
- use immutable cache to improve bandwitch usage
- remove tabs UI design
- add a verified profil toggle
- create a sub app for the API part
- add an option to hide user email
- lot of design tuning

# version 1.6

- invitation deprecated : invitation access removed. Admin can list existing invitation request
- add a deactivated user toggle. A deactivated user cannot login or get newsletter
- split user save actions to improve security (the user update internal path is different for an admin a std user)
- change song & top visibility access to 12 month (-3 months to -15 months) for DJ profil
- the capacity for a user to add a video to a song is protected by an admin pref
- send an email if a streamed song does not match with WSDJs internal DB
- activate the option to be notified when a new song has been suggested the last 24h
- use srcset for img resolution auto selection by the browser
- create the user_parameters and user_details tables for every new users (need to check the prod for those tables to avoid blocking errors on profils)
- differentiates song suggestion (used in TOP 10) and song creation (not used in TOP 10)
- Registration and Sign in are differentiated to help user in connection/registration aspect
- remove a lot of ex_machine usage (tech aspect not a user aspect)

# version 1.5

- apple file for universal link
- move API to v1
- API for comment, opinions, songs, video
- specific link for signin email from smartphone
- adapt design to device (only the foundation no visible changes)
- add pro's video to song
- use docker for deployment
- reschedule radio update when radioking does not respond
- use srcset to cloudinary_api
- add base for venues and happenings

# version 1.4.3

- authorize empty/null BPM
- UTC correction for client
- base mailing
- use ex_machina as a factory test
- add a lot of unit test
- use boolean for user_profil, it improves usability
- use only scope for index, unauthorized access is not a 404 error
