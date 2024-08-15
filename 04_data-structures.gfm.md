---
title: "R's Data Structures and Data Types"
author: "Software Carpentry, with edits by Jelmer Poelstra"
date: 2024-08-19
format: gfm
execute:
  keep-md: true
editor_options: 
  chunk_output_type: console
---



<br>

In this episode, we will learn about R's data structures and data types.
We will start by covering the two most common data structures,
vectors and data frames, in some depth.

<br>

## Data structure 1: Vectors

The first data structure we will explore is the simplest: the vector.
A vector in R is essentially _a list of one or more items (or elements)_,
with the special condition that all those items must be _the same data type_.
We will learn more about data types in a bit, but for now,
consider that among others,
R has separate data types for numbers and character strings (such as words).

### Single-element vectors and quoting

Vectors can have just a single item (element),
so the code below creates two separate vectors:


::: {.cell}

```{.r .cell-code}
vector1 <- 8
vector2 <- "panda"
```
:::


Two things are worth noting about the second example with a character string.
First, "panda" is one item, not 5 (its number of letters).

Second, we have to quote the string
(either double or single quotes are fine, with the former more common).
Unquoted character strings are interpreted as R objects --
for example, `vector1` and `vector2` above are objects,
and should be referred to without quotes:


::: {.cell}

```{.r .cell-code}
vector1
```

::: {.cell-output .cell-output-stdout}

```
[1] 8
```


:::

```{.r .cell-code}
vector2
```

::: {.cell-output .cell-output-stdout}

```
[1] "panda"
```


:::
:::


Conversely, the below doesn't work, because there is no object called `panda`:


::: {.cell}

```{.r .cell-code}
vector_fail <- panda
```

::: {.cell-output .cell-output-error}

```
Error in eval(expr, envir, enclos): object 'panda' not found
```


:::
:::


<br>

### Multi-element vectors

You can make vectors that have multiple elements with the `c` (combine) function:


::: {.cell}

```{.r .cell-code}
vector3 <- c(2, 6, 3)
vector3
```

::: {.cell-output .cell-output-stdout}

```
[1] 2 6 3
```


:::
:::


This function, `c()` will also append things to an existing vector:


::: {.cell}

```{.r .cell-code}
vector4 <- c("a", "b")
vector4
```

::: {.cell-output .cell-output-stdout}

```
[1] "a" "b"
```


:::

```{.r .cell-code}
c(vector4, "SWC")
```

::: {.cell-output .cell-output-stdout}

```
[1] "a"   "b"   "SWC"
```


:::
:::


You can also make series of whole numbers with the `:` operator...


::: {.cell}

```{.r .cell-code}
1:10
```

::: {.cell-output .cell-output-stdout}

```
 [1]  1  2  3  4  5  6  7  8  9 10
```


:::
:::


...or, for example, use the function `seq()` for fine control over the sequence: 


::: {.cell}

```{.r .cell-code}
vector6 <- seq(from = 6, to = 12, by = 0.2)
vector6
```

::: {.cell-output .cell-output-stdout}

```
 [1]  6.0  6.2  6.4  6.6  6.8  7.0  7.2  7.4  7.6  7.8  8.0  8.2  8.4  8.6  8.8
[16]  9.0  9.2  9.4  9.6  9.8 10.0 10.2 10.4 10.6 10.8 11.0 11.2 11.4 11.6 11.8
[31] 12.0
```


:::
:::


**Mini-challenge:**\
Start by making a vector `x` with the numbers 1 through 26.
Then, multiply the vector by 2 to create vector `y`.

<details><summary>Click for the solution</summary>


::: {.cell}

```{.r .cell-code}
x <- 1:26
y <- x * 2
```
:::


</details>

<br>

### Exploring vectors

R has many built-in functions to get information about vectors and other types of
objects, such as:

- `head()` and `tail()` to get the first few and last few elements, respectively:


::: {.cell}

```{.r .cell-code}
head(vector6)
```

::: {.cell-output .cell-output-stdout}

```
[1] 6.0 6.2 6.4 6.6 6.8 7.0
```


:::

```{.r .cell-code}
# Both head and tail take an argument `n` to specify the number of elements to print:
head(vector6, n = 2)
```

::: {.cell-output .cell-output-stdout}

```
[1] 6.0 6.2
```


:::

