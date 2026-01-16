# Dataset Registry Implementation Summary

## What Was Created

### 1. **Dataset Registry System** (`R/00_dataset_registry.R`)

A comprehensive shared dataset management system that allows all functions in the DataPreparation package to access datasets without passing `data` parameter repeatedly.

#### Key Features:
- ✅ **Central Registry**: One shared location for all datasets
- ✅ **Easy Registration**: `register_dataset(data, "name")`
- ✅ **Visibility**: `list_registered_datasets()` shows what's loaded
- ✅ **Metadata Tracking**: Stores size, columns, registration time, description
- ✅ **Safe Operations**: Check, retrieve, remove, and clear datasets
- ✅ **Automatic Detection**: Get variable name automatically if not provided

#### 7 Core Functions:

| Function | Purpose |
|----------|---------|
| `register_dataset()` | Add dataset to shared registry |
| `list_registered_datasets()` | View all registered datasets |
| `get_registered_dataset()` | Retrieve dataset by name |
| `get_dataset_summary()` | Quick overview with preview |
| `is_registered()` | Check if dataset exists |
| `unregister_dataset()` | Remove specific dataset(s) |
| `clear_registered_datasets()` | Remove all datasets |

### 2. **Example Workflow** (`EXAMPLE_REGISTRY_WORKFLOW.R`)

Demonstrates how to use the new registry system in a real workflow, showing:
- How to register multiple datasets
- How to verify registration
- How to retrieve dataset information
- Best practices for dataset management

### 3. **Complete Guide** (`documentation/guides/DATASET_REGISTRY_GUIDE.md`)

Comprehensive documentation including:
- Problem statement (why this is needed)
- Function reference for each method
- Complete workflow example
- Best practices (DO's and DON'Ts)
- Troubleshooting guide
- Integration roadmap

## How It Works

### Architecture

```
Your R Script
    ↓
register_dataset(movies, "movies")
    ↓
.DataPreparation_Registry (Shared Environment)
    ├── movies: {data, rows, cols, columns, types, registered_at, description}
    ├── cancer: {data, rows, cols, columns, types, registered_at, description}
    └── reviews: {data, rows, cols, columns, types, registered_at, description}
    ↓
Any Function Can Access: get_registered_dataset("movies")
```

### Before vs After

**BEFORE (Old Way):**
```r
movies <- data.frame(...)
cancer <- data.frame(...)

# Had to pass data to EVERY function
inspect_dataset(movies, verbose = TRUE)
ngrams <- generate_ngram_char_variants(data = movies, string_cols = "title")
effects <- compute_global_linguistic_effects(data = movies, string_col = "title")
profile <- extract_string_linguistic_profile(data = movies, string_col = "title")
```

**AFTER (New Way):**
```r
movies <- data.frame(...)
cancer <- data.frame(...)

# Register once, use everywhere
register_dataset(movies, "movies")
register_dataset(cancer, "cancer")

# Functions will be updated to:
inspect_dataset("movies", verbose = TRUE)
ngrams <- generate_ngram_char_variants("movies", string_cols = "title")
effects <- compute_global_linguistic_effects("movies", string_col = "title")
profile <- extract_string_linguistic_profile("movies", string_col = "title")

# Or check what's available
list_registered_datasets()
get_dataset_summary("cancer")
```

## Implementation Details

### Storage

- **Location**: `.DataPreparation_Registry` (hidden environment in `.GlobalEnv`)
- **Metadata per dataset**:
  - `data`: The actual data frame/data.table
  - `rows`: Number of rows
  - `cols`: Number of columns
  - `column_names`: Column names
  - `column_types`: Data type of each column
  - `registered_at`: Timestamp of registration
  - `description`: Optional user-provided description

### Safety Features

- ✅ **Duplicate Prevention**: Can't register same name twice unless `replace=TRUE`
- ✅ **Validation**: Checks that input is a data frame
- ✅ **Error Handling**: Clear messages if dataset not found
- ✅ **Confirmation Prompts**: Asks before clearing all data
- ✅ **Metadata Tracking**: Knows when data was registered

## Integration Path

### Phase 1 ✅ (COMPLETE)
- Registry system created
- Core management functions (7 functions)
- Documentation and examples

### Phase 2 (NEXT)
Update core functions to accept dataset names:

```r
# Currently (still works):
inspect_dataset(data = movies)

# Will add support for:
inspect_dataset("movies")  # String is recognized as dataset name
```

Functions to update:
- `inspect_dataset()`
- `generate_ngram_char_variants()`
- `compute_global_linguistic_effects()`
- `extract_string_linguistic_profile()`
- `generate_workflow_script()`
- And others...

### Phase 3 (FUTURE)
- Default dataset selection: `use_dataset("movies")`
- Pipeline chaining with registry
- Batch operations on all datasets

## Quick Start

```r
library(DataPreparation)

# 1. Create data
movies <- data.frame(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))

# 2. Register
register_dataset(movies, "movies")

# 3. Verify
list_registered_datasets()
get_dataset_summary("movies")

# 4. Use anywhere
my_data <- get_registered_dataset("movies")

# 5. Cleanup
unregister_dataset("movies")
# or clear_registered_datasets()
```

## Key Benefits

1. **Cleaner Code**: No need to pass `data` parameter to every function
2. **Better Organization**: All datasets visible in one place
3. **Safer Operations**: Metadata tracking prevents accidental overwrites
4. **Easier Debugging**: Know exactly what datasets are in memory
5. **Scalability**: Handle multiple datasets easily
6. **Best Practice**: Aligns with how many R packages handle shared state (e.g., Shiny apps)

## Files Created

```
DataPreparation/
├── R/
│   └── 00_dataset_registry.R          (NEW - 400+ lines)
├── EXAMPLE_REGISTRY_WORKFLOW.R         (NEW - Example usage)
└── documentation/
    └── guides/
        └── DATASET_REGISTRY_GUIDE.md   (NEW - Complete documentation)
```

## Testing the Implementation

Run this to test:

```r
library(DataPreparation)

# Test 1: Register datasets
movies <- data.frame(x = 1:5)
register_dataset(movies, "test_movies")

# Test 2: List datasets
list_registered_datasets()

# Test 3: Get summary
get_dataset_summary("test_movies", n_rows = 3)

# Test 4: Check if registered
is_registered("test_movies")

# Test 5: Retrieve data
retrieved <- get_registered_dataset("test_movies")
all.equal(retrieved, movies)  # Should be TRUE

# Test 6: Clean up
unregister_dataset("test_movies")
list_registered_datasets()
```

## Next Steps

1. **Test the registry** with your existing code
2. **Update functions** to support dataset names (Phase 2)
3. **Train users** on new workflow via documentation
4. **Gather feedback** on what additional features needed

## Questions Answered

**Q: Will this break existing code?**
A: No! All functions still work with `data = your_data`. Registry is optional addition.

**Q: What if I have multiple R environments?**
A: Registry is `.GlobalEnv` only by design. Separate R sessions have separate registries.

**Q: How do I save datasets?**
A: Use `saveRDS()` or `write.csv()` - registry is session memory only.

**Q: Can functions use registry automatically?**
A: Yes! Once Phase 2 updates are applied, functions will detect string input and look up in registry.

**Q: Is this similar to any other R packages?**
A: Similar pattern to: Shiny's `reactiveValues()`, environment-based options in R, and package-level state management.
