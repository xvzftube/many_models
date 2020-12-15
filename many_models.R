#install.packages("purrr")
#install.packages("dplyr")
#install.packages("magrittr")
#install.packages("gapminder")
#install.packages("modelr")

library(dplyr)
library(magrittr)
library(purrr)
library(tidyr)
library(gapminder)
library(modelr)

gapminder %>%
  dplyr::group_by(country, continent, year) %>%
  dplyr::summarise(m = mean(lifeExp))

# group data
by_country <- gapminder %>% 
  dplyr::group_by(country, continent) %>% 
  tidyr::nest()

by_country$data[1]

# define linear model function
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

# key line. 
by_country <- by_country %>% 
  dplyr::mutate(model = purrr::map(data, country_model)) %>% 
  dplyr::mutate(resids = purrr:::map2(data, model, modelr::add_residuals))

# sort by largest residuals
by_country %>% 
  tidyr::unnest(resids) %>% 
  dplyr::arrange(dplyr::desc(abs(resid)))

