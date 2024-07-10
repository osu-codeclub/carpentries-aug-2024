# R for Reproducible Scientific Analysis 
# Carpentries

# Creating Publication-Quality Graphics with ggplot2 
# https://swcarpentry.github.io/r-novice-gapminder/08-plot-ggplot2.html
# Presented by Jessica Cooperstone

# load the package "ggplot2" 
library(ggplot2)

# download the gapminder data we will use today
# make sure that you create a folder called "data" in your working directory
download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/gapminder_data.csv", 
              destfile = "data/gapminder_data.csv")

# read the file in
gapminder <- read.csv("data/gapminder_data.csv")

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

# add x and y aesthetics
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))

# add a geometry, here geom_point (makes points)
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

## challenge 1: modify to show life expectancy changes over time ----
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp)) + 
  geom_point()

## challenge 2: from challenge 1, modify to color the points according to continent ----
ggplot(data = gapminder, mapping = aes(x = year, y = lifeExp, color = continent)) + 
  geom_point()

# Layers ----
# make a line plot instead of a scatter plot
ggplot(data = gapminder, 
       mapping = aes(x = year, y = lifeExp, color = continent)) +
  geom_line()
  
# this looks weird because each continent has many countries
# and we are not plotting an average, instead plotting each country 
ggplot(data = gapminder, 
       mapping = aes(x = year, y = lifeExp, color = continent, group = country)) +
  geom_line()

# point and lines
# layers are added in order, on top of each other
ggplot(data = gapminder, 
       mapping = aes(x = year, y = lifeExp, color = continent, group = country)) +
  geom_line() +
  geom_point()

# global vs. local aesthetics
ggplot(data = gapminder, 
       mapping = aes(x = year, y = lifeExp, group = country)) +
  geom_line(aes(color = continent)) +
  geom_point()

## challenge 3: switch the order of point and line ----
# what happened?
ggplot(data = gapminder, 
       mapping = aes(x = year, y = lifeExp, group = country)) +
  geom_point() +
  geom_line(aes(color = continent)) 

# Transformations and statistics ----

# gdp per capita by life expectancy
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# make points transparent and log10 scale x-axis
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside aes
  scale_x_log10()

# add a smoothed line
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside aes
  scale_x_log10() +
  geom_smooth(method = "lm") # smooth with a linear model ie "lm"

# make the smoothed line thicker
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + # not inside aes
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 1.5) # smooth with a linear model ie "lm"

## challenge 4a: modify color and size of points in the previous example ----
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(color = "purple", alpha = 0.5, size = 0.5) + 
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 1.5) # smooth with a linear model ie "lm"

## challenge 4b: modify 4a so points are a different shape and colored by continent with new trendlines ----
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) + # color by continent
  geom_point(aes(shape = continent), alpha = 0.5) + # shape by continent
  scale_x_log10() +
  geom_smooth(method = "lm", linewidth = 1.5) # will now smooth by continent since color acts as a grouping


# Multi-panel figures ----

# subset only data from the Americas
americas <- gapminder[gapminder$continent == "Americas",]

# could also that that like this:

americas_tidy <- gapminder %>%
  filter(continent == "Americas")

# plot 

# facet by country
# creates a little plot for each country
ggplot(data = americas, mapping = aes(x = year, y = lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))

# Modifying text ----

# adjusting labels
ggplot(data = americas,  
       mapping = aes(x = year, y = lifeExp, color = continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# adjusting labels if it were me
ggplot(data = americas,  
       mapping = aes(x = year, y = lifeExp, color = continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy (years)",   # y axis title
    title = "Figure 1, Life expectancy in the Americas from 1952 to 2007", # main title of figure
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none") # we don't need a legend here

# Exporting a plot ----

# save your plot as an object
lifeExp_plot <- ggplot(data = americas, 
                       mapping = aes(x = year, y = lifeExp, color = continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# if you don't have a folder called "results" in your home directory
# you will have to make one
ggsave(filename = "results/lifeExp.png", 
       plot = lifeExp_plot, 
       width = 12, 
       height = 10, 
       dpi = 300, 
       units = "cm")

## challenge 5: boxplots comparing life expectancy between continents over the time period provided ----
ggplot(data = gapminder,
       aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot() +
  facet_wrap(~ year) +
  theme_classic() + # my favorite complete theme 
  theme(axis.title.x=element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  labs(y = "Life Expectancy (years)",
       fill = "Continent")
  