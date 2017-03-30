defmodule Wcsp.TopTest do
  use Wcsp.DataCase, async: true
  alias Wcsp.Top

  @create_attrs %{status: "creating", due_date: "2012-06-30"}

  test "changeset with minimal valid attributes" do
    changeset = Top.changeset(%Top{}, @create_attrs)
    assert changeset.valid?
  end

  test "top owner accout must exist" do
    params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
    top = Top.changeset(%Top{}, params)
    assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(top)
  end
end
