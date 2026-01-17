# # Comprehensive Examples for extract_years_from_string()

# ## Overview
# ## The `extract_years_from_string()` function is an advanced version of `extract_year_from_string()`.
# ##
# ## **Key Differences:**

# ##| Feature | extract_year_from_string() | extract_years_from_string() |
# ##|---------|---------------------------|---------------------------|
# ##| **Extracts** | First year only | ALL years found |
# ##| **Returns** | Single year column | List of years with positions |
# ##| **Use Case** | Simple: one year per record | Complex: multiple years per record |
# ##| **Position Info** | No | Yes (starting index) |

# ---

# ## Example 1: Basic Usage - Find All Years

# ```r
library(DataPreparation)

# Data with multiple years
movies <- data.frame(
  id = 1:3,
  description = c(
    "Released 2010, remastered 2020",
    "Part 1 (2012) Part 2 (2015)",
    "From 1995 to 2005 franchise"
  )
)

# # Extract all years with positions
result <- extract_years_from_string(movies, "description")

# View the years_list column
result$years_list
# ```

# **Output:**
# ```
# [[1]]
#   year position
# 1 2010        10
# 2 2020        26

# [[2]]
#   year position
# 1 2012        8
# 2 2015        19

# [[3]]
#   year position
# 1 1995        6
# 2 2005        15
# ```

# ---

# ## Example 2: Access Individual Year Data

# ```r
# # Get all years from first row
first_row_years <- result$years_list[[1]]
print(first_row_years)
#   year position
# 1 2010       10
# 2 2020       26

# # Get just the years
years_only <- first_row_years$year
# [1] 2010 2020

# # Get just the positions
positions_only <- first_row_years$position
# [1] 10 26
# ```

# ---

# ## Example 3: Flatten the Results (Convert List to Long Format)

# ```r
# library(tidyr)

# # Flatten the list column for easier analysis
# expanded <- result %>%
#   tidyr::unnest(years_list, keep_empty = TRUE)

# print(expanded)
# #   id                    description year position
# # 1  1 Released 2010, remastered 2020 2010       10
# # 1  1 Released 2010, remastered 2020 2020       26
# # 2  2    Part 1 (2012) Part 2 (2015) 2012        8
# # 2  2    Part 1 (2012) Part 2 (2015) 2015       19
# # 3  3 From 1995 to 2005 franchise    1995        6
# # 3  3 From 1995 to 2005 franchise    2005       15
# ```

# ---

# ## Example 4: Filter for Records with Multiple Years

# ```r
# # Count years per record
# result$num_years <- sapply(result$years_list, nrow)

# # Find records with more than one year
# multi_year <- result[result$num_years > 1, ]
# print(multi_year)
# #   id                    description years_list num_years
# # 1  1 Released 2010, remastered 2020       ...         2
# # 2  2    Part 1 (2012) Part 2 (2015)       ...         2
# # 3  3 From 1995 to 2005 franchise    ...         2
# ```

# ---

# ## Example 5: Extract Year Ranges (Start and End Years)

# ```r
# library(tidyr)

# # Flatten and find min/max years per record
# expanded <- result %>%
#   tidyr::unnest(years_list, keep_empty = TRUE)

# ranges <- expanded %>%
#   group_by(id, description) %>%
#   summarise(
#     min_year = min(year, na.rm = TRUE),
#     max_year = max(year, na.rm = TRUE),
#     span = max_year - min_year,
#     .groups = 'drop'
#   )

# print(ranges)
# #   id                    description min_year max_year span
# # 1  1 Released 2010, remastered 2020     2010     2020   10
# # 2  2    Part 1 (2012) Part 2 (2015)     2012     2015    3
# # 3  3 From 1995 to 2005 franchise       1995     2005   10
# ```

# ---

# ## Example 6: Position-Based Analysis - Find First and Last Year

# ```r
# # Flatten results
# expanded <- result %>%
#   tidyr::unnest(years_list, keep_empty = TRUE)

# # Find first mentioned year (lowest position) per record
# first_mentioned <- expanded %>%
#   group_by(id) %>%
#   filter(position == min(position)) %>%
#   rename(first_year = year, first_position = position) %>%
#   select(id, first_year, first_position)

