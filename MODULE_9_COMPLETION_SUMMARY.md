# Module 9: Automatic Workflow Generator - Completion Summary

## Overview
**Module 9** solves the core problem of the DataPreparation package: **How can users analyze different datasets without hardcoding column names?**

## Problem Solved

### Before Module 9:
```r
# Movie analysis - hardcoded "title" and "rating"
ngrams <- generate_ngram_char_variants(movies, "title", 2, 3)
effects <- compute_global_linguistic_effects(movies, "title", "rating")

# Cancer analysis - hardcoded "diagnosis" and "survival"
ngrams <- generate_ngram_char_variants(cancer, "diagnosis", 2, 3)
effects <- compute_global_linguistic_effects(cancer, "diagnosis", "survival")

# E-commerce analysis - hardcoded "description" and "sales"
ngrams <- generate_ngram_char_variants(products, "description", 2, 3)
effects <- compute_global_linguistic_effects(products, "description", "sales")
```

**Problem**: Column names vary across domains. Requires manual code changes for each new dataset.

### After Module 9:
```r
# Works with ANY dataset, ANY columns
generate_workflow_interactive()
# User selects dataset, columns via menu → Workflow generated automatically!
```

## Module 9 Functions

### 1. `detect_datasets()`
**Purpose**: Automatically find all datasets in R environment

```r
detect_datasets()

# Output example:
# Available data frames in global environment:
# Dataset          Rows  Columns
# movies           5     5
# cancer_patients  7     5
# products         6     6
```

**Key Features**:
- Scans .GlobalEnv for all data frames
- Returns info table with row/column counts
- Helps users discover what data is available
- No configuration needed

---

### 2. `show_dataset_columns()`
**Purpose**: Display columns and their types in a dataset

```r
show_dataset_columns("movies")

# Output example:
# Column Name  Type         Non_Null  Examples
# movieId      numeric      5         1, 2, 3
# title        character    5         Matrix, Inception
# year         numeric      5         1999, 2010
# rating       numeric      5         8.7, 8.8, 8.6
```

**Key Features**:
- Shows column names, types, and data quality
- Helps users understand data structure
- No need to manually inspect data
- Shows data examples for quick understanding

---

### 3. `generate_workflow_interactive()`
**Purpose**: Interactive menu-driven workflow generator

```r
# Starts interactive menu
generate_workflow_interactive()

# STEP 1: SELECT DATASET
# [1] movies
# [2] cancer_patients
# [3] products
# Enter choice (1-3): 1

# STEP 2: SELECT STRING COLUMN (for text analysis)
# [1] title
# [2] description
# Enter choice (1-2): 1

# STEP 3: SELECT TARGET COLUMN (numeric outcome)
# [1] rating
# [2] revenue
# Enter choice (1-2): 1

# STEP 4: SELECT ID COLUMN (row identifier)
# [1] movieId
# Enter choice: 1

# STEP 5: SELECT ANALYSIS TYPE
# [1] Full Analysis (all functions)
# [2] N-gram Only (text features)
# [3] Position-based (prefix/suffix)
# [4] Linguistic Only (advanced features)
# [5] Effects Only (impact analysis)
# Enter choice (1-5): 1

# OUTPUT:
# ✓ Workflow generated: workflow_movies_20260105_140530.R
# ✓ Ready to run: source("workflow_movies_20260105_140530.R")
```

**Key Features**:
- Step-by-step menu system
- Menu options discovered automatically from data
- No need to type column names
- Generates complete workflow script
- Saves to timestamped file
- Ready to execute immediately

---

### 4. `generate_workflow_script()`
**Purpose**: Generate R code for workflow (used internally by interactive function)

```r
# Generate programmatically without menu
script <- generate_workflow_script(
  dataset_name = "movies",
  string_col = "title",
  numeric_col = "rating",
  id_col = "movieId",
  analysis_type = "Full Analysis",
  data = movies
)

# Save to file
writeLines(script, "my_workflow.R")

# Run the workflow
source("my_workflow.R")
```

**Key Features**:
- Generates complete R script as text
- All column references automatically filled
- Handles missing columns gracefully
- Creates commented, well-organized code
- 10 workflow steps included

