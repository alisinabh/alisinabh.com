defmodule AlisinabhBlog.AdminController do
  use AlisinabhBlog.Web, :controller
  import AlisinabhBlog.Database

  def login(conn, _params) do
    case get_session(conn, :auth) do
      true ->
        redirect conn, to: "/admin/posts"
      _ ->
        conn = conn |> put_status(401)
        render(conn, "login.html")
    end
  end

  def login_check(conn, %{"username" => username, "password" => password}) do
    case {username, password} do
      {"admin", "admin"} -> conn = conn
        |> put_session(:auth, true)
        redirect conn, to: "/admin"
      _ -> conn = conn |> put_status(403)
        text conn, "Wrong authentication data!"
    end
  end

  def posts(conn, _params) do
    case check_auth(conn) do
      :ok ->
        render conn, "posts.html", posts: get_new_posts(20), last_item: 1
      _ -> conn
    end
  end

  def new(conn, _params) do
    case check_auth(conn) do
      :ok ->
        render conn, "new.html", date: 0, title: "", content: ""
      _ -> conn
    end
  end
  
  def save_post(conn, %{"date" => date, "title" => title, "content" => content}) do
    case check_auth(conn) do
      :ok ->
        :ok = upsert_post(date, title, content)
        redirect conn, to: "/admin/posts"
      _ -> conn
    end
  end

  def save_post(conn, %{"title" => title, "content" => content}) do
     case check_auth(conn) do
       :ok ->
         :ok = upsert_post(:os.system_time(:millisecond), title, content)
         redirect conn, to: "/admin/posts"
       _ -> conn
     end
  end
  
  def edit(conn, %{"date" => date}) do
     case check_auth(conn) do
        :ok ->
          post = get_post_by_date(date, true)
          render conn, "new.html", title: post.title, content: post.body, date: date
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
  
  # def new(conn, _params) do
  #   changeset = Admin.changeset(%Admin{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"admin" => admin_params}) do
  #   changeset = Admin.changeset(%Admin{}, admin_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _admin} ->
  #       conn
  #       |> put_flash(:info, "Admin created successfully.")
  #       |> redirect(to: admin_path(conn, :index))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   admin = Repo.get!(Admin, id)
  #   changeset = Admin.changeset(admin)
  #   render(conn, "edit.html", admin: admin, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "admin" => admin_params}) do
  #   admin = Repo.get!(Admin, id)
  #   changeset = Admin.changeset(admin, admin_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, admin} ->
  #       conn
  #       |> put_flash(:info, "Admin updated successfully.")
  #       |> redirect(to: admin_path(conn, :show, admin))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", admin: admin, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   admin = Repo.get!(Admin, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(admin)
  #
  #   conn
  #   |> put_flash(:info, "Admin deleted successfully.")
  #   |> redirect(to: admin_path(conn, :index))
  # end
end
