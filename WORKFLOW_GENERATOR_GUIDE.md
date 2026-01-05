# Automatic Workflow Generator - Complete Guide

## Overview

The **Automatic Workflow Generator** solves a key problem: instead of manually writing column names and function calls, you can now:

1. **Load your data** (any dataset)
2. **Run the generator** (interactive menu)
3. **Select your options** (dataset, columns, analysis type)
4. **Get automatic script** (complete workflow generated!)

---

## The Problem It Solves

### Before (Manual):
```r
# You had to know column names and write everything by hand
ngrams <- generate_ngram_char_variants(movies, "title", 2, 3)
suffixes <- extract_suffix_patterns(ngrams$sliding$all, id_col = "movieId")
effects <- compute_global_linguistic_effects(movies, "title", "rating")

# What if your dataset uses "diagnosis" instead of "title"?
# You'd need to rewrite everything manually
ngrams <- generate_ngram_char_variants(cancer, "diagnosis", 2, 3)
suffixes <- extract_suffix_patterns(ngrams$sliding$all, id_col = "patientId")
effects <- compute_global_linguistic_effects(cancer, "diagnosis", "survival_months")
```

### After (Automatic):
```r
# Just run the interactive generator
generate_workflow_interactive()

# It discovers:
# - datasets in memory: movies, cancer, products
# - columns in each: title, diagnosis, product_name
# - generates workflow automatically
# - saves to file ready to run!
```

---

## Features

### 1. **Automatic Dataset Detection**
```r
detect_datasets()

# Output:
# Available datasets: movies, cancer_patients, products
# Dataset    Rows    Columns
# movies     5       5
# cancer     7       5
# products   6       6
```

### 2. **Column Discovery**
```r
show_dataset_columns("movies")

# Output:
# Column Type        Non_Null
# movieId numeric    5
# title   character  5
# rating  numeric    5
# (automatically identifies string vs numeric columns)
```

### 3. **Interactive Menu**
```r
generate_workflow_interactive()

# STEP 1: Choose dataset
# [1] movies (5 rows, 5 columns)
# [2] cancer_patients (7 rows, 5 columns)
# [3] products (6 rows, 6 columns)
# Enter choice: 1

# STEP 2: Choose string column
# [1] title
# [2] year
# Enter choice: 1

# STEP 3: Choose target column
# [1] rating
# [2] revenue
# Enter choice: 1

# STEP 4: Choose analysis type
# [1] Full Analysis (All functions)
# [2] N-gram Analysis Only
# [3] Position-based Analysis
# [4] Linguistic Analysis Only
# [5] Effects Analysis Only
# Enter choice: 1
```

### 4. **Automatic Script Generation**
The generator creates a complete workflow script with:
- Correct variable names from your dataset
- Proper column references (automatically discovered)
- All necessary function calls
- Comments and organization
- Ready-to-run code

### 5. **Script Saving**
Generated scripts are automatically saved with timestamp:
- `workflow_movies_20260105_140530.R`
- `workflow_cancer_patients_20260105_140531.R`
- `workflow_products_20260105_140532.R`

---

## Usage Examples

### Example 1: Interactive Generation (Best for Exploration)

```r
library(DataPreparation)

# Load your datasets
movies <- data.frame(movieId = 1:3, title = c("Matrix", "Inception", "Interstellar"),
                     rating = c(8.7, 8.8, 8.6))

cancer <- data.frame(patientId = 101:103, diagnosis = c("Breast Cancer", "Lung Cancer", "Colon Cancer"),
                     survival = c(48, 12, 72))

# Run the interactive generator
params <- generate_workflow_interactive()

# Output:
# - Detects: movies, cancer datasets
# - Detects: movieId, title, rating in movies
# - Detects: patientId, diagnosis, survival in cancer
# - User selects: cancer dataset
# - User selects: diagnosis column
# - User selects: survival target
# - Generator creates: workflow_cancer_patients_*.R
# - Ready to source('workflow_cancer_patients_*.R')
```

### Example 2: Automatic Mode (For Scripting)

