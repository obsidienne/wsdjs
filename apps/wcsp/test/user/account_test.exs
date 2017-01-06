defmodule Wcsp.AccountTest do
  use Wcsp.Case

  defp errors_on(model, params) do
    model.__struct__.changeset(model, params).errors
  end

  @valid_attrs %{email: "alice@example.com"}

  test "changeset with minimal valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "email is unique" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    Repo.insert(changeset)

    assert {:error, %{errors: [email: {"has already been taken", []}]}} = Repo.insert(changeset)
  end

  test "email must have a valid format" do
    assert {:email, {"has invalid format", [validation: :format]}} in errors_on(%Account{}, %{email: "bullshit"})
  end

  test "email can't be blank" do
    assert {:email, {"can't be blank", [validation: :required]}} in errors_on(%Account{}, %{email: nil})
  end
end
