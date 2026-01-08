# Integrating data.table Support into DataPreparation

## Overview

Your DataPreparation package currently uses `dplyr` and base R for data frame operations. To support `data.table`, you have several integration strategies. Here's a comprehensive guide.

---

## 📋 Current Architecture

**Current Dependencies**:
```
dplyr → data frame operations (filter, mutate, select)
tidyr → reshaping operations
stringr → string operations
```

**Current Limitation**: Functions expect data.frame input; data.table users must convert manually.

---

## 🎯 Integration Strategies

### Strategy 1: Accept data.table as Input (Recommended - Easy)

**Pros**: 
- ✅ Minimal code changes
- ✅ data.table users still get fast performance on processing
- ✅ Backward compatible
- ✅ No new dependencies
- ✅ Works with existing dplyr-based code

**Cons**:
- ❌ Lose data.table's speed for column operations

**Implementation**: Add a single wrapper that converts at function entry.

---

### Strategy 2: Dual Implementation (Advanced - Complex)

**Pros**:
- ✅ Full data.table performance
- ✅ Optimal speed for both formats
- ✅ No conversion overhead

**Cons**:
- ❌ Double the code to maintain
- ❌ More complex testing
- ❌ Larger package size

**Implementation**: Create separate data.table versions of each function.

---

### Strategy 3: Hybrid Approach (Balanced - Recommended)

**Pros**:
- ✅ Accept both formats
- ✅ Preserve format for user output
- ✅ Minimal code changes
- ✅ Good performance balance
- ✅ User-friendly

**Cons**:
- ⚠️ Slightly more logic per function

**Implementation**: Auto-detect input type, use appropriate backend.

---

## 🛠️ RECOMMENDED SOLUTION: Hybrid Approach

Here's how to implement it:

### Step 1: Update DESCRIPTION

Add data.table to Suggests (optional dependency):

```r
Suggests:
    testthat (>= 3.0.0),
    data.table
```

Or to Imports if you want to require it:

```r
Imports:
    dplyr,
    tidyr,
    stringr,
    purrr,
    zoo,
    rlang,
    tibble,
    data.table
```

### Step 2: Create Helper Functions

Add this to a new file `R/00_data_utilities.R`:

```r
#' Check if Input is data.table
#' @param data Input object
#' @return Logical: TRUE if data.table, FALSE otherwise
#' @keywords internal
is_datatable <- function(data) {
  inherits(data, "data.table")
}

#' Convert data.table to data.frame if needed
#' @param data Input data
#' @return data.frame (if input is data.table) or original data
#' @keywords internal
ensure_dataframe <- function(data) {
  if (is_datatable(data)) {
    return(as.data.frame(data))
  }
  return(data)
}

#' Restore original class if needed
#' @param result Result data frame
#' @param original Original input data
#' @return Result with original class if input was data.table
#' @keywords internal
restore_class <- function(result, original) {
  if (is_datatable(original)) {
    return(as.data.table(result))
  }
  return(result)
}

#' Process with appropriate backend
#' @param data Input data (data.frame or data.table)
#' @param fn_dplyr Function using dplyr syntax
#' @return Result in original format
#' @keywords internal
process_with_format <- function(data, fn_dplyr) {
  original_class <- class(data)
  df <- ensure_dataframe(data)
  result <- fn_dplyr(df)
  restore_class(result, data)
}
```

### Step 3: Update Existing Functions

**Current function** (uses dplyr):
```r
scale_betweenRange <- function(data, col, min_val = NULL, max_val = NULL) {
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  if(is.null(min_val)) min_val <- min(data[[col]], na.rm = TRUE)
  if(is.null(max_val)) max_val <- max(data[[col]], na.rm = TRUE)
  data %>% mutate(!!sym(col) := (.data[[col]] - min_val) / (max_val - min_val))
}
```

