defmodule AlisinabhBlog.PageController do
  use AlisinabhBlog.Web, :controller
  import AlisinabhBlog.Database

  def index(conn, _params) do
    render conn, "index.html", posts: get_new_posts 20
  end
end
