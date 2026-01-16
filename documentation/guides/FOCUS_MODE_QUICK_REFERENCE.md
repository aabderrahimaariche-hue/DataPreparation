# Focus Mode - Quick Reference

## What is Focus Mode?

Set a "current" dataset once, and all functions use it automatically.

```r
focus_dataset("movies")  # Set focus
# All functions now use movies by default
# Stop focus: stop_focus()
```

---

## Four Core Commands

```r
# 1. Set focus on a dataset
focus_dataset("dataset_name")

# 2. Check what's focused
get_current_focus()  # Returns name or NULL

# 3. See detailed status
show_focus_status()

# 4. Disable focus mode
stop_focus()
```

---

## Typical Workflow

### Setup
```r
library(DataPreparation)

# Create/Load data
movies <- data.frame(...)

# Register it
register_dataset(movies, "movies")

# Set focus
focus_dataset("movies")
```

### Work (Functions use movies automatically)
```r
inspect_dataset()              # Uses movies
ngrams <- generate_ngrams(string_cols = "title")  # Uses movies
effects <- analyze_effects(string_col = "title")  # Uses movies
```

### Cleanup
```r
stop_focus()  # Disable focus mode
```

---

## Three Scenarios

### Scenario 1: No Focus (Traditional)
```r
# Must pass data every time
inspect_dataset(data = movies)
generate_ngrams(data = movies, string_cols = "title")
```

### Scenario 2: Focus Mode (Automatic)
```r
focus_dataset("movies")

# No data parameter needed
inspect_dataset()
generate_ngrams(string_cols = "title")
```

### Scenario 3: Focus Mode + Override
```r
focus_dataset("movies")

# Use default (movies)
inspect_dataset()

# Override with different data
inspect_dataset(data = reviews)  # Uses reviews, not movies
```

---

## Common Commands

### Start Working
```r
register_dataset(df, "mydata")
focus_dataset("mydata")
```

### Switch to Different Dataset
```r
focus_dataset("other_dataset")  # Switches focus
```

### Check Current Focus
```r
get_current_focus()  # Returns "mydata" or NULL
```

### See Full Status
```r
show_focus_status()
# Shows: Active/Inactive, focused dataset, rows, columns, etc
```

### Stop Focus Mode
```r
stop_focus()  # Back to normal - must pass data
```

### Combined Workflow
```r
register_dataset(df1, "data1")
register_dataset(df2, "data2")

focus_dataset("data1")
result1 <- analyze()

focus_dataset("data2")
result2 <- analyze()

stop_focus()
```

---

## Error Messages & Solutions

| Error | Solution |
|-------|----------|
| "Dataset not found" | `register_dataset(df, "name")` first |
| No data provided | `focus_dataset("name")` or `pass data parameter` |
| Focus not cleared | `stop_focus()` when done |

---

## When to Use Focus Mode

### ✅ Use Focus When:
- Working primarily with one dataset
- Long analysis with many function calls
- Want cleaner code
- Multiple steps on same dataset

### ❌ Skip Focus When:
- Quick one-off analysis
- Comparing multiple datasets (use explicit parameters)
- Need full clarity on which data is used

---

## Important Notes

- **One focus at a time** - only one dataset can be focused
- **Easy to switch** - call `focus_dataset("other")` anytime
- **Override anytime** - pass `data =` parameter to override focus
- **Session-only** - focus is lost when R exits
- **Backward compatible** - existing code still works

---

## Example: Full Analysis

```r
library(DataPreparation)

# 1. Setup
movies <- data.frame(
  title = c("Matrix", "Inception", "Interstellar"),
  rating = c(8.7, 8.8, 8.6)
)

# 2. Register and focus
register_dataset(movies, "movies")
focus_dataset("movies")

# 3. Verify focus
show_focus_status()

# 4. Work (all use movies automatically)
cat("\n=== Analysis ===\n")
summary <- inspect_dataset()
# ... more analysis ...

# 5. Done
stop_focus()
```

---

## Quick Comparison

| Aspect | Without Focus | With Focus |
|--------|---------------|-----------|
| Setup | Load data | Register + Focus |
| Each function | Pass `data=` | No parameter needed |
| Code length | Longer | Shorter |
| Clarity | Explicit | Cleaner |
| Flexibility | Can pass any data | Easy override |

---

## Pro Tips

1. **Name datasets clearly**:
   ```r
   register_dataset(df, "cancer_patients")  # Good
   register_dataset(df, "x")                # Vague
   ```

2. **Always disable when done**:
   ```r
   focus_dataset("data")
   # ... analysis ...
   stop_focus()  # Don't forget!
   ```

3. **Verify focus status often**:
   ```r
   show_focus_status()  # Check where you are
   ```

4. **Use get_current_focus() for logic**:
   ```r
   if (is.null(get_current_focus())) {
     focus_dataset("data")
   }
   ```

5. **Combine with registry info**:
   ```r
   list_registered_datasets()  # See all
   get_current_focus()         # See current
   ```

---

## Migration from Traditional to Focus

### Before:
```r
df <- data.frame(...)
result1 <- func1(data = df)
result2 <- func2(data = df)
result3 <- func3(data = df)
```

### After:
```r
df <- data.frame(...)
register_dataset(df, "mydata")
focus_dataset("mydata")
result1 <- func1()
result2 <- func2()
result3 <- func3()
stop_focus()
```

---

## Status

✅ **Available Now** - Use immediately  
⏳ **Phase 2** - Functions will integrate with focus  
🔮 **Phase 3** - Advanced features (stacking, pipelines)

---

**Keep this handy!** 📋