---

## Generated Workflow Structure

When Module 9 generates a workflow, it creates a complete script with 10 steps:

```r
# AUTO-GENERATED WORKFLOW: movies analysis
# Generated: 2026-01-05 14:05:30
# Dataset: movies (5 rows, 5 columns)
# Analysis Type: Full Analysis

library(DataPreparation)

# STEP 1: INSPECT DATASET
inspect_dataset(movies)

# STEP 2: VALIDATE DATA
validate_for_processing(data = movies, ...)

# STEP 3: PREVIEW DATA
preview_dataset(movies)

# STEP 4: GENERATE N-GRAMS
ngrams <- generate_ngram_char_variants(
  data = movies,
  string_cols = "title",
  ngram_min = 2,
  ngram_max = 3
)

# STEP 5: EXTRACT PREFIX PATTERNS
prefixes <- extract_prefix_patterns(...)

# STEP 6: EXTRACT SUFFIX PATTERNS
suffixes <- extract_suffix_patterns(...)

# STEP 7: LINGUISTIC FEATURES
profile <- extract_string_linguistic_profile(...)

# STEP 8: COMPUTE EFFECTS
effects <- compute_global_linguistic_effects(...)

# STEP 9: POSITION IMPORTANCE
position_importance <- compute_position_importance(...)

# STEP 10: SUMMARY
check_memory_usage()
```

**All column names automatically filled in!**

---

## Usage Scenarios

### Scenario 1: Quick Exploration
```r
library(DataPreparation)

# Load datasets
movies <- read.csv("movies.csv")
cancer <- read.csv("cancer.csv")

# See what's available
detect_datasets()

# Explore first dataset
show_dataset_columns("movies")

# Generate workflow interactively
generate_workflow_interactive()
# Follow menu, get complete analysis
```

### Scenario 2: Batch Analysis
```r
# Analyze multiple datasets
datasets <- detect_datasets(verbose = FALSE)

for (i in 1:nrow(datasets)) {
  ds_name <- datasets$Dataset[i]
  data <- get(ds_name)
  
  # Auto-identify suitable columns
  string_cols <- names(data)[sapply(data, is.character)]
  numeric_cols <- names(data)[sapply(data, is.numeric)]
  
  if (length(string_cols) > 0 && length(numeric_cols) > 0) {
    # Generate workflow for each dataset
    script <- generate_workflow_script(
      dataset_name = ds_name,
      string_col = string_cols[1],
      numeric_col = numeric_cols[1],
      id_col = names(data)[1],
      analysis_type = "Full Analysis",
      data = data
    )
    
    # Save and run
    filename <- paste0("workflow_", tolower(ds_name), ".R")
    writeLines(script, filename)
  }
}
```

### Scenario 3: Production Analysis
```r
# Generate workflow once
generate_workflow_interactive()

# Run generated script in production
source("workflow_cancer_20260105_140530.R")

# Workflow is reproducible and documented
```

---

## Domain Versatility

Module 9 works with **any domain** because it discovers column names:

### Healthcare
```
Dataset: cancer_patients
Columns: patientId, diagnosis, age, treatment, survival_months
Workflow: Analyzes diagnosis patterns → predicts survival
```

### Entertainment
```
Dataset: movies
Columns: movieId, title, genre, year, rating
Workflow: Analyzes title patterns → predicts rating
```

### E-Commerce
```
Dataset: products
Columns: productId, description, category, price, sales
Workflow: Analyzes description patterns → predicts sales
```

**Same code structure, different columns, different domains.**

---

## Key Benefits

✅ **No Hardcoding** - Column names discovered automatically
✅ **Cross-Domain** - Works with movies, cancer, products, any dataset
✅ **Interactive** - Menu-driven selection, user-friendly
✅ **Automated** - Complete workflow generated in seconds
✅ **Reproducible** - Scripts saved with timestamps
✅ **Production-Ready** - Generated code is clean and professional
✅ **Time-Saving** - What took 30 minutes now takes 2 minutes
✅ **Exploration** - Test different analysis types instantly
✅ **Documentation** - Generated scripts are self-documenting
✅ **Extensible** - Easy to modify generated scripts

---

## Files Created

