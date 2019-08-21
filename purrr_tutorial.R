#' ---
#' title: "Purrr tutorial"
#' author: "Rebecca Barter"
#' date: "August 21, 2019"
#' ---


knitr::opts_chunk$set(error = TRUE)

library(tidyverse)
#' This includes library(purrr)

############################## LISTS ##########################################
#' # Lists


#' - vector: store individual elements of the same type in a single object
#' 
#' - data frame: store vectors of the same length but different types in a 
#'               single object
#' 
#' - list: store objects of any type in a single object

my_first_list <- list(my_number = 5,
                      my_vector = c("a", "b", "c"),
                      my_dataframe = data.frame(a = 1:3, 
                                                b = c("q", "b", "z"), 
                                                c = c("bananas", "are", 
                                                      "so very great")))
my_first_list













################################# MAP FUNCTIONS ###############################
#' # Map functions


#' syntax
#' `map(.x, .f)`
#' Arguments: 
#'   .x is the object being iterated over (vector, list, or data frame)
#'   .f is the function being iterated
#' Returns:
#'   A list 




#' ((((((( TASK: add 10 to each element in a vector of integers )))))))

#' Add 10 to an integer
addTen <- function(.x) {
  return(.x + 10)
}

#' Do you remember lapply?
lapply(X = c(1, 4, 7), 
       FUN = addTen)


#' map is pretty much the same thing
map(.x = c(1, 4, 7), 
    .f = addTen)

#' map works by applying function .f to each element of .x individually
#' .x can be a vector, list, or data frame



#' ((((((( QUESTION: what are the elements of a data frame? Why? )))))))






#' map always returns a list, no matter what the input type is

#' input: list
map(list(1, 4, 7), addTen)

#' input: data frame
map(data.frame(a = 1, b = 4, c = 7), addTen)
 












############################# MAP TO OTHER TYPES ##############################
#' # Map to other types


#' To map to other types, specify a suffix 


#' (((((( FILL IN )))))) 
#' output: vector (double)


# output: vector (character)


# output: data frame




# why doesn't this work?







#' need to ensure that the output of each iteration is a data frame
map_df(c(1, 4, 7), function(.x) {
  data.frame(old_number = .x,
             new_numer = .x + 10)
})







#' if you want to do a map where the output type is the same as the input type
#' use modify()
modify(c(1, 4, 7), addTen)


############################ ANONYMOUS FUNCTIONS ##############################
#' # Anonymous functions and tilde-dot shorthand


#' Instead of defining a function, use anonymous functions to save typing


# ((((((((((( FILL IN: anonumous function then tilde-dot shorthand )))))))))))
#' anonymous function map
map(c(1, 4, 7), )







#' Tilde-dot shorthand (argument is always `.x``)
map(c(1, 4, 7), ~{.x + 10})











############################## GAPMINDER ######################################
#' # Load gapminder data


#' Since everything is more ineresting with real data, we will play with an 
#' actual dataset

#' to download the data directly:
gapminder_orig <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv")
#' define a copy of the original dataset that we will clean and play with 
gapminder <- gapminder_orig

dim(gapminder)
head(gapminder)




#' Since gapminder is a data frame, map functions iterate over **columns**

#' EXERCISE 1: REPORT THE CLASS OF EACH COLUMN OF THE GAPMINDER DATASET
#' Hint: What should the output type be?


#' EXERCISE 2: REPORT THE NUMBER OF DISTINCT ENTRIES IN EACH COLUMN


#' EXERCISE 3: REPORT A DATA FRAME WITH TWO COLUMNS: CLASS AND NUMBER OF 
#'             DISTINCT ENTRIES


#' The `.x` trick: first write out the code for a single iteration (for the 
#' first element), then copy-paste into the map function using the tilde-dot 
#' shorthand

#' extract the first element (column) of the gapminder data
.x <- gapminder %>% pluck(1)
.x 

























#' ANSWER to EX 3
# indivdual column
data.frame(distinct = n_distinct(.x),
           class = class(.x))
# for all columns
map_df(gapminder, ~{
  data.frame(distinct = n_distinct(.x),
             class = as.character(class(.x)))
})
# with variable names
map_df(gapminder, ~{
  data.frame(distinct = n_distinct(.x),
             class = as.character(class(.x)))
  }, .id = "variable")















########################### MAPPING MULTIPLE OBJECTS ##########################
#' # Map multiple objects

#' syntax
#' `map2(.x, .y, .f = function(.x, .y) {...})`
#' Arguments: 
#'   .x is first the object being iterated over (vector, list, or data frame)
#'   .y is second the object being iterated over (vector, list, or data frame)
#'   .f is the function being iterated
#' Returns:
#'   A list 


#' TASK: create a *list of plots* that compare *life expectancy* and *GDP*
#' for each *continent/year combination*

#' ((( QUESTION: which 2 things are we iterating over? )))









#' Get all combinations of continent and year
continent_year <- gapminder %>% distinct(continent, year)
continent_year

#' extract the continent and year pairs as separate vectors
continents <- continent_year %>% pull(continent) %>% as.character
continents
years <- continent_year %>% pull(year)
years






#' ((((( EXERCISE: create a plot for first year/continent )))))
#' start with just the first continent/year 
.x <- continents[1]
.y <- years[1]

# fill in for the first continent/year
gapminder %>% 
  filter() %>%
  ggplot()

# fill in map version
plot_list <- map2()




















#' ANSWER:
#' code for first year and continent
gapminder %>% 
  filter(continent == .x,
         year == .y) %>%
  ggplot() +
  geom_point(aes(x = gdpPercap, y = lifeExp)) +
  ggtitle(glue::glue(.x, " ", .y))