```r
# Create multiple datasets
movies <- data.frame(...)
cancer <- data.frame(...)
products <- data.frame(...)

# Auto-generate for all datasets
datasets <- c("movies", "cancer", "products")

for (ds_name in datasets) {
  data <- get(ds_name)
  
  # Identify columns
  string_cols <- colnames(data)[sapply(data, is.character)]
  numeric_cols <- colnames(data)[sapply(data, is.numeric)]
  id_col <- colnames(data)[1]  # First column as ID
  
  # Generate workflow
  script <- generate_workflow_script(
    dataset_name = ds_name,
    string_col = string_cols[1],
    numeric_col = numeric_cols[1],
    id_col = id_col,
    analysis_type = "Full Analysis",
    data = data
  )
  
  # Save
  writeLines(script, paste0("workflow_", ds_name, ".R"))
}
```

### Example 3: Custom Generation

```r
# For a specific analysis need
script <- generate_workflow_script(
  dataset_name = "cancer_patients",
  string_col = "diagnosis",
  numeric_col = "survival_months",
  id_col = "patientId",
  analysis_type = "Position-based Analysis",  # Only prefix/suffix
  data = cancer_patients
)

# Save and run
writeLines(script, "cancer_position_analysis.R")
source("cancer_position_analysis.R")
```

---

## Generated Workflow Structure

When you run the generator, it creates a script with this structure:

```r
# AUTO-GENERATED WORKFLOW SCRIPT
# Generated: 2026-01-05 14:05:30
# Dataset: cancer_patients
# Analysis Type: Full Analysis

library(DataPreparation)

# STEP 1: INSPECT DATASET
inspect_dataset(cancer_patients)

# STEP 2: VALIDATE FOR PROCESSING
is_valid <- validate_for_processing(
  data = cancer_patients,
  string_cols = 'diagnosis',
  numeric_cols = 'survival_months',
  id_col = 'patientId'
)

# STEP 3: PREVIEW DATA
preview_dataset(cancer_patients)

# STEP 4: GENERATE N-GRAMS
ngrams <- generate_ngram_char_variants(
  data = cancer_patients,
  string_cols = 'diagnosis',
  ngram_min = 2,
  ngram_max = 3
)

# STEP 5: EXTRACT POSITION-BASED PATTERNS
prefixes <- extract_prefix_patterns(
  ngram_data_list = ngrams$sliding$all,
  id_col = 'patientId'
)

suffixes <- extract_suffix_patterns(
  ngram_data_list = ngrams$sliding$all,
  id_col = 'patientId'
)

# STEP 6: EXTRACT LINGUISTIC PROFILE
profile <- extract_string_linguistic_profile(
  data = cancer_patients,
  string_col = 'diagnosis',
  id_col = 'patientId'
)

# STEP 7: COMPUTE EFFECTS
effects <- compute_global_linguistic_effects(
  data = cancer_patients,
  string_col = 'diagnosis',
  rating_col = 'survival_months'
)

# STEP 8: POSITION IMPORTANCE
position_importance <- compute_position_importance(
  data = cancer_patients,
  string_col = 'diagnosis',
  rating_col = 'survival_months',
  id_col = 'patientId'
)

# STEP 9: SUMMARY
check_memory_usage()
```

**All column names automatically filled in!** No manual editing needed.

---

## Key Functions

### `detect_datasets(envir = .GlobalEnv, verbose = TRUE)`
**Purpose**: Find all data frames in memory
```r
detect_datasets()
# Returns: Data frame with dataset info
```

### `show_dataset_columns(dataset_name, envir = .GlobalEnv)`
**Purpose**: Show columns and types in a dataset
```r
show_dataset_columns("movies")
# Shows: column names, types, non-null counts
```

### `generate_workflow_interactive(envir = .GlobalEnv, auto_mode = FALSE)`
**Purpose**: Interactive menu-driven workflow generator
```r
params <- generate_workflow_interactive()
# Returns: List with selected parameters
```

### `generate_workflow_script(...)`
**Purpose**: Generate R code for a workflow (internal function)
```r
script <- generate_workflow_script(
  dataset_name = "cancer",
  string_col = "diagnosis",
  numeric_col = "survival",
  id_col = "patientId",
  analysis_type = "Full Analysis",
  data = cancer_data
)
```

---

## Workflow Types

