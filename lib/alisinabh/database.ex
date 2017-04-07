defmodule Alisinabh.Database do
  @moduledoc """
  This module handles the repository of posts on the blog
  Posts are save in below format:

  1. First line: Post timestamp in UNIX format.
  2. Second line: Post title, only one line
  3. All other lines: Postbody in a markdown format
  """

  alias Alisinabh.Helpers

  @repopath Application.get_env(:alisinabh, :repo_path)

  def repopath do
    @repopath
  end

  @doc """
  get_posts returns posts ordered descending by their timestamp.

  ## Parameters:
    - limit: number of posts to return
  """
  def get_new_posts(limit \\ 10, skip \\ 0, drafts \\ false) do
    {:ok, files} = File.ls(@repopath)

    files2 = case drafts do
      true ->
        files
      _ ->
        Enum.reduce(files, fn(file, acc) ->
          if String.starts_with?(file, "d") do
            acc
          else
            [file | acc]
          end
        end)
    end

    files = files |>
      Enum.sort |>
      Enum.drop(skip) |>
      Enum.take(limit)

    Enum.reduce(files, [], fn(file, acc) ->
        [get_post_in_file(Path.join(@repopath, file)) | acc]
      end)
  end

  @doc """
  Returns a post by it's identifire (Post date in milliseconds)
  """
  def get_post_by_date(date, md \\ false) do
    Helpers.post_path_by_date(date) |> get_post_in_file(true, md)
  end

  @doc """
  Parses a post file into map
  """
  def get_post_in_file(file, complete \\ false, md \\ false) do
    {:ok, filedata} = File.read(file)
    [timestamp, title | postbody] = filedata |> String.split("\n")
    {:ok, date} = timestamp |> String.to_integer |> DateTime.from_unix(:milliseconds)
    post = %{id: timestamp, date: date, title: title, body: nil}

    if file |> Path.basename |> String.starts_with?("d") do
      post = %{post | title: "DRAFT: #{post.title}"}
    end

    if md do
      %{post | body: postbody}
    else
      %{post | body: Enum.join(postbody, "\n") |> parse_alchemist_markdown}
    end
  end

  @doc """
  Inserts or updates a post
  """
  def upsert_post(creationdate, title, postbody, publish) do
    {:ok, file} = Helpers.post_path_by_date(creationdate, publish) |> File.open([:write])
    IO.write(file, "#{creationdate}\n#{title}\n#{postbody}")
  end

  @doc """
  Removes a post by drafting its file
  """
  def remove_post(date) do
    Helpers.post_path_by_date(date) |> File.rename(Helpers.post_path_by_date(date, false))
  end

  defp parse_alchemist_markdown(text) do
    text
     |> Earmark.as_html!
     |> parse_md_alchemist_tuple
  end

  defp parse_md_alchemist_tuple(text) do
    text
     |> String.replace("T{:", "{<span class=\"c-mod\">:</span><span class=\"c-tup\">")
     |> String.replace("T, :", "</span>, <span class=\"c-mod\">:</span><span class=\"c-tup\">")
     |> String.replace("}T", "</span>}")
  end
end
