# Focus Mode - Advanced Dataset Management

## Overview

**Focus Mode** allows you to set a "current" dataset that all subsequent functions will use by default. This eliminates the need to pass the `data` parameter to every function call.

### The Concept

Think of it like "changing focus" in a camera:
- You set focus on a dataset
- All functions target that dataset automatically
- You can change focus to a different dataset anytime
- When done, disable focus mode to return to normal

---

## Core Functions (4 New Functions)

### 1. `focus_dataset()` - Set Current Dataset

```r
focus_dataset(dataset_name, verbose = TRUE)
```

**What it does**: Sets the "current" dataset that functions will use by default.

**Parameters:**
- `dataset_name`: Name of registered dataset to focus on
- `verbose`: Show confirmation message (default: TRUE)

**Example:**
```r
register_dataset(movies, "movies")
focus_dataset("movies")

# Now functions use 'movies' by default
```

---

### 2. `stop_focus()` - Disable Focus Mode

```r
stop_focus(verbose = TRUE)
```

**What it does**: Disables focus mode and returns to normal operation.

**Parameters:**
- `verbose`: Show confirmation message (default: TRUE)

**Example:**
```r
focus_dataset("movies")
# ... do work ...
stop_focus()  # Back to normal mode
```

---

### 3. `get_current_focus()` - Check What's Focused

```r
get_current_focus()
```

**What it does**: Returns the name of currently focused dataset (or NULL if none).

**Returns:** Character string (dataset name) or NULL

**Example:**
```r
get_current_focus()  # NULL if no focus

focus_dataset("movies")
get_current_focus()  # "movies"

stop_focus()
get_current_focus()  # NULL
```

---

### 4. `show_focus_status()` - Display Current State

```r
show_focus_status()
```

**What it does**: Shows detailed focus mode status with helpful information.

**Example:**
```r
show_focus_status()
# Output:
# ======================================================================
# | FOCUS MODE STATUS
# ======================================================================
#
# Status: ACTIVE
#
# Focused Dataset: movies
#   Rows: 1000 | Columns: 5
#
# Behavior:
#   - Functions default to this dataset
#   - Can override with explicit parameters
#   - Functions don't require 'data =' parameter
```

---

## How It Works

### Smart Data Resolution

Functions using focus mode follow this logic:

```
Does function have explicit data parameter? 
  ↓ YES → Use that data
  ↓ NO → Is focus mode active?
         ↓ YES → Use focused dataset
         ↓ NO → Error: Data required
```

### Three Operating Modes

#### Mode 1: No Focus (Traditional)
```r
# Focus mode OFF
inspect_dataset(data = movies)  # Must pass data
```

#### Mode 2: Focus ON - Use Default
```r
register_dataset(movies, "movies")
focus_dataset("movies")

# Focus mode ON
inspect_dataset()  # Automatically uses movies
```

#### Mode 3: Focus ON - Override
```r
register_dataset(movies, "movies")
register_dataset(reviews, "reviews")

focus_dataset("movies")

# Use focused dataset
inspect_dataset()  # Uses movies

# Override with explicit parameter
inspect_dataset(data = reviews)  # Uses reviews instead
```

---

## Practical Workflows

### Workflow 1: Single Dataset Analysis

```r
library(DataPreparation)

# Load and register data
movies <- read.csv("movies.csv")
register_dataset(movies, "movies")

# Set focus
focus_dataset("movies")

# Now work without passing data repeatedly
inspect_dataset()
ngrams <- generate_ngrams(string_cols = "title")
effects <- analyze_effects(string_col = "title")
profile <- extract_profile(string_col = "title")

# When done
stop_focus()
```

### Workflow 2: Switch Between Datasets

```r
# Register multiple datasets
register_dataset(movies, "movies")
register_dataset(cancer, "cancer")
register_dataset(reviews, "reviews")

# Start with movies
focus_dataset("movies")
movie_analysis <- analyze_movies()

# Switch to cancer
focus_dataset("cancer")
cancer_analysis <- analyze_cancer()

# Switch to reviews
focus_dataset("reviews")
review_analysis <- analyze_reviews()

# Done
stop_focus()
```

### Workflow 3: Mixed Mode (Some Functions Use Focus, Some Don't)

```r
register_dataset(df1, "data1")
focus_dataset("data1")

# These use focus:
result1 <- func_with_focus()  # Uses data1

# These override focus:
result2 <- func_with_focus(data = df2)  # Uses df2, not data1

# These don't use focus (no data support):
result3 <- utility_function()  # Doesn't care about focus
```