#' copy-pasting into the `map2` function to iterate
plot_list <- map2(continents, years, 
                  ~{
                    gapminder %>% 
                      filter(continent == .x,
                             year == .y) %>%
                      ggplot() +
                      geom_point(aes(x = gdpPercap, y = lifeExp)) +
                      ggtitle(glue::glue(.x, " ", .y))
                  })

plot_list[[1]]
plot_list[[22]]











# (((((((((( pmap ))))))))))

#' pmap iterates over many objects - supply them in a list
plot_list <- pmap(list(continents, years),
                  function(.continent, .year) {
                    gapminder %>% 
                      filter(continent == .continent,
                             year == .year) %>%
                      ggplot() +
                      geom_point(aes(x = gdpPercap, y = lifeExp)) +
                      ggtitle(glue::glue(.x, " ", .y))
                  })












########################### NESTED DATA FRAMES ################################
#' # List columns and Nested data frames


#' a tibble can be "nested": create a column of data frames stored as a list based on a grouping variable
gapminder_nested <- gapminder %>% 
  group_by(continent) %>% 
  nest()
gapminder_nested







#' Look at the first data frame
gapminder_nested$data[[1]]

# Using the pluck() function
gapminder_nested %>% 
  # extract the first entry from the data column
  pluck("data", 1)








# ((((((( LIST COLUMNS )))))))

#' First need to understand how mutate works

#' Mutate applies the function to the entire column
#' This is ok for vectorized functions applied to vectors
cumsum(1:10)
cumsum(list(1:10))

#' but issues arise when the column is a list
tibble(vec_col = c(1, 5, 7)) %>%
  mutate(vec_sum = cumsum(vec_col))

tibble(list_col = list(c(1, 5, 7), 5, c(10, 10, 11))) %>%
  mutate(list_sum = cumsum(list_col))





#' ((((((( EXERCISE: figure out how to apply cumsum to the list column )))))))

















#' ANSWER: wrap it in a map function!

tibble(list_col = list(c(1, 5, 7), 5, c(10, 10, 11))) %>%
  mutate(list_sum = map(list_col, cumsum)) 
  # pull(list_sum)


#' map_dbl would be better here
tibble(list_col = list(c(1, 5, 7), 5, c(10, 10, 11))) %>%
  mutate(list_sum = map_dbl(list_col, sum))








######################## MODELING NESTED GAPMINDER ############################
#' # Modeling the nested gapminder data

#' EXERCISE 1: To create a column with the average life expectancy for each,
#'             why doesn't the following code work?
gapminder_nested %>% 
  mutate(avg_lifeExp = mean(data$lifeExp))
















#' EXERCISE 2: write some code that does work!
#' start with the first data frame as .x 
.x <- gapminder_nested %>% pluck("data", 1)
.x

#' calculate the average life expectency for .x
mean(.x$lifeExp)


#' copy-paste into the appropriate map function









#' ANSWER 1: the `data` column doesn't have an entry called `lifeExp`

#' ANSWER 2:
#' the following code will do what we want for a single data frame .x
mean(.x$lifeExp)

#' Copy and paste it into a map function within the mutate function
gapminder_nested %>% 
  mutate(avg_lifeExp = map_dbl(data, ~{mean(.x$lifeExp)}))


















# (((((((((((((((( LINEAR MODELS ))))))))))))))))

#' ## A more exciting example
#' 
#' Fit a linear mdoel for each continent and store it in a list-column 
#' called lm_obj

# the model for the first data frame is
.x <- gapminder_nested %>% pluck("data", 1)
lm(lifeExp ~ pop + gdpPercap + year, data = .x)






















# ANSWER
gapminder_nested <- gapminder_nested %>% 
  mutate(lm_obj = map(data, ~lm(lifeExp ~ pop + gdpPercap + year, data = .x)))
gapminder_nested




#' Check out the first object
gapminder_nested %>% pluck("lm_obj", 1)




#' EXERCISE: Predict the response for each row in the data column and store it 
#'           in a `pred` list column
#' Hint: what *two* objects do we need to iterate over?




















#' ANSWER: 
gapminder_nested <- gapminder_nested %>% 
  mutate(pred = map2(lm_obj, data, function(.lm, .data) predict(.lm, .data)))
gapminder_nested








#' EXERCISE: Calculate the correlation between the observed and predicted 
#'           responses for each continent and store it in a *numeric* column 
#'           called `cor`
#' Hint: what *two* objects do we need to iterate over?


















#' ANSWER:
gapminder_nested <- gapminder_nested %>% 
  mutate(cor = map2_dbl(pred, data, function(.pred, .data) cor(.pred, .data$lifeExp)))
gapminder_nested













######################## ADDITIONAL LIST STUFF ############################
#' # Additional purrr functionalities for lists


# make a list of data frames 
set.seed(23489)
gapminder_list <- gapminder %>% split(gapminder$continent) %>%
  map(~sample_n(., 5))
gapminder_list





# (((((((( keep/discard ))))))))

# like select_if()
# keep only continents with average life expectency of at least 70
gapminder_list %>%
  keep(~{mean(.x$lifeExp) > 70})


# also works for vectors
keep(c(1, 5, 7), ~{.x > 5})


# (((((((((( logical statements ))))))))))

gapminder_list %>% every(~{mean(.x$life) > 70})
apminder_list %>% some(~{mean(.x$life) > 70})



list(1, c(2, 5, 1), "a") %>% has_element("a")






