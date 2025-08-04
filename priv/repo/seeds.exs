# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RecipeForge.Repo.insert!(%RecipeForge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RecipeForge.Recipes

# Clear existing data if needed (uncomment if you want to reset)
# RecipeForge.Repo.delete_all(RecipeForge.Recipes.RecipeIngredient)
# RecipeForge.Repo.delete_all("recipe_categories")
# RecipeForge.Repo.delete_all(RecipeForge.Recipes.Recipe)
# RecipeForge.Repo.delete_all(RecipeForge.Ingredients.Ingredient)
# RecipeForge.Repo.delete_all(RecipeForge.Categories.Category)

IO.puts("Creating seed recipes...")

# Recipe 1: Classic Spaghetti Carbonara
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Classic Spaghetti Carbonara",
    "description" =>
      "A traditional Italian pasta dish with eggs, cheese, pancetta, and black pepper",
    "instructions" => [
      "Bring a large pot of salted water to boil. Cook spaghetti according to package directions until al dente.",
      "Meanwhile, cook pancetta in a large skillet over medium heat until crispy.",
      "Whisk eggs, Parmesan cheese, and black pepper in a large bowl.",
      "Drain pasta, reserving 1 cup pasta water. Add hot pasta to egg mixture, tossing quickly.",
      "Add pancetta and enough pasta water to create a creamy sauce.",
      "Serve immediately with extra Parmesan and black pepper."
    ],
    "prep_time" => "15 minutes",
    "cook_time" => "20 minutes",
    "servings" => 4,
    "yield_description" => "4 servings",
    "category_tags" => "Italian,Pasta,Dinner",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "spaghetti",
        "quantity" => 1.0,
        "unit" => "lb"
      },
      "1" => %{
        "ingredient_name" => "pancetta",
        "quantity" => 6.0,
        "unit" => "oz",
        "notes" => "diced"
      },
      "2" => %{
        "ingredient_name" => "large eggs",
        "quantity" => 3.0,
        "unit" => "whole"
      },
      "3" => %{
        "ingredient_name" => "parmesan cheese",
        "quantity" => 1.0,
        "unit" => "cup",
        "notes" => "grated"
      },
      "4" => %{
        "ingredient_name" => "black pepper",
        "quantity" => 1.0,
        "unit" => "tsp",
        "notes" => "freshly ground"
      }
    }
  })

# Recipe 2: Chicken Vegetable Stir Fry
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Chicken Vegetable Stir Fry",
    "description" => "Quick and healthy stir fry with tender chicken and crisp vegetables",
    "instructions" => [
      "Cut chicken into bite-sized pieces and season with salt and pepper.",
      "Prepare all vegetables by cutting into uniform pieces.",
      "Heat oil in large wok or skillet over high heat.",
      "Stir-fry chicken until cooked through, remove and set aside.",
      "Stir-fry vegetables in order of cooking time needed, starting with hardest.",
      "Return chicken to pan, add sauce and toss to combine.",
      "Cook 1-2 minutes until sauce thickens.",
      "Serve immediately over steamed rice."
    ],
    "prep_time" => "20 minutes",
    "cook_time" => "15 minutes",
    "servings" => 4,
    "yield_description" => "4 servings",
    "category_tags" => "Asian,Chicken,Dinner,Healthy",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "chicken breast",
        "quantity" => 1.0,
        "unit" => "lb",
        "notes" => "cut into strips"
      },
      "1" => %{
        "ingredient_name" => "bell peppers",
        "quantity" => 2.0,
        "unit" => "medium",
        "notes" => "sliced"
      },
      "2" => %{
        "ingredient_name" => "broccoli",
        "quantity" => 2.0,
        "unit" => "cups",
        "notes" => "florets"
      },
      "3" => %{
        "ingredient_name" => "carrots",
        "quantity" => 2.0,
        "unit" => "medium",
        "notes" => "sliced"
      },
      "4" => %{
        "ingredient_name" => "soy sauce",
        "quantity" => 3.0,
        "unit" => "tbsp"
      },
      "5" => %{
        "ingredient_name" => "vegetable oil",
        "quantity" => 2.0,
        "unit" => "tbsp"
      }
    }
  })

