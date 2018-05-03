# Radio WCS platform (rwp)

This project aims to provide a common platform for all aspects of our community.
The following aspect will be covered:

* DJs song suggestions and voting, known as **WorldSwingDeeJays**
* The radio API and tiny website
* Happenings management, known as **Radio WCS +**


Use [acme_bank](https://github.com/wojtekmach/acme_bank) app as an example to create the platform.

## How to install and launch the app
* mix deps.get
* mix ecto.drop // destroy actual db
* mix ecto.create // create it empty
* psql -d wsdjs_dev
* CREATE EXTENSION IF NOT EXISTS postgis;
* GRANT INSERT ON TABLE audit.logged_actions TO postgres;
* pg_restore -h localhost -p 5432 -U postgres -d wsdjs_dev --format=c -c {YOUR_BACKUP_FILE}
* mix ecto.migrate
* cd apps/wsdjs_web/assets && yarn install
* mix ua_inspector.download.databases
* mix ua_inspector.download.short_code_maps
* mix phx.server

iex -S mix phx.server

To use the layout_type:
  def show(%Plug.Conn{assigns: %{layout_type: "mobile"}} = conn, %{"id" => id}, current_user) do
