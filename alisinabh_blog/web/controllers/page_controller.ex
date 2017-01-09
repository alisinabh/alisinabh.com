defmodule AlisinabhBlog.PageController do
  use AlisinabhBlog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