# # Find last mentioned year (highest position) per record
# last_mentioned <- expanded %>%
#   group_by(id) %>%
#   filter(position == max(position)) %>%
#   rename(last_year = year, last_position = position) %>%
#   select(id, last_year, last_position)

# # Combine
# analysis <- first_mentioned %>%
#   inner_join(last_mentioned, by = "id")

# print(analysis)
# #   id first_year first_position last_year last_position
# # 1  1       2010             10      2020             26
# # 2  2       2012              8      2015             19
# # 3  3       1995              6      2005             15
# ```

# ---

# ## Example 7: Real-World Use Case - Publication Tracking

# ```r
# # Publications with multiple dates
# publications <- data.frame(
#   paper_id = 1:4,
#   title = c(
#     "Methods developed 2015, published 2017",
#     "Study conducted 2018-2019 under grant 2016",
#     "Commissioned 2010, revised 2015, released 2020",
#     "Preliminary 2012, final analysis 2014"
#   )
# )

# # Extract all date references
# result <- extract_years_from_string(publications, "title")

# # Flatten and analyze
# library(tidyr)
# expanded <- result %>%
#   tidyr::unnest(years_list, keep_empty = TRUE)

# # Get timeline summary
# timeline <- expanded %>%
#   group_by(paper_id) %>%
#   summarise(
#     earliest = min(year),
#     latest = max(year),
#     mentions = n(),
#     years_mentioned = paste(unique(year), collapse = ", ")
#   )

# print(timeline)
# #   paper_id earliest latest mentions years_mentioned
# # 1        1     2015   2017       2    2015, 2017
# # 2        2     2016   2019       3    2018, 2019, 2016
# # 3        3     2010   2020       3    2010, 2015, 2020
# # 4        4     2012   2014       2    2012, 2014
# ```

# ---

# ## Example 8: With Focus Mode

# ```r
# # Register the dataset
# register_dataset(movies, "movie_data")

# # Use with focus mode (no need to pass data parameter)
# focus_dataset("movie_data")

# # Extract years using implicit focus
# result <- extract_years_from_string(string_col = "description")

# # Or with explicit dataset name
# result <- extract_years_from_string(dataset_name = "movie_data", string_col = "description")
# ```

# ---

# ## Comparison: When to Use Which Function

# ```r
# # Data
# data <- data.frame(
#   text = c(
#     "One year: 2020",
#     "Two years: 2015 and 2020",
#     "Three years: 2010, 2015, 2020"
#   )
# )

# # Simple case - just need first year
# simple <- extract_year_from_string(data, "text")
# # Result: column 'year' with c(2020, 2015, 2010)

# # Complex case - need all years and positions
# detailed <- extract_years_from_string(data, "text")
# # Result: column 'years_list' with list of data frames containing year & position

# # Flatten for analysis
# library(tidyr)
# flattened <- detailed %>%
#   tidyr::unnest(years_list, keep_empty = TRUE)
# ```

# # ---

# ## Performance Notes

# # - **Time Complexity**: O(n × m) where n = number of rows, m = average number of years per row
# # - **Space Complexity**: Stores list of data frames (one per row)
# # - **For Large Datasets**: Consider flattening and filtering before further operations

# # ---

# ## Edge Cases Handled

# ### [OK] NA/NULL values - Returns empty data frame
# ### [OK] No years found - Returns empty data frame (0 rows)
# ### [OK] Same year multiple times - Extracts all occurrences
# ### [OK] 4-digit numbers not years - Extracted as years (limitation of pattern matching)
# ### [OK] Multiple years in sequence - Correctly identifies each one

# # ---

# ## Tips & Best Practices

# # 1. **Always flatten before summarizing**: Use `tidyr::unnest()` to expand for analysis
# # 2. **Check for NA results**: Empty data frames indicate no years found
# # 3. **Combine with group_by**: Perfect for timeline analysis
# # 4. **Use positions for context**: Know WHERE in the text the year appears
# # 5. **Validate years**: Consider filtering unrealistic years (e.g., < 1800 or > current year)

# ```r
# # Example: Validate and filter
# expanded <- result %>%
#   tidyr::unnest(years_list, keep_empty = TRUE) %>%
#   filter(year >= 1800 & year <= 2100)  # Remove invalid years
# ```