### Workflow 4: Conditional Logic Based on Focus

```r
register_dataset(df1, "data1")
register_dataset(df2, "data2")

# Check what's focused
current <- get_current_focus()

if (!is.null(current)) {
  cat("Working with:", current, "\n")
} else {
  cat("No focus set. Must pass data explicitly.\n")
}

# Set focus and verify
focus_dataset("data1")
show_focus_status()
```

---

## Error Handling

### Error: Dataset Not Found
```r
focus_dataset("nonexistent")
# Error: Dataset 'nonexistent' not found in registry
```

**Solution**: Register it first
```r
register_dataset(my_data, "mydata")
focus_dataset("mydata")
```

### Error: Wrong Parameter Type
```r
focus_dataset(123)
# Error: dataset_name must be a single character string
```

**Solution**: Use correct format
```r
focus_dataset("my_dataset")  # Must be string
```

### Error: Function Needs Data But No Focus Set
```r
# When focus mode is implemented in functions:
inspect_dataset()  # Error: No data provided and focus not set
```

**Solution**: Either focus on a dataset or pass data
```r
focus_dataset("movies")
inspect_dataset()  # Now works

# OR
inspect_dataset(data = movies)  # Works without focus
```

---

## Best Practices

### ✅ DO

1. **Register before focusing:**
   ```r
   register_dataset(df, "name")
   focus_dataset("name")
   ```

2. **Check focus status when needed:**
   ```r
   show_focus_status()
   ```

3. **Clear focus when switching projects:**
   ```r
   stop_focus()
   # Start new project
   ```

4. **Use descriptive dataset names:**
   ```r
   focus_dataset("cancer_patients")  # ✓ Clear
   focus_dataset("x")               # ✗ Vague
   ```

5. **Verify what's focused:**
   ```r
   if (is.null(get_current_focus())) {
     stop("Must set focus first")
   }
   ```

### ❌ DON'T

1. **Don't focus without registering:**
   ```r
   focus_dataset("data")  # ✗ Will error if not registered
   ```

2. **Don't forget focus is active:**
   ```r
   focus_dataset("movies")
   # ... later in code ...
   result <- inspect_dataset(data = df)  # Might be confusing
   ```

3. **Don't leave focus on when done:**
   ```r
   focus_dataset("data")
   # ... long analysis ...
   # stop_focus() missing - focus still on!
   ```

4. **Don't mix focused and non-focused in same analysis without tracking:**
   ```r
   focus_dataset("movies")
   result1 <- analyze()         # Uses movies
   result2 <- analyze(data = df)  # Uses df
   # Confusing which uses what!
   ```

---

## Focus Mode in Workflows

### Starting a New Analysis

```r
# Clean up from previous project
stop_focus()
clear_registered_datasets()

# Load new data
raw <- read.csv("new_data.csv")
register_dataset(raw, "raw_data")
focus_dataset("raw_data")

# Verify
show_focus_status()

# Start analysis
head_info <- inspect_dataset()
# ... rest of analysis ...
```

### Managing Multiple Datasets

```r
# Register all datasets
patients <- read.csv("patients.csv")
visits <- read.csv("visits.csv")
results <- read.csv("labs.csv")

register_dataset(patients, "patients")
register_dataset(visits, "visits")
register_dataset(results, "labs")

# List all
list_registered_datasets()

# Work with each
focus_dataset("patients")
patient_summary <- analyze_patients()

focus_dataset("visits")
visit_summary <- analyze_visits()

focus_dataset("labs")
lab_summary <- analyze_labs()

# Done
stop_focus()
```

### Combining Focus with Manual Data Passing

```r
register_dataset(df1, "primary")
register_dataset(df2, "secondary")

# Analyze primary
focus_dataset("primary")
result1 <- analyze()

# Use secondary explicitly without changing focus
result2 <- compare_datasets(
  data1 = get_registered_dataset("primary"),
  data2 = get_registered_dataset("secondary")
)

# Still focused on primary
get_current_focus()  # "primary"

# When done
stop_focus()
```

---

## Technical Details

### Where Focus is Stored

Focus information is stored in the registry:
```r
.DataPreparation_Registry$.DataPreparation_Focus = "dataset_name"
```

- Stored in same registry as datasets
- Cleared when `stop_focus()` is called
- Survives across multiple function calls
- Lost when R session ends (session-only)

### Resolution Function (for developers)

