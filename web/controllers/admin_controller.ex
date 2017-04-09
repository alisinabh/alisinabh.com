defmodule Alisinabh.AdminController do
  use Alisinabh.Web, :controller
  import Alisinabh.Database

  @auth_user Application.get_env(:alisinabh, :author_user)
  @auth_pass Application.get_env(:alisinabh, :author_pass)

  def login(conn, _params) do
    case get_session(conn, :auth) do
      true ->
        redirect conn, to: "/admin/posts"
      _ ->
        conn = conn |> put_status(401)
        render conn, "login.html", title: "Login"
    end
  end

  def login_check(conn, %{"username" => username, "password" => password}) do
    case {username, password} do
      {@auth_user, @auth_pass} -> conn = conn
        |> put_session(:auth, true)
        redirect conn, to: "/admin"
      _ -> conn = conn |> put_status(403)
        text conn, "Wrong authentication data!"
    end
  end

  def logout(conn, _params) do
    conn = conn |> put_session(:auth, false)
    redirect conn, to: "/"
  end

  def posts(conn, _params) do
    case check_auth(conn) do
      :ok ->
        posts = get_new_posts(20, 0, true)
        render conn, "posts.html", posts: posts, last_item: Alisinabh.Helpers.get_last_post_id(posts), title: "Admin: List of posts"
      _ -> conn
    end
  end

  def new(conn, _params) do
    case check_auth(conn) do
      :ok ->
        render conn, "new.html", date: 0, post_title: "", content: "", title: "Admin: New post"
      _ -> conn
    end
  end

  def save_post(conn, %{"date" => date, "post_title" => title, "content" => content}) do
    case check_auth(conn) do
      :ok ->
        :ok = upsert_post(date, title, content, true)
        redirect conn, to: "/admin/posts"
      _ -> conn
    end
  end

  def save_post(conn, %{"post_title" => title, "content" => content}) do
     case check_auth(conn) do
       :ok ->
         :ok = upsert_post(:os.system_time(:millisecond), title, content, true)
         redirect conn, to: "/admin/posts"
       _ -> conn
     end
  end

  def edit(conn, %{"date" => date}) do
    case check_auth(conn) do
      :ok ->
        require IEx
        IEx.pry
        post = get_post_by_date(date, true)
        render conn, "new.html", post_title: post.title, content: post.body, date: date, title: "Admin: Edit post"
      _ -> conn
    end
  end

  def delete_post(conn, %{"date" => date}) do
    case check_auth(conn) do
      :ok ->
        :ok = remove_post(date)
        redirect conn, to: "/admin/posts"
      _ -> conn
    end
  end

  defp check_auth(conn) do
    case get_session(conn, :auth) do
      true ->
        :ok
      _ ->
        conn = conn |> put_status(401)
        redirect conn, to: "/admin/"
        :unauth
    end
  end
end
