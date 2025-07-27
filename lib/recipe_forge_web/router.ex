defmodule RecipeForgeWeb.Router do
  use RecipeForgeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RecipeForgeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RecipeForgeWeb do
    pipe_through :browser

    live "/", RecipeLive.Index, :index

    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit

    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit

    live "/ingredients", IngredientLive.Index, :index
    live "/ingredients/new", IngredientLive.Index, :new
    live "/ingredients/:id/edit", IngredientLive.Index, :edit

    live "/ingredients/:id", IngredientLive.Show, :show
    live "/ingredients/:id/show/edit", IngredientLive.Show, :edit

    live "/recipes", RecipeLive.Index, :index
    live "/recipes/new", RecipeLive.Index, :new
    live "/recipes/:id/edit", RecipeLive.Index, :edit

    live "/recipes/:id", RecipeLive.Show, :show
    live "/recipes/:id/show/edit", RecipeLive.Show, :edit
    live "/recipes/:id/cooking", CookingLive.Show, :show

    live "/browse", BrowseLive.Index, :index
    live "/search", SearchLive.Index, :index
    live "/favorites", FavoritesLive.Index, :index

    live "/ai_generate", AiGenerateLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecipeForgeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:recipe_forge, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RecipeForgeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
