#' @title For `make(..., parallelism = "Makefile")`,
#'   see what your `Makefile` recipes
#'   will look like in advance.
#' @export
#' @seealso [default_recipe_command()],
#'   [r_recipe_wildcard()], [make()]
#' @description Relevant to `"Makefile"` parallelism only.
#' @return A character scalar with a Makefile recipe.
#'
#' @param recipe_command The Makefile recipe command.
#'   See [default_recipe_command()].
#'
#' @param target character scalar, name of your target
#'
#' @param cache_path path to the drake cache.
#'   In practice, this defaults to the hidden `.drake/` folder,
#'   but this can be customized. In the Makefile, the drake cache
#'   is coded with the Unix variable `DRAKE_CACHE` and then dereferenced
#'   with `$(DRAKE_CACHE)`. To simplify things for users who may
#'   be unfamiliar with Unix variables, the `recipe()` function
#'   just shows the literal path to the cache.
#'
#' @details Makefile recipes to build targets are customizable.
#' Use the `Makefile_recipe()` function to show and tweak
#' Makefile recipes in advance, and see
#' [default_recipe_command()] and
#' [r_recipe_wildcard()] for more clues.
#' The default recipe is `Rscript -e 'R_RECIPE'`, where
#' `R_RECIPE` is the wildcard for the recipe in R for making the target.
#' In writing the Makefile, `R_RECIPE` is replaced with something like
#' `drake::mk("name_of_target", "path_to_cache")`.
#' So when you call
#' `make(..., parallelism = "Makefile", recipe_command = "R -e 'R_RECIPE' -q")`, # nolint
#' from within R, the `Makefile` builds each target
#' with the `Makefile` recipe,
#' `R -e 'drake::mk("this_target", "path_to_cache")' -q`.
#' But since `R -q -e` fails on Windows,
#' so the default `recipe_command` argument is
#' `"Rscript -e 'R_RECIPE'"`
#' (equivalently just `"Rscript -e"`),
#' so the default `Makefile` recipe for each target is
#' `Rscript -e 'drake::mk("this_target", "path_to_cache")'`.
#'
#' @examples
#' # Only relevant for "Makefile" parallelism.
#' # Show an example Makefile recipe.
#' Makefile_recipe(cache_path = "path") # `cache_path` has a reliable default.
#' # Customize your Makefile recipe.
#' Makefile_recipe(
#'   target = "this_target",
#'   recipe_command = "R -e 'R_RECIPE' -q",
#'   cache_path = "custom_cache"
#' )
#' default_recipe_command() # "Rscript -e 'R_RECIPE'" # nolint
#' r_recipe_wildcard() # "R_RECIPE"
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' # Look at the Makefile generated by the following.
#' # make(my_plan, paralleliem = "Makefile") # Requires Rtools on Windows. # nolint
#' # Generates a Makefile with "R -q -e" rather than
#' # "Rscript -e".
#' # Be aware the R -q -e fails on Windows.
#' # make(my_plan, parallelism = "Makefile", jobs = 2, # nolint
#' #   recipe_command = "R -q -e") # nolint
#' # Same thing:
#' clean() # Start from scratch.
#' # make(my_plan, parallelism = "Makefile", jobs = 2, # nolint
#' #   recipe_command = "R -q -e 'R_RECIPE'") # nolint
#' clean() # Start from scratch.
#' # make(my_plan, parallelism = "Makefile", jobs = 2, # nolint
#' #   recipe_command = "R -e 'R_RECIPE' -q") # nolint
#' })
#' }
Makefile_recipe <- function( # nolint
  recipe_command = drake::default_recipe_command(),
  target = "your_target",
  cache_path = NULL
) {
  cache_path <- cache_path %||% default_cache_path()
  msg <- build_recipe(
    target = target,
    recipe_command = recipe_command,
    cache_path = cache_path
  )
  message(msg)
}

#' @title Show the default
#'   recipe command for `make(..., parallelism = "Makefile")`.
#' @export
#' @seealso [Makefile_recipe()]
#' @description See the help file of [Makefile_recipe()]
#' for details and examples.
#' @return A character scalar with the default recipe command.
#' @examples
#' default_recipe_command()
default_recipe_command <- function() {
  paste0("Rscript -e '", r_recipe_wildcard(), "'")
}

#' @title Show the R recipe wildcard
#'   for `make(..., parallelism = "Makefile")`.
#' @export
#' @seealso [default_recipe_command()]
#' @description Relevant to `"Makefile"` parallelism only.
#' @return The R recipe wildcard.
#' @examples
#' r_recipe_wildcard()
r_recipe_wildcard <- function() {
  "R_RECIPE"
}