Developers can use `resolve_data_source()` to smartly handle data:

```r
my_function <- function(data = NULL, param1) {
  # Smart resolution: explicit data > focus > error
  data <- resolve_data_source(data)
  
  if (is.null(data)) {
    stop("Provide 'data' parameter or set focus_dataset()")
  }
  
  # ... rest of function ...
}
```

---

## Focus Mode Timeline

### Phase 1.5 ✅ (NOW)
- ✅ Focus mode functions implemented
- ✅ Smart resolution function available
- ✅ Documentation complete

### Phase 2 (Coming)
- [ ] Update existing functions to support focus mode
- [ ] Each function can use `resolve_data_source()`
- [ ] Backward compatible with existing code

### Phase 3+ (Future)
- [ ] Default focus selection
- [ ] Focus stacking (remember previous focuses)
- [ ] Pipeline chaining with focus

---

## Summary Table

| Task | Function | Example |
|------|----------|---------|
| Set focus | `focus_dataset()` | `focus_dataset("movies")` |
| Stop focus | `stop_focus()` | `stop_focus()` |
| Check current | `get_current_focus()` | `get_current_focus()` |
| See status | `show_focus_status()` | `show_focus_status()` |
| Smart resolve | `resolve_data_source()` | (for developers) |

---

## Integration with Existing Code

### Current (Before Phase 2)
```r
# Must pass data explicitly
inspect_dataset(data = movies)

# Or use registry
register_dataset(movies, "movies")
inspect_dataset(data = get_registered_dataset("movies"))
```

### Phase 2 (With Focus)
```r
# Set focus once
register_dataset(movies, "movies")
focus_dataset("movies")

# Functions updated to support focus
inspect_dataset()  # Automatic!
```

### Both Methods Always Work
```r
# Even in Phase 2, can still pass data explicitly
inspect_dataset(data = my_data)  # Override focus
```

---

## FAQ

**Q: Does focus mode break existing code?**  
A: No! All existing code continues to work. Focus mode is opt-in.

**Q: Can I change focus mid-analysis?**  
A: Yes! Just call `focus_dataset("new_dataset")` anytime.

**Q: What if I forget to stop focus?**  
A: Focus persists until `stop_focus()` is called (end of session at worst).

**Q: Can I focus on non-existent dataset?**  
A: No - function checks and errors if dataset not registered.

**Q: What happens if I delete focused dataset?**  
A: Focus becomes invalid; functions will error. Call `stop_focus()` or focus on another dataset.

**Q: Is focus per-script or global?**  
A: Global within the R session. All functions see the same focus.

**Q: Can multiple focuses be active?**  
A: No - only one dataset can be focused at a time. But you can switch quickly.

**Q: Does focus affect saved data?**  
A: No - focus is session-only. It doesn't affect files or exports.

---

## Migration Guide (From Regular to Focus Mode)

### Before (Traditional)
```r
movies <- read.csv("movies.csv")

inspect_dataset(data = movies, verbose = TRUE)
ngrams <- generate_ngrams(data = movies, string_cols = "title")
profile <- extract_profile(data = movies, string_col = "title")
effects <- analyze_effects(data = movies, string_col = "title")
```

### After (Focus Mode)
```r
movies <- read.csv("movies.csv")
register_dataset(movies, "movies")
focus_dataset("movies")

inspect_dataset(verbose = TRUE)
ngrams <- generate_ngrams(string_cols = "title")
profile <- extract_profile(string_col = "title")
effects <- analyze_effects(string_col = "title")
```

**Benefits:**
- Fewer parameters to type
- Clearer intent
- Less error-prone
- Professional appearance

---

## Advanced: Combining Registry + Focus

```r
# Setup: Registry + Focus Mode
register_dataset(df1, "primary", "Primary analysis data")
register_dataset(df2, "secondary", "Comparison data")
register_dataset(df3, "reference", "Reference baseline")

# See all available
list_registered_datasets()

# Work primarily with primary
focus_dataset("primary")
show_focus_status()

# All analysis uses primary:
result1 <- analyze()
result2 <- summarize()

# Temporarily use secondary for comparison
comparison <- compare_to(data = get_registered_dataset("secondary"))

# Still focused on primary
get_current_focus()  # "primary"

# When done
stop_focus()
```

---

**Status**: ✅ Phase 1.5 Complete  
**Ready to Use**: YES  
**Backward Compatible**: YES  
**Requires Phase 2**: No (functions will be updated in Phase 2)
