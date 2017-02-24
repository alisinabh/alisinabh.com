defmodule Alisinabh.FeedController do
  use Alisinabh.Web, :controller
  import Alisinabh.Database

  def feed(conn, _params) do
    posts = get_new_posts(1000)
    conn
     |> put_layout(:none)
     |> put_resp_content_type("application/xml")
     |> render("feed.xml", posts: posts)
  end
end
