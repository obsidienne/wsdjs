defmodule BrididiWeb.CloudexImageHelper do
  import Phoenix.HTML.Tag

  def cl_image_tag(public_id, options \\ []) do
    transformation_options =
      if Keyword.has_key?(options, :transforms) do
        options[:transforms]
      else
        [%{}]
      end

    image_tag_options = Keyword.delete(options, :transforms)

    defaults = [
      src: Cloudex.Url.for(public_id, transformation_options),
      alt: "image with name #{public_id}"
    ]

    attributes = Keyword.merge(defaults, image_tag_options)

    tag(:img, attributes)
  end
end