# Recipe 3: Classic Chocolate Chip Cookies
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Classic Chocolate Chip Cookies",
    "description" => "Soft and chewy chocolate chip cookies with crispy edges",
    "instructions" => [
      "Preheat oven to 375°F and line baking sheets with parchment paper.",
      "Cream butter and both sugars until light and fluffy.",
      "Beat in eggs and vanilla extract.",
      "Mix in flour, baking soda, and salt until just combined.",
      "Stir in chocolate chips.",
      "Drop rounded tablespoons of dough onto prepared baking sheets.",
      "Bake for 9-11 minutes until edges are golden brown.",
      "Cool on baking sheet for 5 minutes before transferring to wire rack."
    ],
    "prep_time" => "15 minutes",
    "cook_time" => "12 minutes",
    "servings" => 12,
    "yield_description" => "24 cookies",
    "category_tags" => "Dessert,Cookies,American",
    "is_favorite" => true,
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "butter",
        "quantity" => 1.0,
        "unit" => "cup",
        "notes" => "softened"
      },
      "1" => %{
        "ingredient_name" => "brown sugar",
        "quantity" => 0.75,
        "unit" => "cup",
        "notes" => "packed"
      },
      "2" => %{
        "ingredient_name" => "white sugar",
        "quantity" => 0.25,
        "unit" => "cup"
      },
      "3" => %{
        "ingredient_name" => "eggs",
        "quantity" => 2.0,
        "unit" => "large"
      },
      "4" => %{
        "ingredient_name" => "vanilla extract",
        "quantity" => 2.0,
        "unit" => "tsp"
      },
      "5" => %{
        "ingredient_name" => "all-purpose flour",
        "quantity" => 2.25,
        "unit" => "cups"
      },
      "6" => %{
        "ingredient_name" => "baking soda",
        "quantity" => 1.0,
        "unit" => "tsp"
      },
      "7" => %{
        "ingredient_name" => "salt",
        "quantity" => 1.0,
        "unit" => "tsp"
      },
      "8" => %{
        "ingredient_name" => "chocolate chips",
        "quantity" => 2.0,
        "unit" => "cups"
      }
    }
  })

# Recipe 4: Greek Village Salad
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Greek Village Salad",
    "description" => "Fresh Mediterranean salad with tomatoes, cucumber, olives, and feta cheese",
    "instructions" => [
      "Cut tomatoes into wedges and cucumber into thick slices.",
      "Slice red onion thinly.",
      "Combine tomatoes, cucumber, onion, and olives in a large bowl.",
      "Add crumbled feta cheese on top.",
      "Drizzle with olive oil and red wine vinegar.",
      "Season with oregano, salt, and pepper.",
      "Toss gently and serve immediately."
    ],
    "prep_time" => "15 minutes",
    "cook_time" => "0 minutes",
    "servings" => 4,
    "yield_description" => "4 side servings",
    "category_tags" => "Greek,Salad,Vegetarian,Mediterranean",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "tomatoes",
        "quantity" => 4.0,
        "unit" => "large",
        "notes" => "cut into wedges"
      },
      "1" => %{
        "ingredient_name" => "cucumber",
        "quantity" => 1.0,
        "unit" => "large",
        "notes" => "sliced"
      },
      "2" => %{
        "ingredient_name" => "red onion",
        "quantity" => 0.5,
        "unit" => "medium",
        "notes" => "thinly sliced"
      },
      "3" => %{
        "ingredient_name" => "kalamata olives",
        "quantity" => 0.5,
        "unit" => "cup"
      },
      "4" => %{
        "ingredient_name" => "feta cheese",
        "quantity" => 4.0,
        "unit" => "oz",
        "notes" => "crumbled"
      },
      "5" => %{
        "ingredient_name" => "olive oil",
        "quantity" => 0.25,
        "unit" => "cup",
        "notes" => "extra virgin"
      },
      "6" => %{
        "ingredient_name" => "red wine vinegar",
        "quantity" => 2.0,
        "unit" => "tbsp"
      },
      "7" => %{
        "ingredient_name" => "dried oregano",
        "quantity" => 1.0,
        "unit" => "tsp"
      }
    }
  })

