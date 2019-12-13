## Rails Has and Belongs to Many Relationship

Let's build a recipes app where a recipe has and belongs to many ingredients and an ingredient has and belongs to many recipes.

<br>

## Create New Rails App

1. `rails new recipe_app -d mysql`
1. `rails g model recipe name`
1. `rails g model ingredient name`
1. `rails g migration CreateJoinTableRecipesIngredients recipe ingredient` 
 
   > check out the `db/migrate` folder  

1. `rails db:setup`
1. `rails db:migrate`
1. `rails s`

<br>

## Setup the model associations
 
`models/recipe.rb`

  ```ruby
  class Recipe < ApplicationRecord
    has_and_belongs_to_many :ingredients
  end
  ```

`models/ingredient.rb`

  ```ruby
  class Ingredient < ApplicationRecord
    has_and_belongs_to_many :recipes
  end
  ```

<br>

## Create some seed data

`db/seeds.rb`

  ```ruby
  Recipe.destroy_all
  Ingredient.destroy_all

  pizza = Recipe.create(name: "Pizza")
  grilled_cheese = Recipe.create(name: "grilled cheese")

  grilled_cheese.Ingredients.create(name: "Pickles")

  pizza.ingredients.create(name: "tomato sauce")
  pizza.ingredients.create(name: "pepperoni")

  cheese = pizza.ingredients.create(name: "cheese")
  mushrooms = pizza.ingredients.create(name: "mushrooms")

  grilled_cheese.ingredients << [cheese, tomato]
  ```
  <br>
  Note: Ingredients I needs to be small<br>
  Note: Fix tomato error
<br><br><br>

1. `rails db:seed`
1. `rails c`
1. `pizza = Recipe.first`
1. `pizza.ingredients`
1. `pizza.ingredients.create(name: "peppers")`

<br>
Note: Sometimes this happens. Create command works well with some version but may not work with other versions.<br>
We always have MySQL query to fix this.
<br>
<br>
So, what would be the query?
<br>
<br>
<br>
<hr>

```ruby
update recipeapp_development.ingredients 
SET name = "peppers"
where id = 
```

<br>
<hr>
<br>

## Create Routes

```ruby
Rails.application.routes.draw do
  root 'recipes#index'
  resources :recipes, :ingredients
end
```

<br>

## Recipes Controller

`rails g controller recipes`

```ruby
class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    # This code below has a quick demo of how to form a json object with nested ingredients on a recipe.
    render json: @recipe, include: :ingredients
  end
end
```

<br>

## Recipe Show View

```html
<h1><%= @recipe.name %></h1>

<ul>
<% @recipe.ingredients.each do |i| %>
  <li><%= i.name %></li>
  <% end %>
</ul>
```

<br>

## Recipe New View

```html
<%= form_for(@recipe) do |f| %>
  <p>
    <%= f.label :name, "Recipe Name" %>
    <%= f.text_field :name %>
  </p>

  <div>
  <%= f.collection_check_boxes(:ingredient_ids, Ingredient.all, :id, :name) do |i| %>
    <%= i.label %>
    <%= i.label { i.check_box } %>
  <% end %>
 </div>

  <p>
    <%= f.submit 'Create' %>
  </p>
<% end %>

<%= link_to 'Back', recipes_path %>
```

<br>

## Recipes Controller Create Method

The key here is to add `:ingredient_ids => []` to the `recipe_params` method.

```ruby
class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    # render json: @recipe, include: :ingredients
  end

  def new
    @recipe = Recipe.new
  end

  def create
    puts params
    @recipe = Recipe.create(recipe_params)
    redirect_to @recipe
  end

  private

    def recipe_params
      params.require(:recipe).permit(:name, :ingredient_ids => [])
    end
end
```

<br>

<details>
<summary>Add Devise</summary>
	
<br>


