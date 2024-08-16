# R for Reproducible Scientific Analysis 
# Carpentries

# Creating Publication-Quality Graphics with ggplot2 
# https://swcarpentry.github.io/r-novice-gapminder/08-plot-ggplot2.html
# Presented by Jessica Cooperstone

# load the packages in the tidyverse which includes ggplot2
library(tidyverse)

# load the gapminder data
library(gapminder)

# download the gapminder data we will use today
# make sure that you create a folder called "data" in your working directory
# download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/gapminder_data.csv", 
#               destfile = "data/gapminder_data.csv")

# read the file in
# gapminder <- read.csv("data/gapminder_data.csv")

# let's look at the file
# open the file
View(gapminder)

# look at the file structure
str(gapminder)

# note that the function is called ggplot and the package is called ggplot2
# let's look at the help documentation
?ggplot()

# Data and aesthetics ----

# make a base plot
ggplot(data = gapminder)

# this is the same as using the pipe to send the data to ggplot
gapminder |> 
  ggplot()

# add x and y aesthetics
gapminder |> 
  ggplot(mapping = aes(x = gdpPercap, y = lifeExp))

# mapping is actually not necessary

# add a geometry, here geom_point (makes points)
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

## challenge 1: modify to show life expectancy changes over time ----
gapminder |> 
  ggplot(aes(x = year, y = lifeExp)) +
  geom_point()

## challenge 2: from challenge 1, modify to color the points according to continent ----
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, color = continent)) + 
  geom_point()

# Layers ----
# make a line plot instead of a scatter plot
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, color = continent)) +
  geom_line()
  
# this looks weird because each continent has many countries
# and we are not plotting an average, instead plotting each country 
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, color = continent, group = country)) +
  geom_line()

# point and lines
# layers are added in order, on top of each other
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, color = continent, group = country)) +
  geom_line() +
  geom_point()

# global vs. local aesthetics
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, group = country)) +
  geom_line(aes(color = continent)) +
  geom_point()

## challenge 3: switch the order of point and line ----
# what happened?
gapminder |> 
  ggplot(aes(x = year, y = lifeExp, group = country)) +
  geom_point() +
  geom_line(aes(color = continent))

# Transformations and statistics ----

# gdp per capita by life expectancy
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# make points transparent and log10 scale x-axis
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside the aes
  scale_x_log10()

# add a smoothed line
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside the aes
  scale_x_log10() +
  geom_smooth(method = "lm") # smooth with a linear model ie "lm"

# make the smoothed line thicker
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside the aes
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 2) 

## challenge 4a: modify color and size of points in the previous example ----
## make the points purple and smaller
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5, color = "purple", size = 0.5) + # not inside the aes
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 1) 



## challenge 4b: modify 4a so points are a different shape and colored by continent with new trendlines ----
gapminder |> 
  ggplot(aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point(aes(shape = continent), alpha = 0.5) + 
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 1) # smooth with a linear model ie "lm"

# Multi-panel figures ----

# subset only data from the Americas
gapminder_americas <- gapminder |> 
  filter(continent == "Americas")

# plot 

# facet by country
# creates a little plot for each country
gapminder_americas |> 
  ggplot(aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap(vars(country)) +
  theme(axis.text.x = element_text(angle = 45))

# Modifying text ----

# adjusting labels
gapminder_americas |> 
  ggplot(aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap(vars(country)) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1. Life expectancy in the Americas from 1952-2007",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Exporting a plot ----

# save your plot as an object
lifeExp_plot <- gapminder_americas |> 
  ggplot(aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap(vars(country)) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1. Life expectancy in the Americas from 1952-2007",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# if you don't have a folder called "results" in your home directory
# you will have to make one
ggsave(filename = "results/lifeExp.png", 
       plot = lifeExp_plot, 
       width = 18, 
       height = 12, 
       dpi = 300, 
       units = "cm")

## challenge 5: box plots comparing life expectancy between continents over the time period provided ----
# rename y axis to Life Expectancy
# remove x-axis labels
gapminder |> 
  ggplot(aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot() +
  facet_wrap(vars(year)) +
  theme_classic() + # my favorite complete theme 
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(y = "Life Expectancy (years)",
       fill = "Continent")
  