# Recipe 5: Classic Margherita Pizza
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Classic Margherita Pizza",
    "description" => "A traditional Italian pizza with fresh tomatoes, mozzarella, and basil",
    "instructions" => [
      "Preheat oven to 475°F (245°C)",
      "Roll out pizza dough on floured surface",
      "Spread tomato sauce evenly over dough",
      "Add fresh mozzarella cheese and torn basil leaves",
      "Drizzle with olive oil and season with salt and pepper",
      "Bake for 12-15 minutes until crust is golden and cheese is bubbly",
      "Let cool for 2-3 minutes before slicing"
    ],
    "prep_time" => "20 minutes",
    "cook_time" => "15 minutes",
    "servings" => 4,
    "yield_description" => "1 large pizza",
    "category_tags" => "Italian,Pizza,Dinner",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "pizza dough",
        "quantity" => 1,
        "unit" => "pound"
      },
      "1" => %{
        "ingredient_name" => "tomato sauce",
        "quantity" => 0.5,
        "unit" => "cup"
      },
      "2" => %{
        "ingredient_name" => "fresh mozzarella",
        "quantity" => 8,
        "unit" => "oz"
      },
      "3" => %{
        "ingredient_name" => "fresh basil",
        "quantity" => 0.25,
        "unit" => "cup",
        "notes" => "torn leaves"
      },
      "4" => %{
        "ingredient_name" => "olive oil",
        "quantity" => 2,
        "unit" => "tbsp"
      }
    }
  })

# Recipe 6: Beef Tacos
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Beef Tacos",
    "description" => "Classic Mexican-style ground beef tacos with traditional toppings",
    "instructions" => [
      "Brown ground beef in a large skillet over medium-high heat.",
      "Add onion and cook until softened, about 3 minutes.",
      "Add garlic, cumin, chili powder, and paprika. Cook for 1 minute.",
      "Add tomatoes, salt, and pepper. Simmer for 10 minutes.",
      "Warm tortillas in dry skillet or microwave.",
      "Fill tortillas with beef mixture.",
      "Top with lettuce, tomatoes, cheese, and sour cream.",
      "Serve with lime wedges."
    ],
    "prep_time" => "15 minutes",
    "cook_time" => "15 minutes",
    "servings" => 4,
    "yield_description" => "8 tacos",
    "category_tags" => "Mexican,Dinner,Beef",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "ground beef",
        "quantity" => 1,
        "unit" => "lb"
      },
      "1" => %{
        "ingredient_name" => "yellow onion",
        "quantity" => 1,
        "unit" => "medium",
        "notes" => "diced"
      },
      "2" => %{
        "ingredient_name" => "garlic",
        "quantity" => 2,
        "unit" => "cloves",
        "notes" => "minced"
      },
      "3" => %{
        "ingredient_name" => "ground cumin",
        "quantity" => 1,
        "unit" => "tsp"
      },
      "4" => %{
        "ingredient_name" => "chili powder",
        "quantity" => 1,
        "unit" => "tbsp"
      },
      "5" => %{
        "ingredient_name" => "corn tortillas",
        "quantity" => 8,
        "unit" => "small"
      },
      "6" => %{
        "ingredient_name" => "shredded cheddar cheese",
        "quantity" => 1,
        "unit" => "cup"
      },
      "7" => %{
        "ingredient_name" => "lettuce",
        "quantity" => 2,
        "unit" => "cups",
        "notes" => "shredded"
      }
    }
  })

