# Radio WCS platform (rwp)

This project aims to provide a common platform for all aspects of our community.
The following aspect will be covered:

* DJs song suggestions and voting, known as **WorldSwingDeeJays**
* The radio API and tiny website
* Happenings management, known as **Radio WCS +**


Use [acme_bank](https://github.com/wojtekmach/acme_bank) app as an example to create the platform.

## How to install and launch the app
* mix deps.get
* mix ecto.drop && mix ecto.create
* psql -d wsdjs_dev < audit.sql
* psql -d wsdjs_dev < tuning.sql
* pg_restore -h localhost -p 5432 -U postgres -d wsdjs_dev --format=c -c {YOUR_BACKUP_FILE}
* mix ecto.migrate
* cd apps/wsdjs_web/assets && npm install
* mix phx.server

iex -S mix phx.server


# env vars for clever apps 

|env|value|
|---|-----|
|CC_PHOENIX_ASSETS_DIR|apps/wsdjs_web/assets/|
|CC_PRE_RUN_HOOK|mix ecto.migrate|
|DEPLOYMENT_ENV|staging|
|MIX_ENV|prod|
|PORT|8080|
|SENDGRID_API_KEY||
|SECRET_KEY_BASE||

If errors on mix.exs
rm -r deps _build .elixir_ls && mix deps.get