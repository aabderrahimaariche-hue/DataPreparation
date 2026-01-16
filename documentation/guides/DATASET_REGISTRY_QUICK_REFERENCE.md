# Dataset Registry - Quick Reference Card

## 📋 One-Minute Overview

The Registry lets all functions access datasets without passing `data=` parameter each time.

```r
# Register datasets once
register_dataset(df, "my_data")

# Functions can now access them
list_registered_datasets()
get_dataset_summary("my_data")
get_registered_dataset("my_data")
```

---

## 🎯 Core Commands

### Register a Dataset
```r
# Basic
register_dataset(movies, "movies")

# With description
register_dataset(movies, "movies", description = "TMDB movie data")

# Overwrite existing
register_dataset(movies, "movies", replace = TRUE)
```

### View What's Registered
```r
# Formatted list
list_registered_datasets()

# Get as data frame
df <- list_registered_datasets(verbose = FALSE)
```

### Get Dataset Details
```r
# Quick summary with preview
get_dataset_summary("movies", n_rows = 5)

# Just the data
data <- get_registered_dataset("movies")

# With metadata
info <- get_registered_dataset("movies", return_data = FALSE)
```

### Check & Remove
```r
# Check if exists
is_registered("movies")  # Returns TRUE/FALSE

# Remove one
unregister_dataset("movies")

# Remove multiple
unregister_dataset(c("movies", "temp_data"))

# Clear all
clear_registered_datasets()
```

---

## 📊 Common Workflows

### Workflow 1: Start Fresh Project
```r
library(DataPreparation)

# Clear old stuff
clear_registered_datasets(confirm = FALSE)

# Load and register new data
df1 <- read.csv("data1.csv")
df2 <- read.csv("data2.csv")

register_dataset(df1, "current")
register_dataset(df2, "reference")

# Verify
list_registered_datasets()
```

### Workflow 2: Work with Multiple Datasets
```r
# Register all upfront
register_dataset(df1, "patients", "Patient demographics")
register_dataset(df2, "visits", "Hospital visit records")
register_dataset(df3, "labs", "Lab test results")

# See what's available
list_registered_datasets()

# Get specifics on one
get_dataset_summary("patients", n_rows = 10)

# Use in analyses (functions will be updated to support this)
# analyze("patients")
# compare("patients", "visits")
```

### Workflow 3: Subset & Re-register
```r
# Get data
movies <- get_registered_dataset("movies")

# Process it
high_rated <- subset(movies, rating > 8.0)

# Register the new version
register_dataset(high_rated, "high_rated_movies", 
                 description = "Movies with rating > 8.0", 
                 replace = TRUE)

# Now both are available
list_registered_datasets()
```

### Workflow 4: Save Before Clearing
```r
# Backup important data
movies_backup <- get_registered_dataset("movies")

# Safe to clear now
clear_registered_datasets()

# Restore if needed later
register_dataset(movies_backup, "movies")
```

---

## 🔍 Inspection Commands Cheat Sheet

| Task | Command |
|------|---------|
| See all datasets | `list_registered_datasets()` |
| Dataset exists? | `is_registered("name")` |
| Get full info | `get_dataset_summary("name")` |
| Get just data | `get_registered_dataset("name")` |
| Get metadata | `get_registered_dataset("name", return_data=FALSE)` |
| Register | `register_dataset(data, "name")` |
| Remove one | `unregister_dataset("name")` |
| Remove all | `clear_registered_datasets()` |

---

## ⚠️ Common Mistakes

| ❌ Wrong | ✅ Right |
|---------|----------|
| `register_dataset(df)` | `register_dataset(df, "my_data")` |
| Register same name twice | Use `replace=TRUE` on second register |
| `get_registered_dataset("name")$data` | `get_registered_dataset("name")` already is the data |
| `clear_registered_datasets(confirm=FALSE)` in interactive mode | `clear_registered_datasets(confirm=TRUE)` to be safe |
| Case mismatch: register "Movies" but use "movies" | Names are case-sensitive! |

---

## 🔑 Key Points to Remember

1. **Register Once, Use Everywhere**: Set up datasets at script start
2. **Names Matter**: Use clear, descriptive dataset names
3. **Case Sensitive**: "movies" ≠ "Movies"
4. **In Memory Only**: Registry clears when R session ends
5. **Metadata Tracked**: Know when, what size, what columns
6. **Safe Operations**: Can't accidentally overwrite without replace=TRUE
7. **Always Reversible**: Can unregister or clear anytime

---

## 📞 Quick Troubleshooting

**Error: "Dataset 'X' not found"**
```r
# List what exists
list_registered_datasets()

# Maybe typo or case issue
register_dataset(df, "correct_name")
```

**Error: "Dataset 'X' already exists"**
```r
# Option 1: Use replace
register_dataset(new_df, "name", replace=TRUE)

# Option 2: Unregister first
unregister_dataset("name")
register_dataset(new_df, "name")

# Option 3: Use different name
register_dataset(new_df, "name_v2")
```

**Can't find registered dataset**
```r
# Verify it's there
list_registered_datasets()

# Check registry directly
ls(envir = .DataPreparation_Registry)
```

**Want to see what's in a dataset without loading?**
```r
# Use summary
get_dataset_summary("name", n_rows = 10)

# Or get metadata
meta <- get_registered_dataset("name", return_data=FALSE)
meta$rows  # Number of rows
meta$cols  # Number of columns
```

---

## 📈 Next Phase (Upcoming)

Functions will be updated to accept dataset names directly:

```r
# Current way (still works)
inspect_dataset(data = my_data)

# New way (coming)
inspect_dataset("my_data")

# Even more convenient
inspect_registered("my_data")
```

Until then, use `get_registered_dataset()` to retrieve and pass:

```r
my_data <- get_registered_dataset("name")
inspect_dataset(data = my_data)
```

---

## 💡 Pro Tips

**Tip 1**: Use Version Numbers for Iterations
```r
register_dataset(raw_data, "cancer_v1")
# ... process ...
register_dataset(cleaned_data, "cancer_v2")
# ... analyze ...
register_dataset(final_data, "cancer_v3")

# Easy to track which version you're using
list_registered_datasets()
```

**Tip 2**: Organize by Data Type
```r
register_dataset(raw_df, "raw_sales_data")
register_dataset(clean_df, "clean_sales_data")
register_dataset(agg_df, "aggregated_sales_data")

# All sales-related but at different processing stages
```

**Tip 3**: Add Descriptive Metadata
```r
register_dataset(df, "cancer", 
  description = "TCGA dataset, n=10000, downloaded 2026-01-16")
```

**Tip 4**: Quick Data Snapshot
```r
# During analysis, quickly check data
get_dataset_summary("current", n_rows = 20)
```

---

## 📚 Documentation Links

- **Full Guide**: See `documentation/guides/DATASET_REGISTRY_GUIDE.md`
- **Implementation**: See `documentation/REGISTRY_IMPLEMENTATION_SUMMARY.md`
- **Examples**: See `EXAMPLE_REGISTRY_WORKFLOW.R`
- **Code**: See `R/00_dataset_registry.R`

---

## ✨ Summary

**The registry makes your code cleaner:**

```r
# Before: Lots of data parameter passing
result1 <- func1(data = df, param = x)
result2 <- func2(data = df, param = y)
result3 <- func3(data = df, param = z)

# After: Register once, code is cleaner
register_dataset(df, "mydata")
result1 <- func1("mydata", param = x)
result2 <- func2("mydata", param = y)
result3 <- func3("mydata", param = z)
```

**All functions benefit from shared state without refactoring!**
