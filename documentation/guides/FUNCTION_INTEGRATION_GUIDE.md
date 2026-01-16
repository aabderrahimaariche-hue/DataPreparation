# Integration Guide: Updating Functions for Registry Support

## Overview

This guide shows how to update existing functions in the DataPreparation package to support the new Dataset Registry system. This is a **Phase 2** task for progressive integration.

## The Approach

Instead of breaking existing code, we'll **add registry support while maintaining backward compatibility**.

### Strategy

```r
# OLD: Function accepts only data frame
my_function <- function(data, param1, param2) {
  # ... do something with data ...
}

# NEW: Function accepts data frame OR dataset name
my_function <- function(data = NULL, dataset_name = NULL, param1, param2) {
  # If dataset_name provided, get data from registry
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  }
  
  # Validate we have data
  if (is.null(data)) {
    stop("Either provide 'data' or 'dataset_name'")
  }
  
  # ... rest of function unchanged ...
}

# Both ways now work:
my_function(data = my_data, param1 = x)         # Old way
my_function(dataset_name = "mydata", param1 = x)  # New way
```

---

## Step-by-Step Integration

### Pattern for Most Functions

```r
# BEFORE
my_function <- function(data, other_params) {
  # Function body
}

# AFTER - Add 3 lines for registry support
my_function <- function(data = NULL, dataset_name = NULL, other_params) {
  
  # NEW: Resolve data from registry if needed (3 lines)
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    stop("Provide either 'data' or 'dataset_name'")
  }
  
  # REST OF FUNCTION - NO CHANGES NEEDED
  # ... all existing code continues as-is ...
}
```

---

## Examples of Function Updates

### Example 1: `inspect_dataset()`

**Current** (from `R/08_dataset_inspection.R`):
```r
inspect_dataset <- function(data, verbose = TRUE, show_head = TRUE) {
  # Function body
}
```

**Updated**:
```r
inspect_dataset <- function(data = NULL, verbose = TRUE, show_head = TRUE,
                            dataset_name = NULL) {
  
  # Resolve from registry if needed
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    stop("Provide either 'data' or 'dataset_name'")
  }
  
  # Rest of function unchanged...
  # ... original code continues exactly as before ...
}
```

**Usage After Update**:
```r
# Old way - still works
inspect_dataset(data = movies)

# New way - from registry
register_dataset(movies, "movies")
inspect_dataset(dataset_name = "movies")

# Even shorter with default
inspect_dataset("movies")  # If we set dataset_name as first param
```

### Example 2: `generate_ngram_char_variants()`

**Current**:
```r
generate_ngram_char_variants <- function(data, string_cols, 
                                         ngram_min = 2, ngram_max = 4,
                                         variants = c(...)) {
  # Function body
}
```

**Updated**:
```r
generate_ngram_char_variants <- function(data = NULL, string_cols,
                                         ngram_min = 2, ngram_max = 4,
                                         variants = c(...),
                                         dataset_name = NULL) {
  
  # Resolve from registry if needed
  if (!is.null(dataset_name)) {
    data <- get_registered_dataset(dataset_name)
  } else if (is.null(data)) {
    stop("Provide either 'data' or 'dataset_name'")
  }
  
  # Rest of function unchanged...
}
```

**Usage After Update**:
```r
# Old way
ngrams <- generate_ngram_char_variants(data = movies, string_cols = "title")

# New way
register_dataset(movies, "movies")
ngrams <- generate_ngram_char_variants(dataset_name = "movies", string_cols = "title")
```

### Example 3: Multiple Data Parameters

Some functions accept multiple datasets (like comparison functions):

**Before**:
```r
compare_datasets <- function(data1, data2, comparison_method) {
  # Compare data1 and data2
}
```

**After**:
```r
compare_datasets <- function(data1 = NULL, data2 = NULL, comparison_method,
                             dataset_name1 = NULL, dataset_name2 = NULL) {
  
  # Resolve first dataset
  if (!is.null(dataset_name1)) {
    data1 <- get_registered_dataset(dataset_name1)
  } else if (is.null(data1)) {
    stop("Provide either 'data1' or 'dataset_name1'")
  }
  
  # Resolve second dataset
  if (!is.null(dataset_name2)) {
    data2 <- get_registered_dataset(dataset_name2)
  } else if (is.null(data2)) {
    stop("Provide either 'data2' or 'dataset_name2'")
  }
  
  # Rest of function unchanged...
}
```

**Usage**:
```r
# Old way
compare_datasets(data1 = movies, data2 = reviews, ...)

# New way
register_dataset(movies, "movies")
register_dataset(reviews, "reviews")
compare_datasets(dataset_name1 = "movies", dataset_name2 = "reviews", ...)
```

---

## Convenience Function Pattern

For heavily-used functions, consider creating convenience versions:

```r
# Original function - supports both ways
generate_ngram_char_variants <- function(data = NULL, string_cols,
                                         ngram_min = 2, ngram_max = 4,
                                         dataset_name = NULL) {
  # ... implementation with registry support ...
}

# Convenience function - shorter name for registry usage
generate_ngrams_from_registry <- function(dataset_name, string_cols,
                                          ngram_min = 2, ngram_max = 4) {
  generate_ngram_char_variants(dataset_name = dataset_name, 
                               string_cols = string_cols,
                               ngram_min = ngram_min, 
                               ngram_max = ngram_max)
}

# Usage
generate_ngram_char_variants(data = movies, string_cols = "title")  # Old
generate_ngrams_from_registry("movies", "title")                     # New
```

---

## Priority Functions to Update

Based on frequency of use, update in this order:

### High Priority (Core Analysis)
- [ ] `inspect_dataset()` - Used in every workflow
- [ ] `generate_ngram_char_variants()` - Core feature
- [ ] `extract_string_linguistic_profile()` - Core feature
- [ ] `compute_global_linguistic_effects()` - Core analysis
- [ ] `generate_workflow_script()` - Generator function