```{.r .cell-code}
tail(vector6, n = 4)
```

::: {.cell-output .cell-output-stdout}

```
[1] 11.4 11.6 11.8 12.0
```


:::
:::


- `length()` to get the number of elements:


::: {.cell}

```{.r .cell-code}
length(vector6)
```

::: {.cell-output .cell-output-stdout}

```
[1] 31
```


:::
:::


- Functions like `sum()` and `mean()`, _if_ the vector contains numbers:


::: {.cell}

```{.r .cell-code}
sum(vector6)
```

::: {.cell-output .cell-output-stdout}

```
[1] 279
```


:::

```{.r .cell-code}
mean(vector6)
```

::: {.cell-output .cell-output-stdout}

```
[1] 9
```


:::
:::


<br>

### A brief intro to missing values (`NA`)

R has a concept of missing data.
This makes sense because it is commonly used to analyze data sets and not all 
information/measurements are always available for all samples.

The way missing values are coded in R is using `NA`
(and this is not a character string, so it is not quoted):


::: {.cell}

```{.r .cell-code}
vector_NA <- c(1, 3, NA, 7)
vector_NA
```

::: {.cell-output .cell-output-stdout}

```
[1]  1  3 NA  7
```


:::
:::


The main reason to bring this up so early in your R journey is that
you should be aware that many summarizing functions will return `NA` if any
value is `NA`...


::: {.cell}

```{.r .cell-code}
sum(vector_NA)
```

::: {.cell-output .cell-output-stdout}

```
[1] NA
```


:::
:::


...and the way to get around this is by setting  `na.rm = TRUE`:


::: {.cell}

```{.r .cell-code}
sum(vector_NA, na.rm = TRUE)
```

::: {.cell-output .cell-output-stdout}

```
[1] 11
```


:::
:::


<br>

### Extracting elements from vectors

We can extract elements of a vector by "indexing" them using bracket notation:


::: {.cell}

```{.r .cell-code}
# Get the first element:
vector6[1]
```

::: {.cell-output .cell-output-stdout}

```
[1] 6
```


:::

```{.r .cell-code}
# Get the second through the fifth element:
vector6[2:5]
```

::: {.cell-output .cell-output-stdout}

```
[1] 6.2 6.4 6.6 6.8
```


:::

```{.r .cell-code}
# Get the first and eight element:
vector6[c(1, 8)]
```

::: {.cell-output .cell-output-stdout}

```
[1] 6.0 7.4
```


:::
:::


To _change_ an element, use the bracket on the other side of the arrow:


::: {.cell}

```{.r .cell-code}
# Change the first element to '30':
vector6[1] <- 30
vector6
```

::: {.cell-output .cell-output-stdout}

```
 [1] 30.0  6.2  6.4  6.6  6.8  7.0  7.2  7.4  7.6  7.8  8.0  8.2  8.4  8.6  8.8
[16]  9.0  9.2  9.4  9.6  9.8 10.0 10.2 10.4 10.6 10.8 11.0 11.2 11.4 11.6 11.8
[31] 12.0
```


:::
:::


<br>

## Data structure 2: Data frames

### R stores tabular data in "data frames"

One of R's most powerful features is its built-in ability to deal with tabular data --
i.e., data with rows and columns like you are familiar with from spreadsheets.

In R, tabular data is stored in objects that are called "data frames".
Data frames are the second and final R data structure that we'll cover in some depth.

Let's start by making a toy data frame with some information about 3 cats:


::: {.cell}

```{.r .cell-code}
cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))

cats
```

::: {.cell-output .cell-output-stdout}

```
    coat weight likes_string
1 calico    2.1            1
2  black    5.0            0
3  tabby    3.2            1
```


:::
:::


What we really did above is to create 3 named vectors, all of length 3,
and pasted them side-by-side to create a data frame.
The names of the vectors become the column names.

The data frame has 3 rows (one for each cat) and 3 columns
(each with a type of info about the cats, like coat color).

In data frames,
separate _variables_ (e.g. coat color, weight) are typically spread across columns,
and separate "_observations_" (e.g., cat/person, sample, country) across rows.

<br>

### Writing and reading tabular data

Let's practice writing and reading data.
First, we will write data to file that is in our R environment,
and then we will read data that is in a file into our R environment.