# Recipe 7: Chicken Caesar Salad
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Chicken Caesar Salad",
    "description" => "Classic Caesar salad with grilled chicken breast and homemade croutons",
    "instructions" => [
      "Season chicken breasts with salt, pepper, and olive oil.",
      "Grill chicken over medium-high heat for 6-7 minutes per side until cooked through.",
      "Let chicken rest for 5 minutes, then slice.",
      "Tear romaine lettuce into bite-sized pieces.",
      "Toss lettuce with Caesar dressing until well coated.",
      "Top with sliced chicken, croutons, and Parmesan cheese.",
      "Serve immediately with lemon wedges."
    ],
    "prep_time" => "20 minutes",
    "cook_time" => "15 minutes",
    "servings" => 4,
    "yield_description" => "4 main course servings",
    "category_tags" => "Salad,Chicken,American,Lunch",
    "is_favorite" => true,
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "chicken breasts",
        "quantity" => 2,
        "unit" => "large",
        "notes" => "boneless, skinless"
      },
      "1" => %{
        "ingredient_name" => "romaine lettuce",
        "quantity" => 2,
        "unit" => "heads",
        "notes" => "chopped"
      },
      "2" => %{
        "ingredient_name" => "caesar dressing",
        "quantity" => 0.5,
        "unit" => "cup"
      },
      "3" => %{
        "ingredient_name" => "croutons",
        "quantity" => 1,
        "unit" => "cup"
      },
      "4" => %{
        "ingredient_name" => "parmesan cheese",
        "quantity" => 0.5,
        "unit" => "cup",
        "notes" => "grated"
      }
    }
  })

# Recipe 8: Banana Bread
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Classic Banana Bread",
    "description" => "Moist and flavorful banana bread perfect for breakfast or snacking",
    "instructions" => [
      "Preheat oven to 350°F and grease a 9x5 inch loaf pan.",
      "In a large bowl, mash bananas until smooth.",
      "Mix in melted butter, sugar, egg, and vanilla.",
      "In separate bowl, combine flour, baking soda, and salt.",
      "Add dry ingredients to wet ingredients and mix until just combined.",
      "Pour batter into prepared pan.",
      "Bake for 60-65 minutes until toothpick inserted in center comes out clean.",
      "Cool in pan for 10 minutes before removing to wire rack."
    ],
    "prep_time" => "15 minutes",
    "cook_time" => "65 minutes",
    "servings" => 8,
    "yield_description" => "1 loaf",
    "category_tags" => "Breakfast,Dessert,Quick Bread,American",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "ripe bananas",
        "quantity" => 3,
        "unit" => "large",
        "notes" => "mashed"
      },
      "1" => %{
        "ingredient_name" => "butter",
        "quantity" => 0.33,
        "unit" => "cup",
        "notes" => "melted"
      },
      "2" => %{
        "ingredient_name" => "sugar",
        "quantity" => 0.75,
        "unit" => "cup"
      },
      "3" => %{
        "ingredient_name" => "egg",
        "quantity" => 1,
        "unit" => "large",
        "notes" => "beaten"
      },
      "4" => %{
        "ingredient_name" => "vanilla extract",
        "quantity" => 1,
        "unit" => "tsp"
      },
      "5" => %{
        "ingredient_name" => "all-purpose flour",
        "quantity" => 1.5,
        "unit" => "cups"
      },
      "6" => %{
        "ingredient_name" => "baking soda",
        "quantity" => 1,
        "unit" => "tsp"
      },
      "7" => %{
        "ingredient_name" => "salt",
        "quantity" => 0.5,
        "unit" => "tsp"
      }
    }
  })

