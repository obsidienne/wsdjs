defmodule Wsdjs.AccountsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Accounts

  describe "users" do
    alias Wsdjs.Accounts.User

    @valid_attrs %{email: "dummy@bshit.com"}

    test "list_users/0 returns all users" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = user |> Repo.preload([:avatar, :songs, :comments])

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
      assert user.deactivated == false
      assert user.activated_at == nil
      assert user.parameter.new_song_notification == false
      assert user.parameter.piwik == true
      assert user.parameter.video == false
      assert user.parameter.radioking_unmatch == false
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{email: "bullshit"})
      assert "has invalid format" in errors_on(changeset).email

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{email: nil})
      assert "can't be blank" in errors_on(changeset).email
    end

    test "create_user/1 duplicating an existing user returns error changeset" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_attrs)
      assert "has already been taken" in errors_on(changeset).email

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{email: "DuMmY@BsHiT.cOm"})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "get_activated_user/1 returns the activated users" do
      assert {:ok, %User{} = activated} = Accounts.create_user(@valid_attrs)
      activated = Repo.preload(activated, :avatar)
      assert Accounts.get_activated_user!(activated.id) == activated

      assert {:ok, %User{} = deactivated} = Accounts.create_user(%{email: "dummy2@bshit.com"})
      assert {:ok, %User{} = deactivated} = Accounts.update_user(deactivated, %{deactivated: true}, %User{admin: true})
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_activated_user!(deactivated.id) end
    end

    test "get_user!/1 returns the user with given id" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = user |> Repo.preload(:avatar)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      user = user |> Repo.preload([:avatar, :detail])
      assert Accounts.get_user_by_email(user.email) == user
      assert Accounts.get_user_by_email(String.upcase(user.email)) == user
    end

    test "change_user/1 returns a user changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end


    @update_attrs %{
      email: "nochangeemail@bshit.com",
      user_country: "update country",
      name: "update name",
      djname: "update djname",
      admin: true,
      profil_djvip: true,
      profil_dj: true,
      deactivated: true,
      activated_at: Timex.now,
      parameter: %{
        new_song_notification: true,
        piwik: false,
        video: true,
        radioking_unmatch: true
      },
      detail: %{
        description: "update description",
        favorite_genre: "soul",
        favorite_artist: "update favorite artist",
        favorite_color: "update favorite color",
        favorite_meal: "update favorite meal",
        favorite_animal: "update favorite animal",
        djing_start_year: 2000,
        love_more: "update love more",
        hate_more: "update hate more",
        youtube: "http://update.youtube.fr",
        facebook: "http://update.facebook.fr",
        soundcloud: "http://update.soundcloud.fr"
      }
    }

    @invalid_update_attrs %{
      detail: %{
        youtube: "not valid yt",
        facebook: "not valid fb",
        soundcloud: "not valid sd"
      }
    }


    test "update_user/3 with invalid data done by admin returns error changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.update_user(user, @invalid_update_attrs, %User{admin: true})
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.facebook
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.soundcloud
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.youtube
    end

    test "update_user/3 with invalid data done by user returns error changeset" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.update_user(user, @invalid_update_attrs, %User{admin: false})
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.facebook
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.soundcloud
      assert "invalid url: :no_scheme" in errors_on(changeset).detail.youtube
    end

    test "update_user/3 with valid data done by admin updates the user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs, %User{admin: true})

      assert user.email == "dummy@bshit.com"
      assert user.name == "update name"
      assert user.djname == "update djname"
      assert user.user_country == "update country"
      assert user.admin == true
      assert user.profil_djvip == true
      assert user.profil_dj == true
      assert user.deactivated == true
      assert user.activated_at == nil

      assert user.parameter.new_song_notification == true
      assert user.parameter.piwik == false
      assert user.parameter.video == true
      assert user.parameter.radioking_unmatch == true

      assert user.detail.description == "update description"
      assert user.detail.favorite_genre == "soul"
      assert user.detail.favorite_artist == "update favorite artist"
      assert user.detail.favorite_color == "update favorite color"
      assert user.detail.favorite_meal == "update favorite meal"
      assert user.detail.favorite_animal == "update favorite animal"
      assert user.detail.djing_start_year == 2000
      assert user.detail.love_more == "update love more"
      assert user.detail.hate_more == "update hate more"
      assert user.detail.youtube == "http://update.youtube.fr"
      assert user.detail.facebook == "http://update.facebook.fr"
      assert user.detail.soundcloud == "http://update.soundcloud.fr"
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
      assert user.deactivated == false
      assert user.activated_at == nil

      assert user.parameter.new_song_notification == true
      assert user.parameter.piwik == true
      assert user.parameter.video == false
      assert user.parameter.radioking_unmatch == false

      assert user.detail.description == "update description"
      assert user.detail.favorite_genre == "soul"
      assert user.detail.favorite_artist == "update favorite artist"
      assert user.detail.favorite_color == "update favorite color"
      assert user.detail.favorite_meal == "update favorite meal"
      assert user.detail.favorite_animal == "update favorite animal"
      assert user.detail.djing_start_year == 2000
      assert user.detail.love_more == "update love more"
      assert user.detail.hate_more == "update hate more"
      assert user.detail.youtube == "http://update.youtube.fr"
      assert user.detail.facebook == "http://update.facebook.fr"
      assert user.detail.soundcloud == "http://update.soundcloud.fr"
    end
  end
end