Via functions from an add-on package, R can interact with Excel spreadsheet files,
but keeping your data in plain-text files generally benefits reproducibility.
Tabular plain text files can be stored using a _Tab_ as the delimiter
(these are often called TSV files, and stored with a `.tsv` extension)
or with a _comma_ as the delimiter
(these are often called CSV files, and stored with a `.csv` extension).

We will use the `write.csv` function to write the `cats` data frame to a CSV file
in our current working directory:


::: {.cell}

```{.r .cell-code}
write.csv(x = cats, file = "feline-data.csv", row.names = FALSE)
```
:::


Here, we are explicitly naming all arguments, which can be good practice for clarity:

- `x` is the R object to write to file
- `file` is the file name (which can include directories/folders)
- We are setting `row.names = FALSE` to avoid writing the row names,
  which by default are just row numbers.

Let's find our new file and click on it in RStudio's Files pane,
so the file will open in the editor, where it should look like this:

```
"coat","weight","likes_string"
"calico",2.1,1
"black",5,0
"tabby",3.2,1
```

(Note that R adds double quotes `"..."` around strings --
if you want to avoid this, add `quote = FALSE` to `write.csv()`.)

-------

Let's also practice reading data from a file into R.
We'll use the `read.csv()` function for the file we just created: 


::: {.cell}

```{.r .cell-code}
cats2 <- read.csv(file = "feline-data.csv")
cats2
```

::: {.cell-output .cell-output-stdout}

```
    coat weight likes_string
1 calico    2.1            1
2  black    5.0            0
3  tabby    3.2            1
```


:::
:::


A final note:
`write.csv()` and `read.csv()` are really just two more specific convenience versions
of the `write/read.table()` functions,
which can be used to write and read in tabular data in any kind of plain text file.

<br>

### Extracting columns from a data frame

We can extract individual columns from a data frame by specifying their names
using the `$` operator:


::: {.cell}

```{.r .cell-code}
cats$weight
```

::: {.cell-output .cell-output-stdout}

```
[1] 2.1 5.0 3.2
```


:::

```{.r .cell-code}
cats$coat
```

::: {.cell-output .cell-output-stdout}

```
[1] "calico" "black"  "tabby" 
```


:::
:::


This kind of operation will return a vector.
We won't go into more detail about exploring (or manipulating) data frames,
because we will do that with the _dplyr_ package in the next episode

<br>

### Other data structures

We won't go into details about R's other data structures,
which are less common than vectors and data frames.
Two that are worth mentioning briefly, though, are:

- Matrices, which can be convenient when you have tabular data that is exclusively
  numeric (excluding names/labels).

- Lists, which are more flexible (and complicated) than vectors:
  they can contain multiple data types, and can also be hierarchically structured.

<br>

## Data types

Consider the following two examples of operating on the data in a data frame:

- Say we discovered that the scale is off by 2 kg:


::: {.cell}

```{.r .cell-code}
cats$weight + 2
```

::: {.cell-output .cell-output-stdout}

```
[1] 4.1 7.0 5.2
```


:::
:::


- Or we want to build sentences based on the coat color:


::: {.cell}

```{.r .cell-code}
paste("My cat is", cats$coat)
```

::: {.cell-output .cell-output-stdout}

```
[1] "My cat is calico" "My cat is black"  "My cat is tabby" 
```


:::
:::