# Recipe 9: Beef Chili
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Hearty Beef Chili",
    "description" => "Rich and spicy chili with ground beef, beans, and tomatoes",
    "instructions" => [
      "Brown ground beef in large pot over medium-high heat, breaking up with spoon.",
      "Add onion and bell pepper, cook until softened, about 5 minutes.",
      "Add garlic, chili powder, cumin, and paprika. Cook for 1 minute.",
      "Add crushed tomatoes, tomato paste, beef broth, and beans.",
      "Bring to boil, then reduce heat and simmer for 45 minutes.",
      "Season with salt and pepper to taste.",
      "Serve hot with desired toppings."
    ],
    "prep_time" => "20 minutes",
    "cook_time" => "60 minutes",
    "servings" => 6,
    "yield_description" => "6 large servings",
    "category_tags" => "American,Soup,Comfort Food,Dinner",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "ground beef",
        "quantity" => 2,
        "unit" => "lbs"
      },
      "1" => %{
        "ingredient_name" => "yellow onion",
        "quantity" => 1,
        "unit" => "large",
        "notes" => "diced"
      },
      "2" => %{
        "ingredient_name" => "bell pepper",
        "quantity" => 1,
        "unit" => "large",
        "notes" => "diced"
      },
      "3" => %{
        "ingredient_name" => "garlic",
        "quantity" => 4,
        "unit" => "cloves",
        "notes" => "minced"
      },
      "4" => %{
        "ingredient_name" => "chili powder",
        "quantity" => 2,
        "unit" => "tbsp"
      },
      "5" => %{
        "ingredient_name" => "ground cumin",
        "quantity" => 1,
        "unit" => "tbsp"
      },
      "6" => %{
        "ingredient_name" => "crushed tomatoes",
        "quantity" => 28,
        "unit" => "oz can"
      },
      "7" => %{
        "ingredient_name" => "kidney beans",
        "quantity" => 15,
        "unit" => "oz can",
        "notes" => "drained and rinsed"
      },
      "8" => %{
        "ingredient_name" => "beef broth",
        "quantity" => 2,
        "unit" => "cups"
      }
    }
  })

# Recipe 10: Lemon Garlic Salmon
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Lemon Garlic Salmon",
    "description" => "Pan-seared salmon with a bright lemon garlic butter sauce",
    "instructions" => [
      "Pat salmon fillets dry and season with salt and pepper.",
      "Heat olive oil in large skillet over medium-high heat.",
      "Cook salmon skin-side up for 4-5 minutes until golden.",
      "Flip salmon and cook 3-4 minutes more until cooked through.",
      "Remove salmon to serving plates.",
      "Add butter and garlic to same pan, cook for 30 seconds.",
      "Add lemon juice and white wine, simmer for 2 minutes.",
      "Spoon sauce over salmon and garnish with parsley."
    ],
    "prep_time" => "10 minutes",
    "cook_time" => "12 minutes",
    "servings" => 4,
    "yield_description" => "4 fillets",
    "category_tags" => "Seafood,Healthy,Dinner,Mediterranean",
    "is_favorite" => true,
    "nutrition" => %{
      "calories" => 350,
      "protein" => 35,
      "carbs" => 2,
      "fat" => 22
    },
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "salmon fillets",
        "quantity" => 4,
        "unit" => "6oz pieces",
        "notes" => "skin-on"
      },
      "1" => %{
        "ingredient_name" => "olive oil",
        "quantity" => 2,
        "unit" => "tbsp"
      },
      "2" => %{
        "ingredient_name" => "butter",
        "quantity" => 3,
        "unit" => "tbsp"
      },
      "3" => %{
        "ingredient_name" => "garlic",
        "quantity" => 4,
        "unit" => "cloves",
        "notes" => "minced"
      },
      "4" => %{
        "ingredient_name" => "lemon juice",
        "quantity" => 0.25,
        "unit" => "cup",
        "notes" => "fresh"
      },
      "5" => %{
        "ingredient_name" => "white wine",
        "quantity" => 0.25,
        "unit" => "cup"
      },
      "6" => %{
        "ingredient_name" => "fresh parsley",
        "quantity" => 2,
        "unit" => "tbsp",
        "notes" => "chopped"
      }
    }
  })