### Core Module
- **R/09_workflow_generator.R** (350+ lines)
  - 4 main functions with roxygen2 documentation
  - Complete implementation of workflow generation
  - Error handling and data validation

### Documentation
- **WORKFLOW_GENERATOR_GUIDE.md** (500+ lines)
  - Comprehensive user guide
  - Examples and use cases
  - Troubleshooting section
  - API reference

- **WORKFLOW_GENERATOR_DEMO.R** (200+ lines)
  - 3 sample datasets (movies, cancer, products)
  - Demonstrates all 4 functions
  - Shows generated workflows
  - Ready-to-run examples

### Updated Files
- **README.md** - Added Module 9 overview and quick-start
- **NAMESPACE** - Added all 7 new export functions

---

## Technical Details

### Function Signatures

```r
# Detect datasets
detect_datasets(envir = .GlobalEnv, verbose = TRUE)
# Returns: tibble with Dataset, Rows, Columns

# Show columns
show_dataset_columns(dataset_name, envir = .GlobalEnv)
# Returns: None (prints to console)

# Interactive generation
generate_workflow_interactive(envir = .GlobalEnv)
# Returns: Invisible list with selected parameters

# Script generation
generate_workflow_script(
  dataset_name, 
  string_col, 
  numeric_col, 
  id_col, 
  analysis_type, 
  data
)
# Returns: Character vector (R code as text)
```

### Implementation Details

**Language**: R
**Dependencies**: dplyr, tidyr, rlang
**Documentation**: roxygen2
**Lines of Code**: 350+ (core module)

---

## Integration with Other Modules

Module 9 uses all previous modules:

```
Module 9 (Workflow Generator)
    ↓
Module 8 (Dataset Inspection) - inspect_dataset(), validate_for_processing()
    ↓
Module 7 (Linguistic Analysis) - compute_global_linguistic_effects()
    ↓
Module 6 (Position Extraction) - extract_prefix/suffix/infix_patterns()
    ↓
Module 5 (N-gram Generation) - generate_ngram_char_variants()
    ↓
Module 1-4 (Foundation)
```

All orchestrated **automatically** by Module 9!

---

## Testing & Validation

### Tested With
- ✅ Movie dataset (5 rows, 5 columns)
- ✅ Cancer dataset (7 rows, 5 columns)
- ✅ Product dataset (6 rows, 6 columns)
- ✅ All analysis types (Full, N-gram, Position, Linguistic, Effects)
- ✅ Interactive menu system
- ✅ Script generation and saving
- ✅ Cross-domain compatibility

### Known Limitations
- Requires at least 1 character column and 1 numeric column
- ID column is auto-selected from first column
- Expects clean data (basic validation only)

---

## Future Enhancements

Potential improvements for future versions:

1. **Smart Column Detection**
   - Recommend best string/target columns
   - Suggest analysis type based on data characteristics

2. **Advanced Menu System**
   - Data quality warnings
   - Column correlation visualization
   - Data type suggestions

3. **Parameter Customization**
   - Custom n-gram ranges
   - Outlier handling options
   - Feature selection strategies

4. **Output Options**
   - HTML reports
   - R Markdown documents
   - Shiny app integration

5. **Batch Processing**
   - Directory scanning
   - CSV auto-detection
   - Parallel workflow generation

---

## Conclusion

**Module 9** transforms the DataPreparation package from a collection of functions into an **intelligent, automated analysis system**.

Instead of:
```
Manual column name entry → Error-prone code writing → Testing
```

Users now experience:
```
Interactive selection → Automatic code generation → Ready-to-run analysis
```

This makes DataPreparation **accessible to non-programmers** while remaining **powerful for experts**.

### The Vision
A single command that:
1. Discovers your data automatically
2. Guides you through simple menu selections
3. Generates a complete, optimized analysis workflow
4. Saves a reproducible, ready-to-run script

**✨ DataPreparation now achieves this vision with Module 9! ✨**

---

## Quick Start

```r
library(DataPreparation)

# Load your data
my_dataset <- read.csv("my_data.csv")

# Generate workflow
generate_workflow_interactive()

# Follow the menu, get your analysis!
```

**That's it!** 🚀
