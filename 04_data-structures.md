# R’s Data Structures and Data Types
Author: Software Carpentry, with edits by Jelmer Poelstra. Date:
2024-08-19

<br>

In this episode, we will learn about R’s **data structures** and **data
types**.

- Data structures are the kinds of objects (or we could say containers)
  that R has available to store data in. Here, we will cover the two
  most common data structures, *vectors* and *data frames*.

- Data types are how R distinguishes between different kinds of data
  like numbers and character strings. Here, we’ll talk about the 4 main
  data types: `character`, `integer`, `double`, and `logical.`

<br>

## Data structure 1: Vectors

The first data structure we will explore is the simplest: the vector. A
vector in R is essentially *a list of one or more items*. Moving
forward, we’ll call these individual items “elements”.

### Single-element vectors and quoting

Vectors can consist of just a single element, so in each of the two
lines of code below, a vector is in fact created:

``` r
vector1 <- 8
vector2 <- "panda"
```

Two things are worth noting about the second example with a character
string:

- “panda” constitutes one element, not 5 (its number of letters).

- We have to quote the string (either double or single quotes are fine,
  with the former more common). This is because unquoted character
  strings are interpreted as R objects – for example, `vector1` and
  `vector2` above are objects, and should be referred to without quotes:

``` r
vector1
```

    [1] 8

``` r
vector2
```

    [1] "panda"

Conversely, the below doesn’t work, because there is no *object called
`panda`*:

``` r
vector_fail <- panda
```

    Error in eval(expr, envir, enclos): object 'panda' not found

<br>

### Multi-element vectors

A common way to make vectors with multiple elements is to use the `c`
(combine) function:

``` r
c(2, 6, 3)
```

    [1] 2 6 3

(In the above example, I didn’t assign the vector to an object, but a
vector was created nevertheless.)

`c()` can also append elements to an existing vector:

``` r
vector4 <- c("a", "b")
vector4
```

    [1] "a" "b"

``` r
c(vector4, "SWC")
```

    [1] "a"   "b"   "SWC"

To create vectors with series of numbers, a couple of shortcuts are
available. First, you can make series of whole numbers with the `:`
operator:

``` r
1:10
```

     [1]  1  2  3  4  5  6  7  8  9 10

Second, you can use a function like `seq()` for fine control over the
sequence:

``` r
vector_seq <- seq(from = 6, to = 8, by = 0.2)
vector_seq
```

     [1] 6.0 6.2 6.4 6.6 6.8 7.0 7.2 7.4 7.6 7.8 8.0

<br>

### Vectorization

In R, you can do the following:

``` r
vector_seq * 2
```

     [1] 12.0 12.4 12.8 13.2 13.6 14.0 14.4 14.8 15.2 15.6 16.0

Above, we multiplied every single element in `vector_seq` by 2. Another
way of looking at this is that 2 was recycled as many times as necessary
to operate on each element in `vector_seq`. We call this “vectorization”
and this is a key feature of the R language. This behavior may seem
intuitive, but in most languages you’d need a special construct like a
loop to operate on each value in a vector.

