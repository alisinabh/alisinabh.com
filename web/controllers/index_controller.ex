defmodule Alisinabh.IndexController do
  use Alisinabh.Web, :controller
  import Alisinabh.Database

  def index(conn, _params) do
    posts = get_new_posts(20)

    last_item_id = case List.last(posts) do
      nil -> nil
      post -> post.id
    end

    render conn, "index.html", posts: posts, last_item: last_item_id
  end
end
