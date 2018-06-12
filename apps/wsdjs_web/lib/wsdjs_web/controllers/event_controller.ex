defmodule WsdjsWeb.EventController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Happenings
  alias Wsdjs.Happenings.Event

  action_fallback(WsdjsWeb.FallbackController)

  def show(conn, %{"id" => id}, current_user) do
    with event <- Happenings.get_event!(id),
         :ok <- Happenings.Policy.can?(current_user, :show, event) do
      render(conn, "show.html", event: event)
    end
  end

  def index(conn, _params, current_user) do
    with :ok <- Happenings.Policy.can?(current_user, :index) do
      events = Happenings.list_events()
      render(conn, "index.html", events: events)
    end
  end

  def new(conn, _params, current_user) do
    with :ok <- Happenings.Policy.can?(current_user, :create_event) do
      changeset = Happenings.change_event(%Event{})
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"event" => params}, current_user) do
    params = Map.put(params, "user_id", current_user.id)

    with :ok <- Happenings.Policy.can?(current_user, :create_event),
         {:ok, event} <- Happenings.create_event(params) do
      conn
      |> put_flash(:info, "#{event.name} created")
      |> redirect(to: event_path(conn, :show, event))
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    with %Event{} = event <- Happenings.get_event!(id),
         :ok <- Happenings.Policy.can?(current_user, :edit_event, event) do
      changeset = Happenings.change_event(event)
      render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "event" => event_params}, current_user) do
    event = Happenings.get_event!(id)

    with :ok <- Happenings.Policy.can?(current_user, :edit_event, event),
         {:ok, %Event{} = event} <- Happenings.update_event(event, event_params) do
      conn
      |> put_flash(:info, "Event updated")
      |> redirect(to: event_path(conn, :show, event))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, user: current_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with event <- Happenings.get_event!(id),
         :ok <- Happenings.Policy.can?(current_user, :delete_event, event),
         {:ok, _event} = Happenings.delete_event(event) do
      conn
      |> put_flash(:info, "Event deleted successfully.")
      |> redirect(to: event_path(conn, :index))
    end
  end
end
