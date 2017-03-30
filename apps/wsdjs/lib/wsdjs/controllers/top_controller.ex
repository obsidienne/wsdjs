defmodule Wsdjs.TopController do
  use Wsdjs, :controller

  def index(conn, _params, _current_user) do
    tops = Wcsp.Trending.tops()
    changeset = Wcsp.Top.changeset(%Wcsp.Top{})

    render conn, "index.html", tops: tops, changeset: changeset
  end

  def show(conn, %{"id" => id}, _current_user) do
    top = Wcsp.Trending.top(id)

    case top.status do
      "creating" -> top_creating(conn, top)
      "voting" -> top_voting(conn, top)
      "counting" -> top_counting(conn, top)
      "published" -> top_published(conn, top)
    end

  end

  def new(conn, _params, _current_user) do
    changeset = Wcsp.Top.changeset(%Wcsp.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def update(conn, %{"top" => top_params, "id" => id}, _current_user) do
    top = Wcsp.top(id)
    changeset = Wcsp.Top.changeset(top, top_params)

    case Wcsp.Repo.update(changeset) do
      {:ok, top} ->
        conn
        |> put_flash(:info, "Top updated successfully.")
        |> redirect(to: top_path(conn, :show, top))
      {:error, changeset} ->
        redirect(conn, to: top_path(conn, :show, top))
    end
  end

  def create(conn, %{"top" => params}, current_user) do
    case Wcsp.create_top(current_user, params) do
      {:ok, top} ->
        conn
        |> put_flash(:info, "Top created !")
        |> redirect(to: top_path(conn, :show, top.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong !")
        |> render("new.html", changeset: changeset)
    end
  end

  def nextstep(conn, %{"top" => top_params, "id" => id}, current_user) do
    top = Wcsp.top(id)

    redirect(conn, to: top_path(conn, :show, top))
  end


  def action(conn, _) do apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user]) end

  defp top_creating(conn, top) do
    changeset = Wcsp.Top.changeset(top)
    render conn, "creating.html", top: top, changeset: changeset
  end

  defp top_voting(conn, top) do
    user = conn.assigns[:current_user]

    changeset = Wcsp.Top.changeset(top)
    top = Wcsp.Repo.preload(top, rank_songs: Wcsp.RankSong.for_user_and_top(top, user))
    render conn, "voting.html", top: top, changeset: changeset
  end

  defp top_counting(conn, top) do
    changeset = Wcsp.Top.changeset(top)

    render conn, "counting.html", top: top, changeset: changeset
  end

  defp top_published(conn, top) do
    render conn, "published.html", top: top
  end
end
