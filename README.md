# DataPreparation

A comprehensive, modular R package for data preparation and feature engineering. This package provides 50+ general-purpose functions organized into 7 logical modules, enabling reuse across different projects and datasets.

## ✨ Features

### 📦 Module 1: NA Handling
Functions for managing missing values:
- `remove_na_columns()` - Remove rows with NA in specified columns
- `impute_na_numeric()` - Impute NA with median values
- `flag_na_column()` - Create binary NA indicator flags
- `summarize_na_rows()` - Generate NA statistics summaries

### 🔢 Module 2: Numeric Features
Comprehensive numeric feature engineering with 30+ functions:
- **Scaling**: `scale_betweenRange()`, `scale_unbounded()`
- **Transformations**: `transform_log()`, `transform_sqrt()`, `transform_exp()`
- **Polynomial Features**: `create_polynomial_features()`, `create_interaction_features()`, `create_ratio_features()`
- **Binning**: `binning_quantile()`, `binning_width()`
- **Outlier Detection**: `flag_outliers_iqr()`, `flag_outliers_zscore()`
- **Normalization**: `normalize_numeric()` (4 methods: minmax, zscore, robust, log)
- **Statistics**: `compute_rolling_statistics()`, `compute_group_statistics()`
- **Advanced**: `create_quantile_features()`, `create_rank_features()`, `create_percentage_change()`

### ⏰ Module 3: Timestamp Features
Extract temporal patterns:
- `extract_timestamp_features()` - Extract year/month/day/weekday from timestamps
- `extract_year_from_string()` - Extract 4-digit year from strings

### 📝 Module 4: String Features
String processing and feature validation:
- `validate_ngram()` - Validate n-gram extraction
- `generate_numeric_variants()` - Create numeric feature transformation candidates
- `generate_categorical_variants()` - Generate categorical encoding variants

### 🔤 Module 5: N-gram Generation
Advanced text feature extraction:
- `generate_ngram_char_variants()` - Character-level n-grams (4 methods)
- `generate_ngram_word_variants()` - Word-level n-grams

### 📍 Module 6: Position Extraction
Extract position-specific patterns:
- `extract_prefix_patterns()` - Extract first n-grams
- `extract_infix_patterns()` - Extract middle n-grams
- `extract_suffix_patterns()` - Extract last n-grams

### 🎯 Module 7: Linguistic Analysis
Advanced linguistic feature extraction:
- `extract_string_linguistic_profile()` - Extract linguistic features
- `compute_global_linguistic_effects()` - Compute feature effects on target variable
- `compute_user_linguistic_preferences()` - Extract user-specific preferences
- `compute_position_importance()` - Rank position importance

## 📦 Installation

### Install from GitHub:
```r
# Install devtools if needed
install.packages("devtools")

# Install DataPreparation
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

### Load the package:
```r
library(DataPreparation)
```

## 🚀 Quick Start

### Example 1: Handle Missing Values
```r
data <- data.frame(
  id = 1:5,
  value = c(1, 2, NA, 4, 5)
)
cleaned <- remove_na_columns(data, "value")
```

### Example 2: Scale Numeric Features
```r
scaled <- scale_betweenRange(data, "value")
standardized <- scale_unbounded(data, "value")
```

### Example 3: Extract N-grams
```r
titles <- data.frame(title = c("The Matrix", "Inception"))
ngrams <- generate_ngram_char_variants(titles, "title", 2, 3)
```

### Example 4: Linguistic Analysis
```r
movies <- data.frame(
  movieId = 1:3,
  title = c("The Matrix", "The Dark Knight", "Inception"),
  rating = c(8.7, 9.0, 8.8)
)

# Extract linguistic features
profile <- extract_string_linguistic_profile(movies, "title", "movieId")
head(profile$profile)

# Compute effects on target variable
effects <- compute_global_linguistic_effects(
  movies, 
  string_col = "title", 
  rating_col = "rating"
)
head(effects$global_effects)
```

## 📚 Documentation

Each function includes detailed documentation. Access it in R:
```r
?function_name                          # View specific function
help(package = "DataPreparation")       # View package overview
```

## 📋 Dependencies

- **dplyr** - Data manipulation
- **tidyr** - Data reshaping
- **stringr** - String operations
- **purrr** - Functional programming
- **zoo** - Rolling statistics
- **rlang** - Meta-programming
- **tibble** - Modern data frames

## 🎯 Design Philosophy

- **Modular**: Functions organized into 7 logical modules for easy navigation
- **Reusable**: General-purpose functions work across different datasets
- **Well-documented**: Comprehensive documentation for all 50+ functions
- **Consistent API**: Predictable function names and parameter conventions
- **Dynamic**: Linguistic analysis functions discover patterns automatically

## 📄 License

MIT License - See LICENSE file for details

## 👤 Author

AARICHE ABDERRAHIM

## 📖 Citation

If you use this package in your research, please cite:

```bibtex
@software{abderrahim2025datapreparation,
  author = {Abderrahim, Aariche},
  title = {DataPreparation: General-Purpose Data Preparation and Feature Engineering Library},
  year = {2025},
  url = {https://github.com/aabderrahimaariche-hue/DataPreparation}
}
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📞 Support

For issues, questions, or suggestions, please open an issue on [GitHub](https://github.com/aabderrahimaariche-hue/DataPreparation/issues).