# Recipe 11: Vegetable Lasagna
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Vegetable Lasagna",
    "description" =>
      "Hearty vegetarian lasagna with layers of vegetables, ricotta, and mozzarella",
    "instructions" => [
      "Preheat oven to 375°F and cook lasagna noodles according to package directions.",
      "Sauté zucchini, bell peppers, and mushrooms until tender.",
      "Mix ricotta cheese with egg, herbs, salt, and pepper.",
      "Spread thin layer of marinara sauce in 9x13 baking dish.",
      "Layer noodles, ricotta mixture, vegetables, and mozzarella cheese.",
      "Repeat layers, ending with noodles, sauce, and remaining mozzarella.",
      "Cover with foil and bake for 45 minutes.",
      "Remove foil and bake 15 minutes more until bubbly and golden.",
      "Let rest 10 minutes before serving."
    ],
    "prep_time" => "30 minutes",
    "cook_time" => "60 minutes",
    "servings" => 8,
    "yield_description" => "8 servings",
    "category_tags" => "Italian,Vegetarian,Pasta,Dinner",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "lasagna noodles",
        "quantity" => 12,
        "unit" => "sheets"
      },
      "1" => %{
        "ingredient_name" => "zucchini",
        "quantity" => 2,
        "unit" => "medium",
        "notes" => "sliced"
      },
      "2" => %{
        "ingredient_name" => "bell peppers",
        "quantity" => 2,
        "unit" => "large",
        "notes" => "diced"
      },
      "3" => %{
        "ingredient_name" => "mushrooms",
        "quantity" => 8,
        "unit" => "oz",
        "notes" => "sliced"
      },
      "4" => %{
        "ingredient_name" => "ricotta cheese",
        "quantity" => 15,
        "unit" => "oz container"
      },
      "5" => %{
        "ingredient_name" => "egg",
        "quantity" => 1,
        "unit" => "large"
      },
      "6" => %{
        "ingredient_name" => "marinara sauce",
        "quantity" => 24,
        "unit" => "oz jar"
      },
      "7" => %{
        "ingredient_name" => "mozzarella cheese",
        "quantity" => 2,
        "unit" => "cups",
        "notes" => "shredded"
      }
    }
  })

# Recipe 12: Thai Green Curry
{:ok, _} =
  Recipes.create_recipe(%{
    "name" => "Thai Green Curry",
    "description" => "Aromatic Thai curry with coconut milk, vegetables, and fragrant herbs",
    "instructions" => [
      "Heat oil in large pot over medium heat.",
      "Add green curry paste and cook for 1 minute until fragrant.",
      "Slowly stir in coconut milk and bring to gentle simmer.",
      "Add chicken and cook for 5 minutes.",
      "Add vegetables and cook until tender, about 8 minutes.",
      "Stir in fish sauce, brown sugar, and lime juice.",
      "Garnish with Thai basil and serve over jasmine rice."
    ],
    "prep_time" => "20 minutes",
    "cook_time" => "20 minutes",
    "servings" => 4,
    "yield_description" => "4 servings",
    "category_tags" => "Thai,Asian,Curry,Spicy,Dinner",
    "recipe_ingredients" => %{
      "0" => %{
        "ingredient_name" => "vegetable oil",
        "quantity" => 2,
        "unit" => "tbsp"
      },
      "1" => %{
        "ingredient_name" => "green curry paste",
        "quantity" => 3,
        "unit" => "tbsp"
      },
      "2" => %{
        "ingredient_name" => "coconut milk",
        "quantity" => 14,
        "unit" => "oz can"
      },
      "3" => %{
        "ingredient_name" => "chicken thighs",
        "quantity" => 1,
        "unit" => "lb",
        "notes" => "cut into pieces"
      },
      "4" => %{
        "ingredient_name" => "thai eggplant",
        "quantity" => 2,
        "unit" => "cups",
        "notes" => "quartered"
      },
      "5" => %{
        "ingredient_name" => "bamboo shoots",
        "quantity" => 0.5,
        "unit" => "cup",
        "notes" => "sliced"
      },
      "6" => %{
        "ingredient_name" => "fish sauce",
        "quantity" => 2,
        "unit" => "tbsp"
      },
      "7" => %{
        "ingredient_name" => "brown sugar",
        "quantity" => 1,
        "unit" => "tbsp"
      },
      "8" => %{
        "ingredient_name" => "thai basil",
        "quantity" => 0.25,
        "unit" => "cup",
        "notes" => "fresh leaves"
      }
    }
  })

IO.puts("Successfully created 12 seed recipes!")
IO.puts("Run 'mix run priv/repo/seeds.exs' to populate your database.")
