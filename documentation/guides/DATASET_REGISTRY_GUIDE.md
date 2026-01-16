# Dataset Registry System - Complete Guide

## Overview

The **Dataset Registry** is a shared storage system that allows all functions in the DataPreparation package to access datasets without requiring you to pass the `data` parameter every time.

### Problem It Solves

**Without Registry (Old Way):**
```r
movies <- data.frame(...)
cancer <- data.frame(...)

# Must pass data to every function
inspect_dataset(movies, ...)
ngrams <- generate_ngram_char_variants(data = movies, ...)
effects <- compute_global_linguistic_effects(data = movies, ...)
profile <- extract_string_linguistic_profile(data = movies, ...)
```

**With Registry (New Way):**
```r
movies <- data.frame(...)
cancer <- data.frame(...)

# Register once
register_dataset(movies, "movies")
register_dataset(cancer, "cancer")

# Functions know about registered datasets automatically
inspect_registered_dataset("movies")
ngrams <- generate_ngrams_from_registry("movies", ...)
effects <- analyze_effects_from_registry("movies", ...)
```

## Core Functions

### 1. `register_dataset()` - Add Dataset to Registry

Register a dataset so all functions can access it.

```r
# Basic usage
register_dataset(data, name = "my_dataset")

# With description and replace options
register_dataset(
  data = movies,
  name = "movies",
  description = "Movie database with ratings",
  replace = FALSE,
  verbose = TRUE
)
```

**Parameters:**
- `data`: Data frame or data.table to register
- `name`: Name for the dataset (optional - auto-detects variable name)
- `description`: Optional description of the data
- `replace`: If TRUE, overwrites existing dataset with same name
- `verbose`: Print confirmation message

### 2. `list_registered_datasets()` - See All Registered Data

View all datasets currently in the registry.

```r
# Show formatted summary
list_registered_datasets(verbose = TRUE)

# Get as data frame
datasets_df <- list_registered_datasets(verbose = FALSE)
```

**Output Example:**
```
========================================================
| REGISTERED DATASETS
========================================================

  Dataset  Rows Columns Registered          
1  cancer   100       4 2026-01-16 14:32:15
2  movies     5       5 2026-01-16 14:30:22
```

### 3. `get_registered_dataset()` - Retrieve Dataset

Get a registered dataset.

```r
# Get the actual data
movies_data <- get_registered_dataset("movies", return_data = TRUE)

# Get metadata about the dataset
movies_metadata <- get_registered_dataset("movies", return_data = FALSE)
```

### 4. `get_dataset_summary()` - Quick Overview

Display structure, columns, and preview of registered data.

```r
get_dataset_summary("movies", n_rows = 5)
```

**Output:**
```
============================================================
| DATASET SUMMARY: movies
============================================================

Dimensions:  5 rows × 5 columns

Registered:  2026-01-16 14:30:22 
Description:  Movie database with ratings

Columns:
  Index     Column       Type Non_NA
1     1    movieId    integer      5
2     2      title character      5
3     3       year character      5
4     4     rating    numeric      5
5     5    revenue    numeric      5

Preview (first 5 rows):
  movieId       title year rating     revenue
1       1  The Matrix 1999    8.7  467222728
2       2   Inception 2010    8.8  839671789
3       3 Interstellar 2014    8.6  701730249
4       4      Avatar 2009    7.8 2923706026
5       5 Inception 2 2024    8.5 1150000000
```

### 5. `is_registered()` - Check if Dataset Exists

Test whether a dataset is in the registry.

```r
if (is_registered("movies")) {
  cat("Movies dataset is ready!\n")
} else {
  cat("Please register movies dataset first\n")
}
```

### 6. `unregister_dataset()` - Remove Dataset

Remove one or more datasets from the registry.

```r
# Remove single dataset
unregister_dataset("temp_data")

# Remove multiple
unregister_dataset(c("dataset1", "dataset2"))
```

### 7. `clear_registered_datasets()` - Clear All

Remove all datasets from the registry.

```r
# Clear with confirmation prompt
clear_registered_datasets(confirm = TRUE)

# Clear without asking
clear_registered_datasets(confirm = FALSE)
```

## Complete Workflow Example

```r
library(DataPreparation)

# ============================================================================
# STEP 1: Create your datasets
# ============================================================================

movies <- data.frame(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "Avatar", "Inception 2"),
  year = c("1999", "2010", "2014", "2009", "2024"),
  rating = c(8.7, 8.8, 8.6, 7.8, 8.5)
)

reviews <- data.frame(
  reviewId = 1:100,
  movieId = sample(1:5, 100, replace = TRUE),
  sentiment = sample(c("positive", "negative", "neutral"), 100, replace = TRUE)
)

# ============================================================================
# STEP 2: Register all datasets at startup
# ============================================================================

register_dataset(movies, "movies", "Movie information with ratings")
register_dataset(reviews, "reviews", "Customer reviews and sentiments")

# ============================================================================
# STEP 3: Verify what's registered
# ============================================================================

list_registered_datasets()
get_dataset_summary("movies", n_rows = 3)

# ============================================================================
# STEP 4: Use functions with registered data
# ============================================================================

# Functions will automatically find and use registered data
# instead of requiring you to pass the data parameter

# Example: Analyze movies dataset
movie_analysis <- process_movies_from_registry("movies")

# Example: Compare across datasets
comparison <- compare_datasets(
  dataset1 = "movies",
  dataset2 = "reviews"
)

# ============================================================================
# STEP 5: Cleanup when done
# ============================================================================

# Remove specific dataset
unregister_dataset("reviews")

# Or clear everything
clear_registered_datasets(confirm = TRUE)
```

