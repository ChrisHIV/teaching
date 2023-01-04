## A quick introduction to the tidyverse for R coding

Abbreviations:  
df = dataframe  
col = column

From https://www.tidyverse.org/:
"The tidyverse is an opinionated collection of R packages designed for data
science. All packages share an underlying design philosophy, grammar, and data
structures."

When I used to write R code using only 'base R' (i.e. functions included in
the language without extra packages) for my basic operations, R was my least
favourite language. When I switched to using the tidyverse, it very quickly
became my favourite language. My main reliance on the tidyverse is for the
dplyr package.

A key operator included in the tidyverse is the pipe operator:   
`object %>% func(arg2, arg3)` is equivalent to `func(object, arg2, arg3)`  
`x %>% y %>% z` is equivalent to `z(y(x))`  
When you want to manipulate one object by performing a series of steps on it,
using the pipe operator makes it clearer by arranging the steps in the order
in which they are performed.
The pipe operator was recently added to base R as `|>` 

Tibbles inherit from dataframes and have no differences in practise.  
`bind_rows` and `bind_cols` are basically `rbind` and `cbind` I think.  
`map` is basically like `lapply`; variants of it include `map_dbl` which coerces the resulting list into a vector of doubles or dies trying, and similar for other data types.
Useful for checking your output is what you expect.  
The following verbs for doing something to a dataframe (all from dplyr or tidyr I think)
* `rename` renames columns
* `select` selects the named columns (or discards if with a minus sign)
* `mutate` defines new columns or overwrites existing ones, according the expression given e.g. `mutate(cases_per_capita  = cases / population)`
* `pull` returns a single named column as vector, i.e. `pull(df, my_col) == df %>% pull(my_col) == df$my_col`
* `filter` picks out rows satisfying the supplied condition
* `arrange` sorts the rows of the dataframe by the value of the column supplied 
* `summarise` I only use after a `group_by()` call...  

The `group_by()` adverb doesn’t change the content of the dataframe, but affixes some metadata ready for a subsequent operation that will work on each group separately; `group_by(col_1)` groups together all rows that have the same value for the `col_1` variable.  
* ...`summarise` calculates one value per group of the desired variable (and if there are no groups, one value for the whole dataframe). e.g. if `df` has columns `date`, `authority` and `num_cases`, then `df %>% group_by(authority) %>% summarise(cases_total = sum(cases))` would give a dataframe with just columns authority and cases_total, with the latter being a sum over all dates present for that authority in the original dataframe.  

(`ungroup` just removes the grouping metadata, which is good practise to avoid unexpected things downstream, though redundant if it follows a summarise that acted on only a single grouping variable.)

The `*_join` set of functions merge dataframes by matching on a desired column (or columns).
e.g. `left_join(df_1, df_2, by = matching_col_name)` creates a dataframe that _usually_ has as many rows as the left argument `df_1`, adding in new columns present in `df_2`.
e.g. if `df_1` has `authority`, `date`, `num_cases`, and `df_2` has `authority`, `population`, then `left_join(df_1, df_2, by = "authority")` gives a dataframe like `df_1` with a new column `population` (with values that get duplicated many times because each authority appears many times in `df_1`).
(The exception to that _usually_ is if the values of the matching variable are not unique in `df_2`, in which case you get a row for each match.)
Subsequently piping to `mutate(num_cases_per_capita = num_cases / authority)` would be de rigueur.
If there are any authorities in `df_1` that don’t appear in `df_2`, their value of population would be set to `NA`.
`inner_join` creates in dataframes that only include rows for values of the matching variable that appear in both dataframes; `full_join` includes rows for values of the matching variable that appear in either.  


### An example 