### 1. Full Analysis
Runs all available functions:
- Dataset inspection
- Validation
- Preview
- N-gram generation
- Position extraction (prefix/suffix)
- Linguistic analysis
- Effects computation
- Position importance ranking
- Summary and memory check

### 2. N-gram Analysis Only
Focuses on n-gram extraction:
- N-gram generation
- Position patterns
- Frequency analysis

### 3. Position-based Analysis
Extracts position-specific patterns:
- Prefix patterns (first n-gram)
- Infix patterns (middle n-grams)
- Suffix patterns (last n-gram)
- Position importance ranking

### 4. Linguistic Analysis Only
Advanced feature extraction:
- Linguistic profiles
- Structural features
- Dynamic pattern discovery

### 5. Effects Analysis Only
Correlation with outcomes:
- Global effects on target variable
- Which patterns matter
- Predictive analysis

---

## Real-World Workflow

### Step 1: Set Up Your Data
```r
library(DataPreparation)

# Load your datasets
movies <- read.csv("movies.csv")
cancer <- read.csv("cancer.csv")
products <- read.csv("products.csv")
```

### Step 2: Run the Generator
```r
# This will show menu and generate workflows
generate_workflow_interactive()

# Follow the interactive prompts
# - Select dataset
# - Select string column
# - Select target variable
# - Select analysis type
# - Script saves automatically
```

### Step 3: Run the Generated Script
```r
# The generator created: workflow_cancer_patients_20260105_140530.R
source("workflow_cancer_patients_20260105_140530.R")

# Complete analysis runs automatically!
# All outputs and insights printed
```

### Step 4: Modify if Needed
```r
# Generated script is readable and modifiable
# You can tweak parameters and re-run
# Or generate another version with different selections
```

---

## Benefits

✅ **Automatic column discovery** - No hardcoding column names
✅ **Works with any dataset** - Movies, cancer, products, any domain
✅ **Interactive menus** - Easy selection process
✅ **Complete scripts** - Ready-to-run workflows
✅ **Reproducibility** - Scripts saved with timestamp
✅ **No manual editing** - Correct variable names automatically
✅ **Time-saving** - What took 30 minutes now takes 2 minutes
✅ **Exploration** - Quickly test different analysis types

---

## Troubleshooting

**Problem: "No data frames found"**
```r
# Solution: Load your data first
movies <- data.frame(...)
detect_datasets()  # Now works
```

**Problem: "No character columns"**
```r
# Solution: Make sure you have text data
# Text analysis requires character/string columns
```

**Problem: "Invalid selection"**
```r
# Solution: Enter numbers from the displayed options
# For 3 datasets, enter 1, 2, or 3
```

**Problem: "Script not saved"**
```r
# Check working directory
getwd()
# Script should be in this directory
# Look for workflow_*.R files
```

---

## Advanced: Batch Generation

```r
# Generate workflows for ALL datasets at once
all_datasets <- detect_datasets(verbose = FALSE)

for (i in 1:nrow(all_datasets)) {
  ds_name <- all_datasets$Dataset[i]
  data <- get(ds_name)
  
  # Find suitable columns
  string_cols <- names(data)[sapply(data, is.character)]
  numeric_cols <- names(data)[sapply(data, is.numeric)]
  
  if (length(string_cols) > 0 && length(numeric_cols) > 0) {
    script <- generate_workflow_script(
      dataset_name = ds_name,
      string_col = string_cols[1],
      numeric_col = numeric_cols[1],
      id_col = names(data)[1],
      analysis_type = "Full Analysis",
      data = data
    )
    
    filename <- paste0("workflow_", tolower(ds_name), ".R")
    writeLines(script, filename)
    cat("Generated:", filename, "\n")
  }
}
```

---

## Summary

The **Automatic Workflow Generator** is a game-changer because:

1. **No more hardcoding** - Columns are discovered automatically
2. **Works everywhere** - Same tool for movies, cancer, e-commerce, etc.
3. **Faster analysis** - Generate complete workflows in seconds
4. **Reproducible** - Scripts saved with timestamps
5. **Interactive** - Easy menus for selection
6. **Professional** - Generated scripts are well-organized

**Start using it today:**
```r
library(DataPreparation)
generate_workflow_interactive()
```

That's it! The rest happens automatically! 🚀
