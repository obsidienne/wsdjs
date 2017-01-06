defmodule Wcsp.TopTest do
  use Wcsp.Case, async: true

  @valid_attrs %{status: "creating", due_date: "2012-06-30"}

  test "changeset with minimal valid attributes" do
    changeset = Top.changeset(%Top{}, @valid_attrs)
    assert changeset.valid?
  end

  test "top owner accout must exist" do
    params = Map.put(@valid_attrs, :account_id, Ecto.UUID.generate())
    top = Top.changeset(%Top{}, params)
    assert {:error, %{errors: [account: {"does not exist", _}]}} = Repo.insert(top)
  end
end
