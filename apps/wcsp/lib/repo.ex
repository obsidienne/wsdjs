defmodule Wcsp.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :wcsp
  use Scrivener, page_size: 20
end