One typical example of my wrangling.
First generate toy disease case counts for some disease over time, any which way.
```R
df_cases_england <- tibble(date = seq.Date(from = as.Date("2020-02-15"),
                                           to   = as.Date("2020-05-15"),
                                           by = "day"))
df_cases_england$count <- rpois(n = nrow(df_cases_england), lambda = 50)
df_cases_england <- df_cases_england[sample(1:nrow(df_cases_england)), ]
df_cases_england$unwanted_col_1 <- NA
df_cases_england$unwanted_col_2 <- NA
df_cases_wales <- df_cases_england
df_cases_wales$count <- rpois(n = nrow(df_cases_wales), lambda = 5)
```
Now process that data in base R (maybe I'm being unfairly ugly here; I'm out of practise in base R).
Steps:  
1: Make a copy to avoid modifying the original  
2: select only the desired cols  
3: rename a col  
4: Make a copy to avoid modifying the original  
5: rename a col  
6: merge two dfs  
7: add a col summing two others  
8: keep some rows, discard others  
9: sort rows  
```R
df_cases_england_temp <- df_cases_england  # 1
df_cases_england_temp <- df_cases_england_temp[c("date", "count")]  # 2
colnames(df_cases_england_temp)[colnames(df_cases_england_temp) == "count"] <- "count_eng"  # 3
df_cases_wales_temp <- df_cases_wales # 4
colnames(df_cases_wales_temp)[colnames(df_cases_wales_temp) == "count"] <- "count_wal" # 5
df_cases <- merge(df_cases_england_temp, # 6
                  df_cases_wales_temp, 
                  by = "date", 
                  all = TRUE)
df_cases$count <- df_cases$count_eng + df_cases$count_wal # 7
df_cases <- df_cases[df_cases$date >= "2020-03-01", ] # 8
df_cases <- df_cases[order(df_cases$date, decreasing = TRUE), ] # 9
```
Here's how those steps look when processed in dplyr.
Note no repeated references to the df being modified, and modifications of other dfs can be done in-place without creating a copy of them.
```R
df_cases <- df_cases_england %>%
  select(date, count) %>%
  rename(count_eng = count) %>%
  full_join(df_cases_wales %>% rename(count_wal = count),
            by = "date") %>%
  mutate(count = count_eng + count_wal) %>%
  filter(date >= "2020-03-01") %>%
  arrange(desc(date))
  ```

Now let's create summaries by group, here by month.

In base R, this is horrendous (credit to https://cran.r-project.org/web/packages/dplyr/vignettes/base.html or I wouldn't even have known how to do it)
```R
df_cases_temp <- df_cases # Make a copy to avoid modifying the original
df_cases_temp$month <- format(df_cases$date, "%Y-%m")
df_cases_monthly_intermediate <-
  by(df_cases_temp, df_cases_temp$month, function(df) {
    with(df, data.frame(month = month[[1]],
                        count_mean = mean(count),
                        num_observations = nrow(df)))
  })
df_cases_monthly <- do.call(rbind, df_cases_monthly_intermediate)
```
Here's how that looks in dplyr:
```R
df_cases_monthly <- df_cases %>%
  mutate(month = format(date, "%Y-%m")) %>%
  group_by(month) %>%
  summarise(count_mean = mean(count),
            num_observations = n())
```

# CHECKING CODE LINE BY LINE ---------------------------------------------------

# It might look easier to check the base R version as you go, because you keep
# redefining your DF and so you can see what it looks like at each step, whereas
# the dplyr version does all the steps in one go. But in practise you would (or
# at least I do) write this kind of code to print your modified df one step at a
# time and see that it gives you what want. e.g. to write
df_cases <- df_cases_england %>%
  select(date, count) %>%
  rename(count_eng = count) %>%
  full_join(df_cases_wales %>% rename(count_wal = count),
            by = "date") %>%
  mutate(count = count_eng + count_wal) %>%
  filter(date >= "2020-03-01") %>%
  arrange(desc(date))
# I would start with
df_cases_england %>%
  select(date, count)
# which prints the modification I intended (just picking two columns).
# Then I'd write
df_cases_england %>%
  select(date, count) %>%
  rename(count_eng = count)
# which prints the modification I intended (renaming c.f. the previous step).
# I'd keep doing that till all my steps are there and I'm happy with them, then
# go back to the first line and replace
# df_cases_england %>%
# by
# df_cases <- df_cases_england %>%
# to assign the result of those steps to a df instead of just printing them.

# That's a particularly handy way of writing a block of steps when you're
# modifying an existing df instead of creating a new one, e.g. with
# df <- df %>%
#        ...
# because you can check you're modifying the way you intended as you go without
# overwriting the thing you start with, so if you change your mind you don't
# have to regenerate df.
# And if you're checking a block that has already been written, you can just
# highlight and execute part of it to help follow the steps.
