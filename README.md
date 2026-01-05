# DataPreparation

A comprehensive, modular R package for data preparation and feature engineering. This package provides 50+ general-purpose functions organized into 7 logical modules, enabling reuse across different projects and datasets.

## Features

### 📦 Module 1: NA Handling
Functions for managing missing values:
- `remove_na_columns()` - Remove rows with NA in specified columns
- `impute_na_numeric()` - Impute NA with median values
- `flag_na_column()` - Create binary NA indicator flags
- `summarize_na_rows()` - Generate NA statistics summaries

### 🔢 Module 2: Numeric Features (30+ functions)
Comprehensive numeric feature engineering:
- **Scaling**: `scale_betweenRange()`, `scale_unbounded()`
- **Transformations**: `transform_log()`, `transform_sqrt()`, `transform_exp()`
- **Polynomial Features**: `create_polynomial_features()`, `create_interaction_features()`, `create_ratio_features()`
- **Binning**: `binning_quantile()`, `binning_width()`
- **Outlier Detection**: `flag_outliers_iqr()`, `flag_outliers_zscore()`
- **Normalization**: `normalize_numeric()` (4 methods: minmax, zscore, robust, log)
- **Statistics**: `compute_rolling_statistics()`, `compute_group_statistics()`
- **Advanced Features**: `create_quantile_features()`, `create_rank_features()`, `create_percentage_change()`, `create_difference_features()`
- **Variants**: `generate_numeric_variants()`, `generate_numeric_variants_advanced()`

### ⏰ Module 3: Timestamp Features
Extract temporal patterns:
- `extract_timestamp_features()` - Extract year/month/day/weekday from timestamps
- `extract_year_from_title()` - Extract 4-digit year from string titles

### 📝 Module 4: String Features
String processing and feature validation:
- `validate_ngram()` - Validate n-gram extraction (clean vs. distorted)
- `generate_numeric_variants()` - Create numeric feature transformation candidates
- `generate_categorical_variants()` - Generate categorical encoding variants (one-hot encoding)

### 🔤 Module 5: N-gram Generation
Advanced text feature extraction:
- `generate_ngram_char_variants()` - Character-level n-grams using 4 methods:
  - **Sliding**: Overlapping n-grams (step by 1)
  - **Stride**: Non-overlapping n-grams excluding spaces
  - **Strict**: Non-overlapping with underscore padding
  - **Null**: Non-overlapping, incomplete chunks removed
- `generate_ngram_word_variants()` - Word-level n-grams (unigrams, bigrams, trigrams, etc.)

### 📍 Module 6: Position Extraction
Extract position-specific patterns from n-grams:
- `extract_prefix_patterns()` - Extract first/opening n-grams (prefix position)
- `extract_infix_patterns()` - Extract middle n-grams (infix position)
- `extract_suffix_patterns()` - Extract last/closing n-grams (suffix position)

### 🎯 Module 7: Linguistic Analysis (Dynamic Pattern Discovery)
Advanced linguistic feature extraction with dynamic pattern discovery:
- `extract_string_linguistic_profile()` - Extract structural and dynamic linguistic features
- `compute_global_linguistic_effects()` - Compute feature effects on target variable
- `compute_user_linguistic_preferences()` - Extract user-specific feature preferences
- `compute_user_linguistic_compatibility()` - Calculate user-feature compatibility scores
- `compute_position_importance()` - Rank position importance (prefix, infix, suffix)
- `summarize_linguistic_analysis()` - Generate comprehensive analysis summaries

## Installation

### From GitHub (after uploading to GitHub):
```r
# Install devtools if not already installed
# install.packages("devtools")

devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

### For local development:
```r
# Load all functions for development/testing
devtools::load_all("path/to/DataPreparation")

# Or install locally
devtools::install("path/to/DataPreparation")
```

## Quick Start

```r
library(DataPreparation)

# Example 1: Handle missing values
data <- data.frame(
  id = 1:5,
  value = c(1, 2, NA, 4, 5)
)
cleaned <- remove_na_columns(data, "value")

# Example 2: Create numeric feature variants
scaled <- scale_betweenRange(data, "value")
standardized <- scale_unbounded(data, "value")

# Example 3: Extract character-level n-grams
titles <- data.frame(title = c("The Matrix", "Inception"))
ngrams <- generate_ngram_char_variants(titles, "title", 2, 3)

# Example 4: Extract linguistic features from movie titles
movies <- data.frame(
  movieId = 1:3,
  title = c("The Matrix", "The Dark Knight", "Inception"),
  rating = c(8.7, 9.0, 8.8)
)
profile <- extract_string_linguistic_profile(movies, "title", "movieId")
head(profile$profile)

# Example 5: Compute feature effects on ratings
effects <- compute_global_linguistic_effects(
  movies, 
  string_col = "title", 
  rating_col = "rating"
)
head(effects$global_effects)
```

## Dependencies

- **dplyr** - Data manipulation
- **tidyr** - Data reshaping
- **stringr** - String operations
- **purrr** - Functional programming
- **zoo** - Rolling statistics
- **rlang** - Meta-programming
- **tibble** - Modern data frames

## Documentation

Each function includes:
- Detailed parameter descriptions
- Return value specifications
- Usage examples
- Roxygen2-generated man pages

Access documentation in R:
```r
?function_name        # View function documentation
help(package = "DataPreparation")  # View package overview
```

## Design Philosophy

- **Modular**: Functions organized into 7 logical modules for easy navigation
- **Reusable**: General-purpose functions work across different datasets and projects
- **Well-documented**: Comprehensive roxygen2 documentation for all 50+ functions
- **Consistent API**: Predictable function names and parameter conventions
- **Dynamic**: Linguistic analysis functions discover patterns from data automatically

## Project Status

✅ All 50+ functions extracted and documented  
✅ 7 modular files organized by functionality  
✅ Roxygen2 documentation complete  
✅ DESCRIPTION and package metadata configured  
✅ Ready for GitHub and Zenodo publishing  

## License

MIT License - See LICENSE file for details

## Author

AARICHE ABDERRAHIM

## Citation

If you use this package in your research, please cite it appropriately. Once published on Zenodo:
```
Abderrahim, A. (2025). DataPreparation: General-Purpose Data Preparation and Feature 
Engineering Library. Zenodo. https://doi.org/10.5281/zenodo.[XXXX]
```

## Contributing

This is a professional, reusable library extracted from the Harvard Data Science Capstone Project. 
Contributions and improvements are welcome!
