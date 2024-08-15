---
title: "Data Frame Manipulation with _dplyr_"
author: "Software Carpentry, with edits by Jelmer Poelstra"
format: html
execute:
  keep-md: true
editor_options: 
  chunk_output_type: console
---



<br>

## The _dplyr_ package and the tidyverse

The [_dplyr_](https://cran.r-project.org/package=dplyr) package provides a number
of very useful functions for **manipulating data frames**.

Here we're going to cover some of the most commonly used functions,
and will also use pipes (`%>%`) to combine them.

- `select()` to pick columns (variables)
- `filter()` to pick rows (observations)
- `rename()` to change column names
- `arrange()` to change the order of rows (i.e., to sort)
- `mutate()` to modify values in columns and create new columns
- `summarize()` (with `group_by()`) to compute summaries across rows 

All of these functions take a data frame as the _input_,
and return a new, modified data frame as the output.

_dplyr_ belongs to a broader family of R packages designed for "dataframe-centric"
data science called the "Tidyverse".
The other tidyverse package that we'll cover in today's workshop is _ggplot2_ for making plots.
You can find more information about the Tidyverse here:
[https://www.tidyverse.org/](https://www.tidyverse.org/).

All of the tidyverse's packages can be loaded at once as follows:


::: {.cell}

```{.r .cell-code}
library(tidyverse)
```

::: {.cell-output .cell-output-stderr}

```
── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.5
✔ forcats   1.0.0     ✔ stringr   1.5.1
✔ ggplot2   3.5.1     ✔ tibble    3.2.1
✔ lubridate 1.9.3     ✔ tidyr     1.3.1
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```


:::
:::


That will print quote some output which tells you which packages have been loaded
as part of the tidyverse, and which tidyverse functions "conflict with"
(in the sense of having the same name as)
R functions that were already in your environment.

<br>

## Our data set and the pipe

In this section and in the afternoon, we will work with the `gapminder` data set.
This data set is available in a package
(while most packages are built around functions so as to extend R's functionality,
others, like this one, merely contain data sets),
and we can load it as follows:


::: {.cell}

```{.r .cell-code}
library(gapminder)
```
:::


Let's take a look at the dataset:


::: {.cell}

```{.r .cell-code}
gapminder
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 6
   country     continent  year lifeExp      pop gdpPercap
   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
 1 Afghanistan Asia       1952    28.8  8425333      779.
 2 Afghanistan Asia       1957    30.3  9240934      821.
 3 Afghanistan Asia       1962    32.0 10267083      853.
 4 Afghanistan Asia       1967    34.0 11537966      836.
 5 Afghanistan Asia       1972    36.1 13079460      740.
 6 Afghanistan Asia       1977    38.4 14880372      786.
 7 Afghanistan Asia       1982    39.9 12881816      978.
 8 Afghanistan Asia       1987    40.8 13867957      852.
 9 Afghanistan Asia       1992    41.7 16317921      649.
10 Afghanistan Asia       1997    41.8 22227415      635.
# ℹ 1,694 more rows
```


:::
:::


The `gapminder` data frame is a so-called "tibble",
which is the tidyverse version of a data frame.
The main difference is the nicer default printing behavior of tibbles:
e.g. the data types of columns are shown,
and only a limited number of rows will be printed (hence `1,694 more rows`).

As for the dataset itself, note that each row contains some data
for a single country in a specific year
(across 5-year intervals between 1952 and 2007):

- `lifeExp` is the life expectancy in years
- `pop` is the population size
- `gdpPercap` is the per-capita GDP

<br>

## `select()` to pick columns (variables)

To subset a data frame by keeping or removing certain columns,
we can use the `select()` function.
By default, this will only keep the columns that you specify,
typically simply by listing those columns by name:


::: {.cell}

```{.r .cell-code}
select(.data = gapminder, year, country, gdpPercap)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 3
    year country     gdpPercap
   <int> <fct>           <dbl>
 1  1952 Afghanistan      779.
 2  1957 Afghanistan      821.
 3  1962 Afghanistan      853.
 4  1967 Afghanistan      836.
 5  1972 Afghanistan      740.
 6  1977 Afghanistan      786.
 7  1982 Afghanistan      978.
 8  1987 Afghanistan      852.
 9  1992 Afghanistan      649.
10  1997 Afghanistan      635.
# ℹ 1,694 more rows
```


:::
:::


In the command above, the first argument was the data frame,
whereas the other arguments were the (unquoted!) names of columns we wanted to keep.

We can also work the other way around, specifying columns that should be removed,
by prefacing their name with a `!` (or a `-`):


::: {.cell}

```{.r .cell-code}
select(.data = gapminder, !continent)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 5
   country      year lifeExp      pop gdpPercap
   <fct>       <int>   <dbl>    <int>     <dbl>
 1 Afghanistan  1952    28.8  8425333      779.
 2 Afghanistan  1957    30.3  9240934      821.
 3 Afghanistan  1962    32.0 10267083      853.
 4 Afghanistan  1967    34.0 11537966      836.
 5 Afghanistan  1972    36.1 13079460      740.
 6 Afghanistan  1977    38.4 14880372      786.
 7 Afghanistan  1982    39.9 12881816      978.
 8 Afghanistan  1987    40.8 13867957      852.
 9 Afghanistan  1992    41.7 16317921      649.
10 Afghanistan  1997    41.8 22227415      635.
# ℹ 1,694 more rows
```


:::
:::


(There are also ways to select _ranges_ of columns,
and to match columns by their _partial names_,
but that is beyond the scope of this short workshop.)

<br>

## `rename()` to change column names, and the pipe (`%>%`)

Our next _dplyr_ function is one of the most simple:
`rename()` to change the column names in a data frame.

The syntax to specify the new and old name within the function is `new_name = old_name`.
For example, building on the column selection we did above,
we may want to rename the `gdpPercap` column:


::: {.cell}

```{.r .cell-code}
gapminder_sel <- select(.data = gapminder, year, country, gdpPercap)

rename(.data = gapminder_sel, gdp_per_capita = gdpPercap)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 3
    year country     gdp_per_capita
   <int> <fct>                <dbl>
 1  1952 Afghanistan           779.
 2  1957 Afghanistan           821.
 3  1962 Afghanistan           853.
 4  1967 Afghanistan           836.
 5  1972 Afghanistan           740.
 6  1977 Afghanistan           786.
 7  1982 Afghanistan           978.
 8  1987 Afghanistan           852.
 9  1992 Afghanistan           649.
10  1997 Afghanistan           635.
# ℹ 1,694 more rows
```


:::
:::


It is common to use several (_dplyr_) functions in succession to "wrangle" a dataframe
into a format, and with the data, that we want.
To do so, we could go on like we did above,
successively assigning new data frames and moving on to the next step.

But there is a nicer way of dong this,
using so-called "piping" with a pipe operator:
we will use the `%>%` pipe operator.

Let's start by seeing pipes into action, which is a reformulation of the code
we used above to first select 3 columns and then rename 1 of them:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  select(year, country, gdpPercap) %>%
  rename(gdp_per_capita = gdpPercap)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 3
    year country     gdp_per_capita
   <int> <fct>                <dbl>
 1  1952 Afghanistan           779.
 2  1957 Afghanistan           821.
 3  1962 Afghanistan           853.
 4  1967 Afghanistan           836.
 5  1972 Afghanistan           740.
 6  1977 Afghanistan           786.
 7  1982 Afghanistan           978.
 8  1987 Afghanistan           852.
 9  1992 Afghanistan           649.
10  1997 Afghanistan           635.
# ℹ 1,694 more rows
```


:::
:::


What is happening here is that we take the `gapminder` data frame,
and push (or "pipe") it into the `select()` function,
whose output in turn is piped into the `rename()` function.
You can think of the pipe as "then":
take `gapminder`, _then_ select, _then_ rename.

When we do this, the piped input replaces our previous way of specifying the input
(with the `.data` argument).
Under the hood, when you pipe something into a function,
this will by default be passed to _the first argument of the function_.
_dplyr_ (and other tidyverse) functions are quite consistent
with the first argument always being a data frame,
which makes them "pipe-friendly".

Using pipes is slightly less typing and more readable than successive assignments.
(It is also faster and uses less computer memory.)

<br>

## `filter()` to pick rows (observations)

The `filter()` function can be used to keep only certain rows.
Whereas column-selection often simply happens by column name as we've seen
with `select()`, row-selection tends to be a more intricate and interesting topic.

Let's start with the following example,
where we want to keep observations (remember, these are countries in a given year)
that have a life expectancy (column `lifeExp`) greater than 80 years:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(lifeExp > 80)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 21 × 6
   country          continent  year lifeExp      pop gdpPercap
   <fct>            <fct>     <int>   <dbl>    <int>     <dbl>
 1 Australia        Oceania    2002    80.4 19546792    30688.
 2 Australia        Oceania    2007    81.2 20434176    34435.
 3 Canada           Americas   2007    80.7 33390141    36319.
 4 France           Europe     2007    80.7 61083916    30470.
 5 Hong Kong, China Asia       2002    81.5  6762476    30209.
 6 Hong Kong, China Asia       2007    82.2  6980412    39725.
 7 Iceland          Europe     2002    80.5   288030    31163.
 8 Iceland          Europe     2007    81.8   301931    36181.
 9 Israel           Asia       2007    80.7  6426679    25523.
10 Italy            Europe     2002    80.2 57926999    27968.
# ℹ 11 more rows
```


:::
:::


So, we specify a _condition_ based on the values in at least one column,
and only the rows that satisfy this condition will be kept.

These conditions don't have to be based on numeric comparisons -- for example:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(continent == "Europe")
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 360 × 6
   country continent  year lifeExp     pop gdpPercap
   <fct>   <fct>     <int>   <dbl>   <int>     <dbl>
 1 Albania Europe     1952    55.2 1282697     1601.
 2 Albania Europe     1957    59.3 1476505     1942.
 3 Albania Europe     1962    64.8 1728137     2313.
 4 Albania Europe     1967    66.2 1984060     2760.
 5 Albania Europe     1972    67.7 2263554     3313.
 6 Albania Europe     1977    68.9 2509048     3533.
 7 Albania Europe     1982    70.4 2780097     3631.
 8 Albania Europe     1987    72   3075321     3739.
 9 Albania Europe     1992    71.6 3326498     2497.
10 Albania Europe     1997    73.0 3428038     3193.
# ℹ 350 more rows
```


:::
:::


Note the use of _double_ equals signs `==` to test for equality!

### Filter based on multiple conditions

It's also possible to filter based on multiple conditions:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(continent == "Europe", year == 2007, lifeExp > 80)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 7 × 6
  country     continent  year lifeExp      pop gdpPercap
  <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
1 France      Europe     2007    80.7 61083916    30470.
2 Iceland     Europe     2007    81.8   301931    36181.
3 Italy       Europe     2007    80.5 58147733    28570.
4 Norway      Europe     2007    80.2  4627926    49357.
5 Spain       Europe     2007    80.9 40448191    28821.
6 Sweden      Europe     2007    80.9  9031088    33860.
7 Switzerland Europe     2007    81.7  7554661    37506.
```


:::
:::


By default, multiple conditions are combined in an _AND_ fashion ---
in other words, in a given row, _each_ condition needs to be met for that column
to be kept.

If you want to combine conditions in an _OR_ fashion,
you should use a `|` as follows:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(lifeExp > 80 | gdpPercap > 10000)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 392 × 6
   country   continent  year lifeExp      pop gdpPercap
   <fct>     <fct>     <int>   <dbl>    <int>     <dbl>
 1 Argentina Americas   1977    68.5 26983828    10079.
 2 Argentina Americas   1997    73.3 36203463    10967.
 3 Argentina Americas   2007    75.3 40301927    12779.
 4 Australia Oceania    1952    69.1  8691212    10040.
 5 Australia Oceania    1957    70.3  9712569    10950.
 6 Australia Oceania    1962    70.9 10794968    12217.
 7 Australia Oceania    1967    71.1 11872264    14526.
 8 Australia Oceania    1972    71.9 13177000    16789.
 9 Australia Oceania    1977    73.5 14074100    18334.
10 Australia Oceania    1982    74.7 15184200    19477.
# ℹ 382 more rows
```


:::
:::


Finally, let's practice a bit more with pipelines that use multiple _dplyr_ verbs:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(continent == "Europe") %>%
  select(year, country, gdpPercap) %>%
  rename(gdp_per_capita = gdpPercap)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 360 × 3
    year country gdp_per_capita
   <int> <fct>            <dbl>
 1  1952 Albania          1601.
 2  1957 Albania          1942.
 3  1962 Albania          2313.
 4  1967 Albania          2760.
 5  1972 Albania          3313.
 6  1977 Albania          3533.
 7  1982 Albania          3631.
 8  1987 Albania          3739.
 9  1992 Albania          2497.
10  1997 Albania          3193.
# ℹ 350 more rows
```


:::
:::


<br>

### Challenge 1

Write a single command (which can span multiple lines and include pipes)
that will produce a data frame that has `lifeExp`, `country`, and `year`
for Africa but not for other continents. 
How many rows does your data frame have?

<details><summary>Click for the solution</summary>

::: {.cell}

```{.r .cell-code}
gapminder %>%
  filter(continent == "Africa") %>%
  select(year, country, lifeExp)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 624 × 3
    year country lifeExp
   <int> <fct>     <dbl>
 1  1952 Algeria    43.1
 2  1957 Algeria    45.7
 3  1962 Algeria    48.3
 4  1967 Algeria    51.4
 5  1972 Algeria    54.5
 6  1977 Algeria    58.0
 7  1982 Algeria    61.4
 8  1987 Algeria    65.8
 9  1992 Algeria    67.7
10  1997 Algeria    69.2
# ℹ 614 more rows
```


:::
:::


It has  624 rows.

</details>

## `arrange()` to sort data frames

The `arrange()` function is like the sort function in Excel:
it changes the order of the rows based on the values in one or more columns.
For example, you might want to sort entries by their cost or size, or by their names in alphabetical order.

For example, our data set `gapminder` is currently sorted alphabetically by `country`
and then by `year`, but we may instead want to sort observations by population size:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  arrange(pop)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 6
   country               continent  year lifeExp   pop gdpPercap
   <fct>                 <fct>     <int>   <dbl> <int>     <dbl>
 1 Sao Tome and Principe Africa     1952    46.5 60011      880.
 2 Sao Tome and Principe Africa     1957    48.9 61325      861.
 3 Djibouti              Africa     1952    34.8 63149     2670.
 4 Sao Tome and Principe Africa     1962    51.9 65345     1072.
 5 Sao Tome and Principe Africa     1967    54.4 70787     1385.
 6 Djibouti              Africa     1957    37.3 71851     2865.
 7 Sao Tome and Principe Africa     1972    56.5 76595     1533.
 8 Sao Tome and Principe Africa     1977    58.6 86796     1738.
 9 Djibouti              Africa     1962    39.7 89898     3021.
10 Sao Tome and Principe Africa     1982    60.4 98593     1890.
# ℹ 1,694 more rows
```


:::
:::


Sorting can be useful to see the observations with the smallest or largest values
for a certain column: above we see that the country and year with the smallest
population size is Sao Tome and Principe in 1952.

Of course, we may also want to sort in the reverse order, from large to small,
in other words, descendingly, and we can do so as follows:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  arrange(desc(pop))
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 6
   country continent  year lifeExp        pop gdpPercap
   <fct>   <fct>     <int>   <dbl>      <int>     <dbl>
 1 China   Asia       2007    73.0 1318683096     4959.
 2 China   Asia       2002    72.0 1280400000     3119.
 3 China   Asia       1997    70.4 1230075000     2289.
 4 China   Asia       1992    68.7 1164970000     1656.
 5 India   Asia       2007    64.7 1110396331     2452.
 6 China   Asia       1987    67.3 1084035000     1379.
 7 India   Asia       2002    62.9 1034172547     1747.
 8 China   Asia       1982    65.5 1000281000      962.
 9 India   Asia       1997    61.8  959000000     1459.
10 China   Asia       1977    64.0  943455000      741.
# ℹ 1,694 more rows
```


:::
:::

 
Finally, it is common to want to sort by multiple columns,
where ties in the first column are broken by a second column (and so on):


::: {.cell}

```{.r .cell-code}
gapminder %>%
  arrange(continent, country)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 6
   country continent  year lifeExp      pop gdpPercap
   <fct>   <fct>     <int>   <dbl>    <int>     <dbl>
 1 Algeria Africa     1952    43.1  9279525     2449.
 2 Algeria Africa     1957    45.7 10270856     3014.
 3 Algeria Africa     1962    48.3 11000948     2551.
 4 Algeria Africa     1967    51.4 12760499     3247.
 5 Algeria Africa     1972    54.5 14760787     4183.
 6 Algeria Africa     1977    58.0 17152804     4910.
 7 Algeria Africa     1982    61.4 20033753     5745.
 8 Algeria Africa     1987    65.8 23254956     5681.
 9 Algeria Africa     1992    67.7 26298373     5023.
10 Algeria Africa     1997    69.2 29072015     4797.
# ℹ 1,694 more rows
```


:::
:::


<br>

## `mutate()` to modify values in columns and create new columns

So far, we've focused on functions that "merely" subset and reorder data frames.
We've also seen how we can modify column names.
But we haven't seen how we can change the data in data frames.

We can do this with the `mutate()` function. For example:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  mutate(pop_million = pop / 1000000)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 7
   country     continent  year lifeExp      pop gdpPercap pop_million
   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>       <dbl>
 1 Afghanistan Asia       1952    28.8  8425333      779.        8.43
 2 Afghanistan Asia       1957    30.3  9240934      821.        9.24
 3 Afghanistan Asia       1962    32.0 10267083      853.       10.3 
 4 Afghanistan Asia       1967    34.0 11537966      836.       11.5 
 5 Afghanistan Asia       1972    36.1 13079460      740.       13.1 
 6 Afghanistan Asia       1977    38.4 14880372      786.       14.9 
 7 Afghanistan Asia       1982    39.9 12881816      978.       12.9 
 8 Afghanistan Asia       1987    40.8 13867957      852.       13.9 
 9 Afghanistan Asia       1992    41.7 16317921      649.       16.3 
10 Afghanistan Asia       1997    41.8 22227415      635.       22.2 
# ℹ 1,694 more rows
```


:::
:::


The code above creates a new column called `pop_million` that is the result
of dividing the values in the `pop` column by a million.

To modify a column rather than adding a new one, simply assign back to the same name:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  mutate(pop = pop / 1000000)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 6
   country     continent  year lifeExp   pop gdpPercap
   <fct>       <fct>     <int>   <dbl> <dbl>     <dbl>
 1 Afghanistan Asia       1952    28.8  8.43      779.
 2 Afghanistan Asia       1957    30.3  9.24      821.
 3 Afghanistan Asia       1962    32.0 10.3       853.
 4 Afghanistan Asia       1967    34.0 11.5       836.
 5 Afghanistan Asia       1972    36.1 13.1       740.
 6 Afghanistan Asia       1977    38.4 14.9       786.
 7 Afghanistan Asia       1982    39.9 12.9       978.
 8 Afghanistan Asia       1987    40.8 13.9       852.
 9 Afghanistan Asia       1992    41.7 16.3       649.
10 Afghanistan Asia       1997    41.8 22.2       635.
# ℹ 1,694 more rows
```


:::
:::


### Challenge 2

Create a new column called `gdp_billion` that has the absolute GDP
(i.e., not relative to population size) in billions.

<details><summary>Click for the solution</summary>


::: {.cell}

```{.r .cell-code}
gapminder %>%
    mutate(gdp_billion = gdpPercap * pop / 10^9)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1,704 × 7
   country     continent  year lifeExp      pop gdpPercap gdp_billion
   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>       <dbl>
 1 Afghanistan Asia       1952    28.8  8425333      779.        6.57
 2 Afghanistan Asia       1957    30.3  9240934      821.        7.59
 3 Afghanistan Asia       1962    32.0 10267083      853.        8.76
 4 Afghanistan Asia       1967    34.0 11537966      836.        9.65
 5 Afghanistan Asia       1972    36.1 13079460      740.        9.68
 6 Afghanistan Asia       1977    38.4 14880372      786.       11.7 
 7 Afghanistan Asia       1982    39.9 12881816      978.       12.6 
 8 Afghanistan Asia       1987    40.8 13867957      852.       11.8 
 9 Afghanistan Asia       1992    41.7 16317921      649.       10.6 
10 Afghanistan Asia       1997    41.8 22227415      635.       14.1 
# ℹ 1,694 more rows
```


:::
:::

</details>

<br>

## `summarize()` to compute (per-group) summary statistics on the data

In combination with `group_by()`,
the `summarize()` function can compute data summaries across groups of rows of a
data frame.

First, let's see what `summarize()` does by itself:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  summarize(mean_gdp = mean(gdpPercap),
            mean_life = mean(lifeExp))
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1 × 2
  mean_gdp mean_life
     <dbl>     <dbl>
1    7215.      59.5
```


:::
:::


Above, we computed the mean for two columns, across all rows.
This is useful, of course, but it is in combination with the helper function
`group_by()` that summarize becomes really powerful:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdp = mean(gdpPercap),
            mean_life = mean(lifeExp))
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 5 × 3
  continent mean_gdp mean_life
  <fct>        <dbl>     <dbl>
1 Africa       2194.      48.9
2 Americas     7136.      64.7
3 Asia         7902.      60.1
4 Europe      14469.      71.9
5 Oceania     18622.      74.3
```


:::
:::


<br>

### Challenge 3

Calculate the average life expectancy per country.
Which has the longest average life expectancy and which has the shortest
average life expectancy?

<details><summary>Click for the solution</summary>


::: {.cell}

```{.r .cell-code}
lifeExp_bycountry <- gapminder %>%
   group_by(country) %>%
   summarize(mean_lifeExp = mean(lifeExp))
```
:::

::: {.cell}

```{.r .cell-code}
lifeExp_bycountry %>%
   arrange(mean_lifeExp) %>%
   head(1)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1 × 2
  country      mean_lifeExp
  <fct>               <dbl>
1 Sierra Leone         36.8
```


:::

```{.r .cell-code}
lifeExp_bycountry %>%
   arrange(desc(mean_lifeExp)) %>%
   head(1)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 1 × 2
  country mean_lifeExp
  <fct>          <dbl>
1 Iceland         76.5
```


:::
:::

</details>

Another powerful feature is that we can group by multiple variables --
for example, by `year` _and_ `continent`:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  group_by(continent, year) %>%
  summarize(mean_gdp = mean(gdpPercap))
```

::: {.cell-output .cell-output-stderr}

```
`summarise()` has grouped output by 'continent'. You can override using the
`.groups` argument.
```


:::

::: {.cell-output .cell-output-stdout}

```
# A tibble: 60 × 3
# Groups:   continent [5]
   continent  year mean_gdp
   <fct>     <int>    <dbl>
 1 Africa     1952    1253.
 2 Africa     1957    1385.
 3 Africa     1962    1598.
 4 Africa     1967    2050.
 5 Africa     1972    2340.
 6 Africa     1977    2586.
 7 Africa     1982    2482.
 8 Africa     1987    2283.
 9 Africa     1992    2282.
10 Africa     1997    2379.
# ℹ 50 more rows
```


:::
:::


<br>

## What's next

- Joining/merging
- Pivoting

<br>

## Bonus: `count()` and `n()`

A very common operation is to count the number of observations for each group.
The _dplyr_ package comes with two related functions that help with this.

For instance, if we wanted to check the number of countries included in the
dataset for the year 2002, we can use the `count()` function.
It takes the name of one or more columns that contain the groups we are interested in,
and we can optionally sort the results in descending order by adding `sort = TRUE`:


::: {.cell}

```{.r .cell-code}
gapminder %>%
    filter(year == 2002) %>%
    count(continent, sort = TRUE)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 5 × 2
  continent     n
  <fct>     <int>
1 Africa       52
2 Asia         33
3 Europe       30
4 Americas     25
5 Oceania       2
```


:::
:::


If we need to use the number of observations in calculations,
the `n()` function is useful.
It will return the total number of observations in the current group rather than
counting the number of observations in each group within a specific column.
For instance, if we wanted to get the standard error of the life expectancy per continent:


::: {.cell}

```{.r .cell-code}
gapminder %>%
  group_by(continent) %>%
  summarize(se_life = sd(lifeExp) / sqrt(n()))
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 5 × 2
  continent se_life
  <fct>       <dbl>
1 Africa      0.366
2 Americas    0.540
3 Asia        0.596
4 Europe      0.286
5 Oceania     0.775
```


:::
:::
