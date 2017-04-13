defmodule Wsdjs.TopController do
  use Wsdjs, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]
    tops = Wcsp.Trendings.list_tops(current_user)
    changeset = Wcsp.Trendings.Top.changeset(%Wcsp.Trendings.Top{})

    render conn, "index.html", tops: tops, changeset: changeset
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    top = Wcsp.Trendings.get_top(current_user, id)

    case top.status do
      "creating" -> top_creating(conn, top)
      "voting" -> top_voting(conn, top)
      "counting" -> top_counting(conn, top)
      "published" -> top_published(conn, top)
    end

  end

  def new(conn, _params) do
    changeset = Wcsp.Trendings.Top.changeset(%Wcsp.Trendings.Top{})
    render(conn, "new.html", changeset: changeset)
  end

  def update(conn, %{"top" => top_params, "id" => id}, _current_user) do
    top = Wcsp.Trendings.top(id)
    changeset = Wcsp.Trendings.Top.changeset(top, top_params)

    case Wcsp.Repo.update(changeset) do
      {:ok, top} ->
        conn
        |> put_flash(:info, "Top updated successfully.")
        |> redirect(to: top_path(conn, :show, top))
      {:error, changeset} ->
        redirect(conn, to: top_path(conn, :show, top))
    end
  end

  def create(conn, %{"top" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Trendings.create_top(current_user, params) do
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

  def nextstep(conn, %{"top" => top_params, "id" => id}) do
    top = Wcsp.Trendings.top(id)

    redirect(conn, to: top_path(conn, :show, top))
  end

  defp top_creating(conn, top) do
    changeset = Wcsp.Trendings.Top.changeset(top)
    render conn, "creating.html", top: top, changeset: changeset
  end

  defp top_voting(conn, top) do
    user = conn.assigns[:current_user]

    changeset = Wcsp.Trendings.Top.changeset(top)
    top = Wcsp.Repo.preload(top, rank_songs: Wcsp.Trendings.Vote.for_user_and_top(top, user))
    render conn, "voting.html", top: top, changeset: changeset
  end

  defp top_counting(conn, top) do
    changeset = Wcsp.Trendings.Top.changeset(top)

    render conn, "counting.html", top: top, changeset: changeset
  end

  defp top_published(conn, top) do
    render conn, "published.html", top: top
  end
end