[Devise](http://devise.plataformatec.com.br/)

1. Add to `Gemfile`: `gem 'devise'`
1. Run Command: `gem install devise`
1. Run Command: `rails generate devise:install`

    ![](https://i.imgur.com/tmAeS1v.png)

1. In `config/environments/development.rb`:

		config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } 

1. `rails generate devise User`
1. `rails db:migrate`

Take a moment review to review and check out the files/folders that were generated.

<br><br>

Note: Restart the rails server
<br><br>
## Add a User

1. `http://localhost:3000/users/sign_in`

    ![](https://i.imgur.com/HbnJ79w.png)

1. click `Sign Up`

    ![](https://i.imgur.com/zdTJG1X.png)

1. Check out the [Devise Docs here](http://devise.plataformatec.com.br/#controller-filters-and-helpers) for what happens after a User logs in.

<br>

## Nav

1. Create `views/layouts/_nav.html.erb`:

    ```html
      <p class="navbar-text pull-right">
      <% if user_signed_in? %>
        Logged in as <strong><%= current_user.email %></strong>.
        <%= link_to 'Edit profile', edit_user_registration_path, :class => 'navbar-link' %> |
        <%= link_to "Logout", destroy_user_session_path, method: :delete, :class => 'navbar-link'  %>
      <% else %>
        <%= link_to "Sign up", new_user_registration_path, :class => 'navbar-link'  %> |
        <%= link_to "Login", new_user_session_path, :class => 'navbar-link'  %>
      <% end %>
      </p>
      <% if notice %>
        <p class="alert alert-success"><%= notice %></p>
      <% end %>
      <% if alert %>
        <p class="alert alert-danger"><%= alert %></p>
      <% end %>
    ```

1. Update `views/layouts/application.html.erb`. We'll also add Bootstrap.

```html
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
...      
<body>
        <%= render 'layouts/nav' %>
        <%= yield %>
		</body>
```

<br>

## Update the Recipe index

1. Update your Recipe index method:

    ```ruby
    def index
      @recipes = Recipe.all
    end
    ```

1. Create a `views/recipes/index.html.erb` file and add the following:

    ```html
    <h1><%= current_user.email %>'s Recipes</h1>
    ```

1. Create a loop to display the recipes:

    ```html
    <h1><%= current_user.email %>'s Recipes</h1>

    <ul>
      <% @recipes.each do |recipe| %>
        <li><%= recipe.name %></li>
      <% end %>
    </ul>
    ```

<br>

## Display only the `current_user`'s recipes.

1. Create a migration to add `user_id` to a recipe: `rails g migration AddUserIdToRecipes user:references`
1. `rails db:migrate`

<br><br>
Note: You may get error of foreign key or duplicate id 'user_id'. To fix this, exceute: <br>
rake db:reset <br>
rails db:migrate <br>

But it will delete all the data as well.<br>
Run rails db:seed will also not work, becuase now user_id is a part of recipe table.

1. Create a new user again.
2. Add that user_id in seeds.rb file.

```ruby
pizza = Recipe.create(name: "Pizza", user_id: 1)
grilled_cheese = Recipe.create(name: "grilled cheese", user_id: 1)
```

<br><br><br>

1. Add the associations to models:

    ```ruby
    class User < ApplicationRecord
      has_many :recipes
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
      devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
    end

    class Recipe < ApplicationRecord
      belongs_to :user
      has_and_belongs_to_many :ingredients
    end
    ```

## Configure Recipes Controller

1. `before_action :authenticate_user!`

1. Update create method

    ```ruby
     def create    
      @recipe = Recipe.new(recipe_params) 
      @recipe.user_id = current_user.id
      @recipe.save
      redirect_to @recipe
    end
    ```

1. index method

    ```ruby
     def index
      # @recipes = Recipe.all
      @recipes = Recipe.where(user_id: current_user.id)
    end
    ```


</details>

<br>

## You Do

Using this lesson as a guide, create a new app where a `person` has and belongs to many `groups`.

<br>

## Additional Resources

- [Rails Guides - Has and Belongs to Many](https://guides.rubyonrails.org/association_basics.html#the-has-and-belongs-to-many-association)
- [Collection Check Boxes Helper](https://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/collection_check_boxes)
- [Devise](http://devise.plataformatec.com.br/)
- [Devise](https://guides.railsgirls.com/devise)