An important side note about these operations is that
a single value or string is "recycled" as many times as needed to operate on
each of the entries from the data frame --
this is called "vectorization" and is a very useful feature of R.
(For more about vectorization, see
[episode 9](https://swcarpentry.github.io/r-novice-gapminder/instructor/09-vectorization.html)
from our Carpentries lesson.)

Now let's see a third example:


::: {.cell}

```{.r .cell-code}
cats$weight + cats$coat
```

::: {.cell-output .cell-output-error}

```
Error in cats$weight + cats$coat: non-numeric argument to binary operator
```


:::
:::


Understanding why this failed is key to successfully analyzing data in R.

<br>

### R's main Data Types

If you guessed that the last command will return an error because `2.1` plus
`"black"` is nonsense, you're right --
and you already have some intuition for an important concept in programming called
*data types*.

We can ask what type of data something is in R using the `typeof()` function:


::: {.cell}

```{.r .cell-code}
typeof(cats$weight)
```

::: {.cell-output .cell-output-stdout}

```
[1] "double"
```


:::
:::


We'll go over the 4 common types:
`double` (also called `numeric`), `integer`, `character`, and `logical`.

- `double` / `numeric` -- numbers that can have decimal points:


::: {.cell}

```{.r .cell-code}
typeof(3.14)
```

::: {.cell-output .cell-output-stdout}

```
[1] "double"
```


:::
:::


- `integer` -- whole numbers only:


::: {.cell}

```{.r .cell-code}
typeof(1:3)
```

::: {.cell-output .cell-output-stdout}

```
[1] "integer"
```


:::
:::


- `character` -- strings, which typically contain letters but can have any character:


::: {.cell}

```{.r .cell-code}
typeof("banana")
```

::: {.cell-output .cell-output-stdout}

```
[1] "character"
```


:::
:::


- `logical` (either `TRUE` or `FALSE`):


::: {.cell}

```{.r .cell-code}
typeof(TRUE)
```

::: {.cell-output .cell-output-stdout}

```
[1] "logical"
```


:::
:::


**Mini-challenge**:\
What do you think each of the following might produce?


::: {.cell}

```{.r .cell-code}
typeof("2")
```

::: {.cell-output .cell-output-stdout}

```
[1] "character"
```


:::

```{.r .cell-code}
typeof("TRUE")
```

::: {.cell-output .cell-output-stdout}

```
[1] "character"
```


:::

```{.r .cell-code}
typeof(banana)
```

::: {.cell-output .cell-output-error}

```
Error in eval(expr, envir, enclos): object 'banana' not found
```


:::

```{.r .cell-code}
# Could include typeof(1)
```
:::


<details><summary>Click for the solution</summary>

1. `"2"` is `character` because of the quotes around the number
2. Same principle as above: `"TRUE"` is `character`
3. Recall the earlier example:
   this returns an error because the object `banana` does not exist.

</details>

---------

As mentioned above, vectors can only be composed of a single data type and this is
also true for data frame columns (which really are vectors).
R will silently pick the "best-fitting" data type when you enter or read data into
a data frame.
Let's see what the data types are in our `cats` data frame:


::: {.cell}

```{.r .cell-code}
str(cats)
```

::: {.cell-output .cell-output-stdout}

```
'data.frame':	3 obs. of  3 variables:
 $ coat        : chr  "calico" "black" "tabby"
 $ weight      : num  2.1 5 3.2
 $ likes_string: num  1 0 1
```


:::
:::


- The `coat` column is `character`, abbreviated `chr`.
- The `weight` column is `double`/`numeric`, abbreviated `num`.
- The `likes_string` column is `integer`, abbreviated `int`.

So, more formally, the reason that `cats$weight` + `cats$coat` failed is because
we tried to apply a mathematical function to data that included strings.

<br>

### Automatic Type Coercion

Q: Given what we've learned so far,
   what type of vector do you think the following will produce?


::: {.cell}

```{.r .cell-code}
quiz_vector <- c(2, 6, "3")
```
:::


<details><summary>Click for the solution</summary>

A: It produces a character vector:


::: {.cell}

```{.r .cell-code}
quiz_vector
```

::: {.cell-output .cell-output-stdout}

```
[1] "2" "6" "3"
```


:::

```{.r .cell-code}
typeof(quiz_vector)
```

::: {.cell-output .cell-output-stdout}

```
[1] "character"
```


:::
:::


</details>

What happened here is something called *type coercion*,
and it is the source of many surprises and the reason why we need to be aware of
the basic data types and how R will interpret them.
When R encounters a mix of types (here `double` and `character`) to be combined
into a single vector, it will force them all to be the same type.

Also consider:


::: {.cell}

```{.r .cell-code}
coercion_vector <- c("a", TRUE)
coercion_vector
```

::: {.cell-output .cell-output-stdout}

```
[1] "a"    "TRUE"
```


:::

```{.r .cell-code}
typeof(coercion_vector)
```

::: {.cell-output .cell-output-stdout}

```
[1] "character"
```


:::
:::


Like in the examples above, you will most commonly run into situations where
numbers or logicals are converted to characters.

The nitty-gritty of type coercion aside, the point is:
if your data doesn't look like what you thought it was going to look like,
type coercion may well be to blame;
make sure everything is the same type in your vectors and your columns of data frames,
or you will get nasty surprises!

<br>

### Manual Type Conversion

Luckily, you are not simply at the mercy of whatever R decides to do automatically,
but can convert vectors at will using the `as.` group of functions
(here, try RStudio's auto-complete function: Type "`as.`" and then press the TAB key):


::: {.cell}

```{.r .cell-code}
as.double(c("0", "2", "4"))
```

::: {.cell-output .cell-output-stdout}

```
[1] 0 2 4
```


:::

```{.r .cell-code}
as.character(c(0, 2, 4))
```

::: {.cell-output .cell-output-stdout}

```
[1] "0" "2" "4"
```


:::

```{.r .cell-code}
as.logical(c(0, 2, 4))
```

::: {.cell-output .cell-output-stdout}

```
[1] FALSE  TRUE  TRUE
```


:::
:::


For example, in our `cats` data `likes_string` is numeric,
but we know that the 1s and 0s actually represent `TRUE` and `FALSE`
(a common way of representing them).
We should use the `logical` data type here, which has two states:
`TRUE` or `FALSE`, which is exactly what our data represents.
We can 'coerce' this column to be `logical` by using the `as.logical` function:


::: {.cell}

```{.r .cell-code}
cats$likes_string
```

::: {.cell-output .cell-output-stdout}

```
[1] 1 0 1
```


:::

```{.r .cell-code}
cats$likes_string <- as.logical(cats$likes_string)
cats$likes_string
```

::: {.cell-output .cell-output-stdout}

```
[1]  TRUE FALSE  TRUE
```


:::
:::


If you think `1`/`0` could be more useful than `TRUE`/`FALSE` because it's easier
to count the number of cases something is true or false, consider:


::: {.cell}

```{.r .cell-code}
TRUE + TRUE
```

::: {.cell-output .cell-output-stdout}

```
[1] 2
```


:::
:::


As you may have guessed, though, not all type conversions are really possible:


::: {.cell}

```{.r .cell-code}
as.double("kiwi")
```

::: {.cell-output .cell-output-stderr}

```
Warning: NAs introduced by coercion
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] NA
```


:::
:::


<br>

## Challenge


::: {.cell}

```{.r .cell-code}
URL <- "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/feline-data_v2.csv"
download.file(url = URL, destfile = "feline-data_v2.csv")
```
:::


An important part of every data analysis is cleaning the input data.
If you know that the input data is all of the same format (e.g. numbers),
your analysis is much easier!
Here, you will clean the cat data set.

Create a new script in RStudio and copy and paste the following code into it.
Then move on to the tasks below, which help you to fill in the gaps.

```
# Read the data into a data frame called `cats`
cats <- read.csv("feline-data_v2.csv")

# 1. Print the contents of the data frame in the console
_____

# 2. Show an overview of the table with all data types
_____(cats)

# 3. The "weight" column has the incorrect data type __________.
#    The correct data type is: ____________.

# 4. Correct the 4th weight data point with the mean of the two given values
cats$weight[4] <- 2.35
#    print the data again to see the effect
cats

# 5. Convert the weight to the right data type
cats$weight <- ______________(cats$weight)

#    Calculate the mean to test yourself
mean(cats$weight)

# If you see the correct mean value (and not NA), you did the exercise
# correctly!
```

<details><summary>Click for the solution</summary>


::: {.cell}

```{.r .cell-code}
# Read the data into a data frame called `cats`
cats <- read.csv("feline-data_v2.csv")

# 1. Print the contents of the data frame in the console
cats

# 2. Show an overview of the table with all data types
str(cats)

# 3. The "weight" column has the incorrect data type character.
#    The correct data type is: double.

# 4. Correct the 4th weight data point with the mean of the two given values
cats$weight[4] <- 2.35
#    Print the data again to see the effect
cats

# 5. Convert the weight to the right data type
cats$weight <- as.double(cats$weight)
#    The following is synonymous to the above:
cats$weight <- as.numeric(cats$weight)

#    Calculate the mean to test yourself
mean(cats$weight)

# If you see the mean value 3.1625 and not NA, you did the exercise correctly!
```
:::


</details>

<br>

## Learn more

This material was adapted from
[this Carpentries lesson episode](https://swcarpentry.github.io/r-novice-gapminder/04-data-structures-part1.html).
To learn more about data types and data structures, see
[this chapter](https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures.html).