**Updated function** (supports both):
```r
scale_betweenRange <- function(data, col, min_val = NULL, max_val = NULL) {
  # Detect input type and convert if needed
  is_dt <- is_datatable(data)
  if (is_dt) data <- as.data.frame(data)
  
  # Validation (works same for both)
  if(!(col %in% colnames(data))) stop(paste("Column not found:", col))
  if(is.null(min_val)) min_val <- min(data[[col]], na.rm = TRUE)
  if(is.null(max_val)) max_val <- max(data[[col]], na.rm = TRUE)
  
  # Process (using dplyr)
  result <- data %>% 
    mutate(!!sym(col) := (.data[[col]] - min_val) / (max_val - min_val))
  
  # Restore original format
  if (is_dt) result <- as.data.table(result)
  
  return(result)
}
```

### Step 4: Create Convenience Function

Add to user documentation:

```r
#' Convert between data.frame and data.table
#'
#' @param data Input data
#' @param format "data.frame" or "data.table"
#'
#' @return Converted data
#'
#' @export
#'
#' @examples
#' library(DataPreparation)
#' movies <- data.frame(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))
#' movies_dt <- convert_data_format(movies, "data.table")
#' movies_df <- convert_data_format(movies_dt, "data.frame")
#'
convert_data_format <- function(data, format = c("data.frame", "data.table")) {
  format <- match.arg(format)
  
  if (format == "data.table") {
    return(as.data.table(data))
  } else {
    return(as.data.frame(data))
  }
}
```

---

## 📝 Implementation Plan

### Phase 1: Add Support (Easy - 1-2 hours)

1. ✅ Create `R/00_data_utilities.R` with helper functions
2. ✅ Update DESCRIPTION file
3. ✅ Test with one module (Module 2: Numeric Features)
4. ✅ Update documentation

**Result**: Your package works with both data.frame and data.table!

### Phase 2: Optimize (Optional - Performance)

1. ⏳ Create native data.table implementations for critical functions
2. ⏳ Auto-choose fastest backend based on input
3. ⏳ Benchmark performance

**Result**: Best performance for both formats.

---

## 💻 Code Examples

### For Users

**Before** (without data.table support):
```r
library(DataPreparation)

# data.table users had to convert
movies_dt <- data.table(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))
movies_df <- as.data.frame(movies_dt)  # Convert!

# Use functions
scaled <- scale_betweenRange(movies_df, "rating")

# Convert back
scaled_dt <- as.data.table(scaled)
```

**After** (with data.table support):
```r
library(DataPreparation)

# Works directly with data.table!
movies_dt <- data.table(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))

# Use functions - returns data.table!
scaled <- scale_betweenRange(movies_dt, "rating")
# Result is data.table (format preserved!)

# Or use data.frame - still works!
movies_df <- data.frame(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))
scaled <- scale_betweenRange(movies_df, "rating")
# Result is data.frame
```

### For Developers

```r
# Creating a new function that supports both formats:

my_new_function <- function(data, col) {
  # 1. Detect and convert
  is_dt <- is_datatable(data)
  if (is_dt) data <- as.data.frame(data)
  
  # 2. Validation (unchanged)
  if (!(col %in% colnames(data))) stop("Column not found")
  
  # 3. Processing (your existing dplyr code)
  result <- data %>%
    mutate(new_col = !!sym(col) * 2)
  
  # 4. Restore format
  if (is_dt) result <- as.data.table(result)
  
  return(result)
}
```

---

## 🧪 Testing Strategy

### Test File: `tests/testthat/test_data_table_support.R`

