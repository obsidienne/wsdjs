defmodule Wsdjs.ProfilsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Accounts

  describe "users" do
    alias Wsdjs.Accounts.User

    @valid_attrs %{"email" => "dummy@bshit.com"}

    test "list_users/0 returns all users" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = user |> Repo.preload([:profil, :songs, :comments])

      assert Accounts.list_users() == [user]
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "dummy@bshit.com"
      assert user.user_country == nil
      assert user.name == nil
      assert user.djname == nil
      assert user.admin == false
      assert user.profil_djvip == false
      assert user.profil_dj == false
      assert user.confirmed_at == nil
    end

    test "get_user!/1 returns the user with given id" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = Repo.forget(user, :user_profil)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = user |> Repo.preload(:profil)
      assert Accounts.get_user_by_email(user.email) == user
      assert Accounts.get_user_by_email(String.upcase(user.email)) == user
    end

    test "change_user/1 returns a user changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    @update_attrs %{
      "email" => "updatedemail@bshit.com",
      "user_country" => "update country",
      "name" => "update name",
      "djname" => "update djname",
      "admin" => true,
      "profil_djvip" => true,
      "profil_dj" => true,
      "confirmed_at" => Timex.now(),
      "profil" => %{
        "description" => "update description",
        "favorite_genre" => "soul",
        "favorite_artist" => "update favorite artist",
        "djing_start_year" => 2000,
        "youtube" => "http://update.youtube.fr",
        "facebook" => "http://update.facebook.fr",
        "soundcloud" => "http://update.soundcloud.fr"
      }
    }

    @invalid_update_attrs %{
      profil: %{
        "youtube" => "not valid yt",
        "facebook" => "not valid fb",
        "soundcloud" => "not valid sd"
      }
    }

    test "update_user/3 with invalid data done by admin returns error changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.update_user(user, @invalid_update_attrs, %User{admin: true})

      assert "invalid url: :no_scheme" in errors_on(changeset).profil.facebook
      assert "invalid url: :no_scheme" in errors_on(changeset).profil.soundcloud
      assert "invalid url: :no_scheme" in errors_on(changeset).profil.youtube
    end

    test "update_user/3 with invalid data done by user returns error changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Accounts.update_user(user, @invalid_update_attrs, %User{admin: false})

      assert "invalid url: :no_scheme" in errors_on(changeset).profil.facebook
      assert "invalid url: :no_scheme" in errors_on(changeset).profil.soundcloud
      assert "invalid url: :no_scheme" in errors_on(changeset).profil.youtube
    end

    test "update_user/3 with valid data done by admin updates the user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs, %User{admin: true})

      assert user.email == "updatedemail@bshit.com"
      assert user.name == "update name"
      assert user.djname == "update djname"
      assert user.user_country == "update country"
      assert user.admin == true
      assert user.profil_djvip == true
      assert user.profil_dj == true
      assert user.confirmed_at == nil

      assert user.profil.description == "update description"
      assert user.profil.favorite_genre == "soul"
      assert user.profil.favorite_artist == "update favorite artist"
      assert user.profil.djing_start_year == 2000
      assert user.profil.youtube == "http://update.youtube.fr"
      assert user.profil.facebook == "http://update.facebook.fr"
      assert user.profil.soundcloud == "http://update.soundcloud.fr"
    end

    test "update_user/3 with valid data done by user updates the user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs, %User{admin: false})

      assert user.email == "dummy@bshit.com"
      assert user.name == "update name"
      assert user.djname == "update djname"
      assert user.user_country == "update country"
      assert user.admin == false
      assert user.profil_djvip == false
      assert user.profil_dj == false
      assert user.confirmed_at == nil

      assert user.profil.description == "update description"
      assert user.profil.favorite_genre == "soul"
      assert user.profil.favorite_artist == "update favorite artist"
      assert user.profil.djing_start_year == 2000
      assert user.profil.youtube == "http://update.youtube.fr"
      assert user.profil.facebook == "http://update.facebook.fr"
      assert user.profil.soundcloud == "http://update.soundcloud.fr"
    end
  end
end
