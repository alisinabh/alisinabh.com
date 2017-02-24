defmodule Alisinabh.PostController do
  use Alisinabh.Web, :controller
  import Alisinabh.Database

  def view_post(conn, %{"date" => date}) do
    post = get_post_by_date(date)
    render conn, "post.html", post: post
  end
end