## Best Practices

### ✅ DO:

1. **Register datasets at the start of your script:**
   ```r
   register_dataset(df, "my_data")
   ```

2. **Use meaningful names:**
   ```r
   register_dataset(patient_data, "cancer_patients")  # ✓ Good
   register_dataset(x, "x")                            # ✗ Not helpful
   ```

3. **Add descriptions:**
   ```r
   register_dataset(df, "movies", description = "TMDB movie dataset")
   ```

4. **Check what's registered:**
   ```r
   list_registered_datasets()  # Before processing
   ```

5. **Use in conditional logic:**
   ```r
   if (is_registered("movies")) {
     analyze_movies()
   }
   ```

### ❌ DON'T:

1. **Don't create datasets without registering:**
   ```r
   temp <- subset(movies, rating > 8)  # ✗ Won't be accessible
   register_dataset(temp, "high_rated")  # ✓ Do this instead
   ```

2. **Don't register same data multiple times:**
   ```r
   register_dataset(df, "data")
   register_dataset(df, "data")  # ✗ Will error
   register_dataset(df, "data", replace = TRUE)  # ✓ Use replace if needed
   ```

3. **Don't forget to clear when switching analyses:**
   ```r
   clear_registered_datasets()  # Clear old data before new project
   register_dataset(new_data, "current")
   ```

## How Functions Will Use the Registry

Once functions are updated to support the registry, they'll accept either:

**Option 1: Traditional way (still works)**
```r
inspect_dataset(movies, verbose = TRUE)
```

**Option 2: Registry way (new, preferred)**
```r
inspect_dataset("movies", verbose = TRUE)
# or
inspect_from_registry("movies", verbose = TRUE)
```

Functions will detect whether you're passing:
- An actual data frame → use it directly
- A string (name) → look it up in the registry
- Nothing → use the default/first registered dataset

## Storage Details

The registry is stored in:
```r
.DataPreparation_Registry  # Hidden environment in .GlobalEnv
```

Each registered dataset stores:
- `data`: The actual data frame/data.table
- `rows`: Number of rows
- `cols`: Number of columns
- `column_names`: Column names
- `column_types`: Data type of each column
- `registered_at`: Timestamp when registered
- `description`: Optional description

## Accessing the Raw Registry

If you need direct access to the registry (advanced):

```r
# List all objects in registry
ls(envir = .DataPreparation_Registry)

# Get a dataset directly
movies <- get("movies", envir = .DataPreparation_Registry)$data

# Add manually (not recommended - use register_dataset)
assign("custom", list(data = df, ...), envir = .DataPreparation_Registry)
```

## Troubleshooting

### Error: "Dataset 'X' not found in registry"
```r
# Solution: Register it first
register_dataset(your_data, "your_name")
```

### Error: "Dataset 'X' already exists"
```r
# Solution: Use replace=TRUE
register_dataset(new_data, "name", replace = TRUE)
```

### Can't find a dataset I registered
```r
# Solution: List all to check names
list_registered_datasets()

# Note: Names are case-sensitive!
register_dataset(df, "Movies")   # Different from "movies"
```

### Want to backup a dataset before clearing
```r
# Save to variable before clearing
backup <- get_registered_dataset("movies")

# Then clear safely
clear_registered_datasets()

# Restore if needed
register_dataset(backup, "movies")
```

## Integration Roadmap

The registry system is designed to be integrated into functions progressively:

### Phase 1 ✅ (Done)
- Registry system created
- Core management functions

### Phase 2 (Upcoming)
- Update core functions to accept dataset names:
  - `inspect_dataset("name")` instead of `inspect_dataset(data)`
  - `generate_ngrams_from_registry("name")` convenience functions
  
### Phase 3 (Future)
- Default dataset selection: `use_dataset("movies")` sets default
- Pipeline chaining: `"movies" %>% filter_registered() %>% analyze_registered()`
- Batch operations: Process all registered datasets at once

## Questions?

- **How do I know which functions support the registry?**
  Check the function documentation - updated functions will mention it.

- **Can I use both methods (passing data and registry)?**
  Yes! Functions will support both for backwards compatibility.

- **Is the registry cleared when I exit R?**
  Yes - it's only in memory. Save important processed data to files if needed.

- **Can I have datasets with the same name in different environments?**
  The registry only uses `.GlobalEnv` by design for simplicity.
