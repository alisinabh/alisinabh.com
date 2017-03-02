defmodule Alisinabh.Router do
  use Alisinabh.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Alisinabh do
    pipe_through :browser # Use the default browser stack

    # index
    get "/", PostController, :news

    # /post
    get "/post/:date/*path", PostController, :view_post

    # /admin
    get "/admin", AdminController, :login
    post "/admin/login", AdminController, :login_check
    get "/admin/logout", AdminController, :logout

    get "/admin/posts", AdminController, :posts

    get "/admin/new", AdminController, :new
    post "/admin/new", AdminController, :save_post

    get "/admin/edit/:date", AdminController, :edit
    post "/admin/edit/:date", AdminController, :save_post

    get "/admin/deletePost/:date", AdminController, :delete_post

    # /feed
    get "/feed", FeedController, :feed
  end

  # Other scopes may use custom stacks.
  # scope "/api", Alisinabh do
  #   pipe_through :api
  # end
end
