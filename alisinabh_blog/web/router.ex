defmodule AlisinabhBlog.Router do
  use AlisinabhBlog.Web, :router

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

  scope "/", AlisinabhBlog do
    pipe_through :browser # Use the default browser stack

    get "/", PageContproller, :index
    get "/post/:date/*path", PostController, :view_post
    
    get "/admin", AdminController, :login
    post "/admin/login", AdminController, :login_check
    get "/admin/posts", AdminController, :posts
    get "/admin/new", AdminController, :new
    post "/admin/new", AdminController, :save_post
    get "/admin/edit/:date", AdminController, :edit
    post "/admin/edit/:date", AdminController, :save_post
    get "/admin/deletePost/:date", AdminController, :delete_post

    get "/feed", FeedController, :feed
  end

  # Other scopes may use custom stacks.
  # scope "/api", AlisinabhBlog do
  #   pipe_through :api
  # end
end
