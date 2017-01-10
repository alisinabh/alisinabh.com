defmodule AlisinabhBlog.Database do
  @moduledoc """
  This module handles the repository of posts on the blog
  Posts are save in below format:

  1. First line: Post timestamp in UNIX format.
  2. Second line: Post title, only one line
  3. All other lines: Postbody in a markdown format
  """

  @repopath Application.get_env(:alisinabh_blog, :repo_path)

  @doc """
  get_posts returns posts ordered descending by their timestamp.

  ## Parameters:
    - limit: number of posts to return
  """
  def get_new_posts(limit \\ 10) do
    {:ok, files} = File.ls(@repopath)

    files = files |>
      Enum.sort

      Enum.reduce(files, [], fn(file, acc) ->
        {:ok, filedata} = Path.join(@repopath, file) |> File.read
        [timestamp, title | postbody] = filedata |> String.split("\n")
        [%{date: String.to_integer(timestamp), title: title, body: Enum.join(postbody, "\n") |> Earmark.to_html} | acc]
      end)
  end
end
