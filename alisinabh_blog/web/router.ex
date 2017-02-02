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

    get "/", PageController, :index
    get "/admin", AdminController, :login
    post "/admin/login", AdminController, :login_check
  end

  # Other scopes may use custom stacks.
  # scope "/api", AlisinabhBlog do
  #   pipe_through :api
  # end
end