### Medium Priority (Common Operations)
- [ ] `count_categories()` - Category analysis
- [ ] `encode_categorical_flags()` - Preprocessing
- [ ] `extract_prefix_patterns()` - Pattern analysis
- [ ] `extract_suffix_patterns()` - Pattern analysis
- [ ] `create_ratio_features()` - Feature engineering

### Lower Priority (Utilities)
- [ ] `validate_for_processing()` - Validation
- [ ] `impute_na_numeric()` - NA handling
- [ ] `normalize_numeric()` - Normalization
- [ ] `flag_outliers_iqr()` - Outlier detection
- [ ] Other utility functions

---

## Testing Updated Functions

After updating a function, test both ways:

```r
# Setup
library(DataPreparation)
test_data <- data.frame(x = 1:100, y = letters[1:10])

# Test 1: Original way still works
result1 <- my_function(data = test_data, param = "value")

# Test 2: Registry way works
register_dataset(test_data, "test")
result2 <- my_function(dataset_name = "test", param = "value")

# Test 3: Results are identical
identical(result1, result2)  # Should be TRUE

# Test 4: Error handling
tryCatch(
  my_function(param = "value"),  # Missing both data and dataset_name
  error = function(e) cat("Good - caught error:", e$message)
)
```

---

## Documentation Template

For each updated function, add to the roxygen documentation:

```r
#' @param data Data frame or data.table (optional if dataset_name provided)
#' @param dataset_name Character. Name of registered dataset to use.
#'        If provided, 'data' parameter is ignored.
#'
#' @details
#' This function supports both traditional and registry-based usage:
#' \itemize{
#'   \item \strong{Traditional}: \code{my_function(data = my_data, ...)}
#'   \item \strong{Registry}: \code{my_function(dataset_name = "my_data", ...)}
#' }
#'
#' @examples
#' \dontrun{
#' # Traditional way
#' df <- data.frame(x = 1:10)
#' result1 <- my_function(data = df, param = "value")
#'
#' # Registry way
#' register_dataset(df, "mydata")
#' result2 <- my_function(dataset_name = "mydata", param = "value")
#' }
```

---

## Common Issues & Solutions

### Issue 1: Function Signature Changes Break Existing Code

**Solution**: Make new parameters optional with defaults:
```r
# ✗ Wrong - breaks existing calls
my_func <- function(data, dataset_name, other_params) { }

# ✓ Right - backward compatible
my_func <- function(data = NULL, other_params, dataset_name = NULL) { }
```

### Issue 2: Parameter Order Ambiguity

**Solution**: Be explicit about which mode is being used:
```r
# Good - clear intent
my_func(data = df, param = x)
my_func(dataset_name = "mydata", param = x)

# Confusing - is "mydata" the data or the dataset_name?
my_func("mydata", param = x)
```

### Issue 3: Functions with Multiple Data Parameters

**Solution**: Use suffixes for clarity:
```r
# ✓ Clear naming
compare_data <- function(data1 = NULL, data2 = NULL, 
                        dataset_name1 = NULL, dataset_name2 = NULL) { }

compare_data(data1 = df1, data2 = df2)
compare_data(dataset_name1 = "df1", dataset_name2 = "df2")
```

---

## Checklist for Updating a Function

- [ ] Identify function in codebase
- [ ] Add `dataset_name = NULL` parameter
- [ ] Add registry resolution code (3-4 lines)
- [ ] Update roxygen documentation
- [ ] Test original way still works
- [ ] Test registry way works
- [ ] Test error handling
- [ ] Update NAMESPACE if needed
- [ ] Create or update example
- [ ] Document in function help

---

## Implementation Timeline Recommendation

### Sprint 1: Foundation
- [ ] Deploy registry system (✅ DONE)
- [ ] Test registry functions
- [ ] Update top 3 functions (inspect, generate_ngram, profile)

### Sprint 2: Core Analysis
- [ ] Update remaining 5 core functions
- [ ] Create convenience functions for common workflows

### Sprint 3: Complete Coverage
- [ ] Update all remaining functions
- [ ] Comprehensive testing

### Sprint 4: Documentation & Onboarding
- [ ] Update vignettes
- [ ] Create tutorial workflows
- [ ] User training materials

---

## File-by-File Integration Guide

### R/08_dataset_inspection.R
- [ ] `inspect_dataset()` - Add dataset_name param
- [ ] `preview_dataset()` - Add dataset_name param

### R/05_ngram_generation.R
- [ ] `generate_ngram_char_variants()` - Add dataset_name param
- [ ] `generate_ngram_word_variants()` - Add dataset_name param

### R/07_linguistic_analysis.R
- [ ] `extract_string_linguistic_profile()` - Add dataset_name param
- [ ] `compute_global_linguistic_effects()` - Add dataset_name param
- [ ] `compute_user_linguistic_preferences()` - Add dataset_name param

### R/11_categorical_intelligence.R
- [ ] `encode_categorical_flags()` - Add dataset_name param
- [ ] `count_categories()` - Add dataset_name param
- [ ] `extract_primary_category()` - Add dataset_name param

### R/09_workflow_generator.R
- [ ] `generate_workflow_script()` - Add dataset_name param
- [ ] `generate_workflow_interactive()` - Add dataset_name param

---

## Summary

**The beauty of this approach:**
- ✅ Backward compatible - all old code still works
- ✅ Minimal code changes - just 3-4 lines per function
- ✅ Progressive deployment - update functions one at a time
- ✅ No performance impact - registry lookup is fast
- ✅ Users benefit immediately - can start using new way right away

**All while keeping existing code unchanged!**
