defmodule Wcsp.PolicyTest do
  use Wcsp.DataCase, async: true

  alias Wcsp.Accounts.User
  alias Wcsp.Musics.Song
  alias Wcsp.Top

  test "admin can do everything on anything" do
    admin = %User{admin: true}
    actions = [:new, :create, :show, :delete, :edit, :update, :index]
    models = [%Song{}, %Top{}]

    Enum.each(models, fn(model) ->
      Enum.each(actions, fn(action) ->
        assert Wcsp.Policy.can?(admin, action, model)
      end)
    end)
  end

  test "Connected user on song" do
    user = %User{id: Ecto.UUID.generate(), admin: false}
    song = %Song{user_id: Ecto.UUID.generate()}
    his_song = %Song{user_id: user.id}

    Enum.each([:create, :show], fn(action) ->
      assert Wcsp.Policy.can?(user, action, song)
    end)

    Enum.each([:new, :delete, :edit, :update, :index], fn(action) ->
      refute Wcsp.Policy.can?(user, action, song)
    end)

    Enum.each([:new, :create, :show, :delete, :edit, :update, :index], fn(action) ->
      assert Wcsp.Policy.can?(user, action, his_song)
    end)
  end

  test "Anonymous user on song" do
    assert Wcsp.Policy.can?(nil, :show, %Song{})

    Enum.each([:create, :new, :delete, :edit, :update, :index], fn(action) ->
      refute Wcsp.Policy.can?(nil, action, %Song{})
    end)
  end
end
