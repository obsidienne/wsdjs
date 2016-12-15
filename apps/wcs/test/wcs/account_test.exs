defmodule Wcs.AccountTest do
  use Wcs.Case

  defp errors_on(model, params) do
    model.__struct__.changeset(model, params).errors
  end

  @valid_attrs %{email: "alice@example.com"}

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Wcs.Repo, [])
    :ok
  end

  test "changeset with minimal valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "email is unique" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    Repo.insert(changeset)
    assert {:error, "d"} = Repo.insert(changeset)

  end

  test "email must have a valid format" do
    assert {:email, {"has invalid format", []}} in errors_on(%Account{}, %{email: "bullshit"})
  end

  test "email can't be blank" do
    assert {:email, {"can't be blank", []}} in errors_on(%Account{}, %{email: nil})
  end
end
