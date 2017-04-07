defmodule Alisinabh.Helpers do
  @moduledoc """
  Helpers for getting information about blog posts
  """

  @doc """
  Determines the last Id of a post for on demand reload.
  If posts length is lower than page size returns ``nil``
  """
  def get_last_post_id(posts, page_size \\ 20) do
    cond do
      Enum.count(posts) < page_size -> nil
      true -> List.last(posts).id
    end
  end

  @doc """
  Convert a string to a url friendly form.

  ## Parameters
    - text: The string you want to convert

  ## Examples
    iex> Alisinabh.Helpers.urlify_string " hello * i am_09 Star SHIP:D )(*&^%$#@!})))"
    "hello_i_am_09_Star_SHIPD"
  """
  def urlify_string(text) do
    text |>
      String.replace(~r/[^a-zA-Z0-9-_ ]/, "") |>
      String.trim |>
      String.replace(~r/\s\s+/, " ") |>
      String.replace(" ", "_") |>
      String.slice(0, 50)
  end

  @doc """
  Changes a post publish state if needed from admin entry
  """
  def publish_procedure(post_date, pub_state) do
    unpub_path = post_date |> post_path_by_date(false)
    pub_path = post_date |> post_path_by_date

    if pub_state do
      # publish post
      if File.exists?(unpub_path) do
        File.rename(unpub_path, pub_path)
      end
    else
      # unpublish post
      if File.exists?(pub_path) do
        File.rename(pub_path, unpub_path)
      end
    end
  end

  @doc """
  Gets a post path by post date and publish state
  """
  def post_path_by_date(post_date, is_published \\ true) do
    if is_published do
      Path.join(Alisinabh.Database.repopath, "#{post_date}.post")
    else
      Path.join(Alisinabh.Database.repopath, "d#{post_date}.post")
    end
  end
end
