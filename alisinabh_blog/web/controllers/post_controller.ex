defmodule AlisinabhBlog.PostController do
  use AlisinabhBlog.Web, :controller
  import AlisinabhBlog.Database

  def view_post(conn, %{"date" => date}) do
    post = get_post_by_date(date)
    render conn, "post.html", post: post
  end
end
