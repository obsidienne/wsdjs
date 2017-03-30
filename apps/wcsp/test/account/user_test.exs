defmodule Wcsp.UserTest do
  use Wcsp.DataCase, async: true

  alias Wcsp.Accounts.User

  @create_attrs %{email: "alice@example.com"}

  test "changeset with minimal valid attributes" do
    changeset = User.changeset(%User{}, @create_attrs)
    assert changeset.valid?
  end

  test "email is unique" do
    changeset = User.changeset(%User{}, @create_attrs)
    Repo.insert(changeset)

    {:error, changeset} = Repo.insert(changeset)
    assert "has already been taken" in errors_on(changeset, :email)
  end

  test "email must have a valid format" do
    changeset = User.changeset(%User{}, %{email: "bullshit"})
    assert "has invalid format" in errors_on(changeset, :email)
  end

  test "email can't be blank" do
    changeset = User.changeset(%User{}, %{email: nil})
    assert "can't be blank" in errors_on(changeset, :email)
  end
end
