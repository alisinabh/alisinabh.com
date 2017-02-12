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
  def get_new_posts(limit \\ 10, skip \\ 0) do
    {:ok, files} = File.ls(@repopath)

    files = files |>
      Enum.sort |>
      Enum.drop(skip) |>
      Enum.take(limit)

    Enum.reduce(files, [], fn(file, acc) ->
        [get_post_in_file(file) | acc]
      end)
  end

  def get_post_by_date(date, md \\ false) do
    get_post_in_file("#{date}.post", true, md)
  end

  def get_post_in_file(file, complete \\ false, md \\ false) do
    {:ok, filedata} = Path.join(@repopath, file ) |> File.read
    [timestamp, title | postbody] = filedata |> String.split("\n")
    {:ok, date} = timestamp |> String.to_integer |> DateTime.from_unix(:milliseconds)
    post = %{id: timestamp, date: date, title: title, body: nil}
    
    if md do
      %{post | body: postbody}
    else
      %{post | body: Enum.join(postbody, "\n") |> parse_alchemist_markdown}
    end
  end

  def upsert_post(creationdate, title, postbody) do
    {:ok, file} = Path.join(@repopath, "#{creationdate}.post") |> File.open([:write])
    IO.write(file, "#{creationdate}\n#{title}\n#{postbody}")
  end

  defp parse_alchemist_markdown(text) do
    text
     |> Earmark.to_html
     |> parse_md_alchemist_tuple
  end

  defp parse_md_alchemist_tuple(text) do
    text
     |> String.replace("T{:", "{<span class=\"c-mod\">:</span><span class=\"c-tup\">")
     |> String.replace("T, :", "</span>, <span class=\"c-mod\">:</span><span class=\"c-tup\">")
     |> String.replace("}T", "</span>}")
  end
end