```r
library(testthat)
library(DataPreparation)
library(data.table)

test_that("Functions accept data.table input", {
  # Create test data
  dt <- data.table(
    id = 1:5,
    value = c(1, 2, 3, 4, 5),
    text = c("a", "b", "c", "d", "e")
  )
  
  # Test numeric function
  result <- scale_betweenRange(dt, "value")
  expect_true(is.data.table(result))
  expect_equal(nrow(result), 5)
})

test_that("Functions preserve input format", {
  # Test with data.table
  dt <- data.table(value = 1:5)
  result_dt <- scale_betweenRange(dt, "value")
  expect_true(is.data.table(result_dt))
  
  # Test with data.frame
  df <- data.frame(value = 1:5)
  result_df <- scale_betweenRange(df, "value")
  expect_true(is.data.frame(result_df))
  expect_false(is.data.table(result_df))
})

test_that("Results are equivalent regardless of input format", {
  df <- data.frame(value = 1:5)
  dt <- data.table(value = 1:5)
  
  result_df <- scale_betweenRange(df, "value")
  result_dt <- scale_betweenRange(dt, "value")
  
  # Compare values (ignoring class)
  expect_equal(
    as.data.frame(result_dt)[[1]],
    result_df[[1]]
  )
})
```

---

## 📊 Performance Considerations

### Conversion Overhead

```
data.table → data.frame → operations → data.table
Time: negligible for most operations (~1-5ms)
Memory: same as input (copy made once)
```

### When Performance Matters

- ✅ **Good use case**: Analysis workflow (few conversions)
- ✅ **Good use case**: Mixed format projects (convert once)
- ⚠️ **Poor use case**: Loop of 10,000+ small operations
- ⚠️ **Poor use case**: Real-time processing of massive data

### If Performance is Critical

Consider Phase 2 (native data.table implementations) for:
- `scale_betweenRange()`
- `normalize_numeric()`
- `create_polynomial_features()`
- `generate_ngram_char_variants()`

---

## 🎯 Migration Checklist

### Step 1: Preparation
- [ ] Create `R/00_data_utilities.R`
- [ ] Add helper functions (is_datatable, ensure_dataframe, restore_class)
- [ ] Update DESCRIPTION (add data.table)
- [ ] Update NAMESPACE

### Step 2: Implementation (per module)
- [ ] Module 1: NA Handling
- [ ] Module 2: Numeric Features  
- [ ] Module 3: Timestamp Features
- [ ] Module 4: String Features
- [ ] Module 5: N-gram Generation
- [ ] Module 6: Position Extraction
- [ ] Module 7: Linguistic Analysis
- [ ] Module 8: Dataset Inspection
- [ ] Module 9: Workflow Generator

### Step 3: Testing
- [ ] Create test file for data.table support
- [ ] Test format preservation
- [ ] Test result equivalence
- [ ] Performance benchmark

### Step 4: Documentation
- [ ] Update README with data.table examples
- [ ] Create data.table usage guide
- [ ] Update function documentation

---

## 💡 Implementation Priority

### Priority 1 (Must Have):
- `scale_betweenRange()`
- `generate_ngram_char_variants()`
- `extract_prefix_patterns()`

### Priority 2 (Should Have):
- All Module 2 functions
- All Module 6 functions
- Workflow generator

### Priority 3 (Nice to Have):
- All remaining functions

---

## 📚 Resources

**data.table Learning**:
- `?data.table` - Main documentation
- `vignette("datatable-intro")` - Introduction
- `data.table` GitHub - Latest features

**Integration Examples**:
```r
# Check if library supports data.table
require_data_table <- function() {
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("data.table package required for this feature")
  }
}

# Convert safely
safe_convert_dt <- function(data) {
  tryCatch(
    as.data.table(data),
    error = function(e) {
      warning("Could not convert to data.table, returning as data.frame")
      as.data.frame(data)
    }
  )
}
```

---

## 🎉 Summary

**Recommended Approach**: Hybrid support (Strategy 3)

**Benefits**:
- ✅ Users can use data.table directly
- ✅ Results stay in original format
- ✅ Minimal code changes needed
- ✅ Backward compatible
- ✅ Easy to test
- ✅ Easy to optimize later

**Timeline**: 
- Basic support: 2-3 hours
- Full support: 1-2 days
- Optimization: Optional (later)

**Next Steps**:
1. Create `R/00_data_utilities.R` with helpers
2. Update DESCRIPTION
3. Test with Module 2 functions
4. Roll out to other modules
5. Add documentation and examples

---

**Want to proceed with implementation? I can create the utility file and update the first module to show you exactly how it works!**
