defmodule Alisinabh.PostController do
  use Alisinabh.Web, :controller
  import Alisinabh.Database

  def news(conn, _params) do
    posts = get_new_posts(20)

    render conn, "index.html", posts: posts, last_item: Alisinabh.Helpers.get_last_post_id(posts), title: "List of posts"
  end

  def view_post(conn, %{"date" => date}) do
    post = get_post_by_date(date)

    og_data = {:ogv1, "article", post.title,
      (Regex.replace(~r/<[^>]*>/, post.body, "") |> String.replace("\n", "") |> String.slice(0, 152)) <> "...", "https://alisinabh.com/post/#{post.date}/#{Alisinabh.Helpers.urlify_string(post.title)}"}

    render conn, "post.html", post: post, title: post.title, og_data: og_data
  end
end
