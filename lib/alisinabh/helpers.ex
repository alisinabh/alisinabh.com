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
end
