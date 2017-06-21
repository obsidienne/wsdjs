defmodule Wsdjs.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :wsdjs
  use Scrivener, page_size: 50
end