(Alternatively, you may have expected this code to *repeat* `vector_seq`
twice, but this did not happen! R has the function `rep()` for that. For
more about vectorization, see [episode
9](https://swcarpentry.github.io/r-novice-gapminder/instructor/09-vectorization.html)
from our Carpentries lesson.)

<br>

------------------------------------------------------------------------

### Challenge 1

**A.** Start by making a vector `x` with the whole numbers 1 through 26.
Then, multiply each element in the vector by 5 to create vector `y`.

<details>
<summary>
Click for the solution
</summary>

``` r
x <- 1:26
x
```

     [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
    [26] 26

``` r
y <- x * 5
y
```

     [1]   5  10  15  20  25  30  35  40  45  50  55  60  65  70  75  80  85  90  95
    [20] 100 105 110 115 120 125 130

</details>

**B.** What do you think will be the result of the following operation?

``` r
1:5 * 1:5
```

<details>
<summary>
Click for the solution
</summary>

``` r
1:5 * 1:5
```

    [1]  1  4  9 16 25

Both vectors are of length 5 which will lead to “element-wise matching”:
the first element in the first vector will be multiplied with the first
element in the second vector, the second element in the first vector
will be multiplied with the second element in the second vector, and so
on.

</details>

------------------------------------------------------------------------

<br>

### Exploring vectors

R has many built-in functions to get information about vectors and other
types of objects, such as:

- `head()` and `tail()` to get the first few and last few elements,
  respectively:

``` r
head(vector_seq)
```

    [1] 6.0 6.2 6.4 6.6 6.8 7.0

``` r
# Both head and tail take an argument `n` to specify the number of elements to print:
head(vector_seq, n = 2)
```

    [1] 6.0 6.2

``` r
tail(vector_seq, n = 4)
```

    [1] 7.4 7.6 7.8 8.0

<br>

- `length()` to get the number of elements:

``` r
length(vector_seq)
```

    [1] 11

<br>

- Functions like `sum()` and `mean()`, *if* the vector contains numbers:

``` r
# sum() will sum the values of all elements
sum(vector_seq)
```

    [1] 77

``` r
# mean() will compute the mean (average) across all elements
mean(vector_seq)
```

    [1] 7

<br>

### Intermezzo: missing values (`NA`)

R has a concept of missing data, which is important in statistical
computing, as not all information/measurements are always available for
all samples.

Missing values are coded in R as `NA` (and this is not a character
string, so it is not quoted):

``` r
# This vector will contain one missing value
vector_NA <- c(1, 3, NA, 7)
vector_NA
```

    [1]  1  3 NA  7

The main reason to bring this up so early in your R journey is that you
should be aware of the following: many functions that operate on vectors
will return `NA` if any of the elements in the vector is `NA`:

``` r
sum(vector_NA)
```

    [1] NA

The way to get around this is by setting `na.rm = TRUE` in such
functions, for example:

``` r
sum(vector_NA, na.rm = TRUE)
```

    [1] 11

<br>

### Extracting elements from vectors

We can extract elements of a vector by “indexing” them using bracket
notation. Here are a couple of examples:

- Get the first element:

``` r
vector_seq[1]
```

    [1] 6

- Get the second through the fifth elements:

``` r
vector_seq[2:5]
```

    [1] 6.2 6.4 6.6 6.8

- Get the first and eight elements:

``` r
vector_seq[c(1, 8)]
```

    [1] 6.0 7.4

To *change* an element in a vector, use the bracket on the other side of
the arrow:

``` r
# Change the first element to '30':
vector_seq[1] <- 30
vector_seq
```

     [1] 30.0  6.2  6.4  6.6  6.8  7.0  7.2  7.4  7.6  7.8  8.0

<br>

## Data structure 2: Data frames

### R stores tabular data in “data frames”

One of R’s most powerful features is its built-in ability to deal with
tabular data – i.e., data with rows and columns like you are familiar
with from spreadsheets.

In R, tabular data is stored in objects that are called “data frames”.
Data frames are the second and final R data structure that we’ll cover
in some depth.

Let’s start by making a toy data frame with some information about 3
cats:

``` r
cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))

cats
```

        coat weight likes_string
    1 calico    2.1            1
    2  black    5.0            0
    3  tabby    3.2            1

What we really did above is to create 3 vectors, all of length 3, and
pasted them side-by-side to create a data frame. We also gave each
vector a name, which became the column names.

The resulting data frame has 3 rows (one for each cat) and 3 columns
(each with a type of info about the cats, like coat color).

In data frames, typically:

- Separate *variables* (e.g. coat color, weight) are spread across
  columns,
- Separate “*observations*” (e.g., cat/person, sample) are spread across
  rows.

<br>

### Extracting columns from a data frame

We can extract individual columns from a data frame by specifying their
names using the `$` operator:

``` r
cats$weight
```

    [1] 2.1 5.0 3.2

``` r
cats$coat
```

    [1] "calico" "black"  "tabby" 

This kind of operation will return a vector. We won’t go into more
detail about exploring (or manipulating) data frames, because we will do
that with the *dplyr* package in the next episode.

<br>

### Writing and reading tabular data

Let’s practice writing and reading data. First, we will write data to
file that is in our R environment, and then we will read data that is in
a file into our R environment.

Via functions from an add-on package, R can interact with Excel
spreadsheet files, but keeping your data in plain-text files generally
benefits reproducibility. Tabular plain text files can be stored using a
*Tab* as the delimiter (these are often called TSV files, and stored
with a `.tsv` extension) or with a *comma* as the delimiter (these are
often called CSV files, and stored with a `.csv` extension).

We will use the `write.csv` function to write the `cats` data frame to a
CSV file in our current working directory:

``` r
write.csv(x = cats, file = "feline-data.csv", row.names = FALSE)
```

Here, we are explicitly naming all arguments, which can be good practice
for clarity:

- `x` is the R object to write to file
- `file` is the file name (which can include directories/folders)
- We are setting `row.names = FALSE` to avoid writing the row names,
  which by default are just row numbers.

Let’s find our new file and click on it in RStudio’s Files pane, so the
file will open in the editor, where it should look like this:

    "coat","weight","likes_string"
    "calico",2.1,1
    "black",5,0
    "tabby",3.2,1

(Note that R adds double quotes `"..."` around strings – if you want to
avoid this, add `quote = FALSE` to `write.csv()`.)

------------------------------------------------------------------------

Let’s also practice reading data from a file into R. We’ll use the
`read.csv()` function for the file we just created:

``` r
cats2 <- read.csv(file = "feline-data.csv")
cats2
```

        coat weight likes_string
    1 calico    2.1            1
    2  black    5.0            0
    3  tabby    3.2            1

A final note: `write.csv()` and `read.csv()` are really just two more
specific convenience versions of the `write/read.table()` functions,
which can be used to write and read in tabular data in any kind of plain
text file.

<br>

### Other data structures

We won’t go into details about R’s other data structures, which are less
common than vectors and data frames. Two that are worth mentioning
briefly, though, are:

- **Matrix**, which can be convenient when you have tabular data that is
  exclusively numeric (excluding names/labels).

- **List**, which is more flexible (and complicated) than vectors: it
  can contain multiple data types, and can also be hierarchically
  structured.

<br>

## Data types

Consider the following two examples of operating on the data in a data
frame:

- Say we discovered that the scale is off by 2 kg, and we try to adjust
  the weight:

``` r
cats$weight + 2
```

    [1] 4.1 7.0 5.2

- Or we want to build sentences based on the coat color:

``` r
paste("My cat is", cats$coat)
```

    [1] "My cat is calico" "My cat is black"  "My cat is tabby" 

But now, now let’s see a third example, which fails:

``` r
cats$weight + cats$coat
```

    Error in cats$weight + cats$coat: non-numeric argument to binary operator

Understanding why this failed is key to successfully analyzing data in
R.

<br>

### R’s main Data Types

If you guessed that the last command will return an error because `2.1`
plus `"black"` is nonsense, you’re right – and you already have some
intuition for an important concept in programming called *data types*.

We can ask what type of data something is in R using the `typeof()`
function:

``` r
typeof(cats$weight)
```

    [1] "double"

We’ll go over the 4 common types: `double` (also called `numeric`),
`integer`, `character`, and `logical`.

- `double` / `numeric` – numbers that can have decimal points:

``` r
typeof(3.14)
```

    [1] "double"

- `integer` – whole numbers only:

``` r
typeof(1:3)
```

    [1] "integer"

- `character` – strings, which typically contain letters but can have
  any character:

``` r
typeof("banana")
```

    [1] "character"

- `logical` (either `TRUE` or `FALSE`):

``` r
typeof(TRUE)
```

    [1] "logical"

<br>

------------------------------------------------------------------------

### Challenge 2

What do you expect each of the following to produce?

``` r
typeof("2")
typeof("TRUE")
typeof(banana)
```

<details>
<summary>
Click for the solution
</summary>

1.  `"2"` is `character` because of the quotes around the number
2.  Same principle as above: `"TRUE"` is `character`
3.  Recall the earlier example: this returns an error because the object
    `banana` does not exist.

</details>

------------------------------------------------------------------------

<br>

### Vectors and data frame columns can only have 1 data type

Vectors and individual columns in data frames can only be composed of a
single data type. R will silently pick the “best-fitting” data type when
you enter or read data into a data frame. Let’s see what the data types
are in our `cats` data frame:

``` r
str(cats)
```

    'data.frame':   3 obs. of  3 variables:
     $ coat        : chr  "calico" "black" "tabby"
     $ weight      : num  2.1 5 3.2
     $ likes_string: num  1 0 1

- The `coat` column is `character`, abbreviated `chr`.
- The `weight` column is `double`/`numeric`, abbreviated `num`.
- The `likes_string` column is `integer`, abbreviated `int`.

So, more formally, the reason that `cats$weight` + `cats$coat` failed is
because we tried to apply a mathematical function to data that included
strings.

<br>

------------------------------------------------------------------------

### Challenge 3

Given what we’ve learned so far, what type of vector do you think the
following will produce?

``` r
quiz_vector <- c(2, 6, "3")
```

<details>
<summary>
Click for the solution
</summary>

It produces a character vector:

``` r
quiz_vector
```

    [1] "2" "6" "3"

``` r
typeof(quiz_vector)
```

    [1] "character"

We’ll talk about what happened here in the next section.

</details>

------------------------------------------------------------------------

<br>

### Automatic Type Coercion

What happened in the code from the challenge above is something called
*type coercion*, and it is the source of many surprises and the reason
why we need to be aware of the basic data types and how R will interpret
them. When R encounters a *mix of types* (here `double` and `character`)
to be combined into a single vector, it will force them all to be the
same type.

Here is another example:

``` r
coercion_vector <- c("a", TRUE)
coercion_vector
```

    [1] "a"    "TRUE"

``` r
typeof(coercion_vector)
```

    [1] "character"

Like in two examples we’ve seen, you will most commonly run into
situations where *numbers or logicals are converted to characters*.

The nitty-gritty of type coercion aside, the point is: if your data
doesn’t look like what you thought it was going to look like, type
coercion may well be to blame; make sure everything is the same type in
your vectors and your columns of data frames, or you will get nasty
surprises!

<br>

### Manual Type Conversion

Luckily, you are not simply at the mercy of whatever R decides to do
automatically, but can convert vectors at will using the `as.` group of
functions (here, try RStudio’s auto-complete function: Type “`as.`” and
then press the TAB key):

``` r
as.double(c("0", "2", "4"))
```

    [1] 0 2 4

``` r
as.character(c(0, 2, 4))
```

    [1] "0" "2" "4"

``` r
as.logical(c(0, 2, 4))
```

    [1] FALSE  TRUE  TRUE

For example, in our `cats` data `likes_string` is numeric, but we know
that the 1s and 0s actually represent `TRUE` and `FALSE` (a common way
of representing them).

We should use the `logical` data type here, which has two states: `TRUE`
or `FALSE`, which is exactly what our data represents. We can convert
this column to a `logical` data type with the `as.logical()` function:

``` r
cats$likes_string
```

    [1] 1 0 1

``` r
as.logical(cats$likes_string)
```

    [1]  TRUE FALSE  TRUE

If you think `1`/`0` could be more useful than `TRUE`/`FALSE` because
it’s easier to count the number of cases something is true or false,
consider:

``` r
TRUE + TRUE
```

    [1] 2

So, logicals can be used as if they were numbers, in which case `FALSE`
represents 0 and `TRUE` represents 1.

As you may have guessed, though, not all type conversions are possible:

``` r
as.double("kiwi")
```

    Warning: NAs introduced by coercion

    [1] NA

<br>

------------------------------------------------------------------------

### Challenge 4

We’ll start by downloading a file and reading that into a data frame:

``` r
URL <- "https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/main/episodes/data/feline-data_v2.csv"
download.file(url = URL, destfile = "feline-data_v2.csv")

cats <- read.csv("feline-data_v2.csv")
```

An important part of every data analysis is cleaning the input data. If
you know that the input data is all of the same format (e.g. numbers),
your analysis is much easier! Here, you will clean the cat data set.

Create a new script in RStudio and copy and paste the following code
into it. Then move on to the tasks below, which help you to fill in the
gaps.

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

<br>

<details>
<summary>
Click for the solution
</summary>

``` r
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

</details>

------------------------------------------------------------------------

<br>

## Learn more

This material was adapted from [this Carpentries lesson
episode](https://swcarpentry.github.io/r-novice-gapminder/04-data-structures-part1.html).
To learn more about data types and data structures, see [this episode
from a separate Carpentries
lesson](https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures.html).
