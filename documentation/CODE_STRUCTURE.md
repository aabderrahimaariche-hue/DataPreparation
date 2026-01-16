# DataPreparation Code Structure

## Overview

The DataPreparation package is a comprehensive R library for data preparation and feature engineering. It consists of **81 total functions** organized into **9 logical modules**, designed for modularity, reusability, and maintainability.

## Package Statistics

- **Total Functions**: 81
- **Modules**: 9 functional modules + 1 registry/utility module (Module 0)
- **Documentation Files**: 81 roxygen2-generated .Rd files
- **Core Dependencies**: dplyr, tidyr, purrr, zoo, rlang, stringr, tibble
- **Version**: 1.2.0 (development)

## Module Directory

### Module 0: Dataset Registry & Infrastructure

**File**: `R/00_dataset_registry.R` (362 lines)

**Purpose**: Provides global dataset management and focus mode system

**Key Functions**:
- `register_dataset()` - Register a dataset in the registry
- `get_registered_dataset()` - Retrieve a registered dataset
- `focus_dataset()` - Set focus to a specific dataset
- `resolve_data_source()` - Intelligent parameter resolution
- `get_data_format_info()` - Retrieve dataset format information
- `.get_registry()` - Internal registry accessor
- `.initialize_registry()` - Registry initialization

**Architecture Details**:
- Maintains global registry in `.DataPreparation_Registry` environment
- Implements smart parameter resolution (explicit → focus → implicit)
- Provides backward compatibility (all functions work with/without focus)
- Auto-initializes on package load

**Usage Pattern**:
```r
# Register once
register_dataset(my_data, "my_data")

# Set focus
focus_dataset("my_data")

# Use implicitly
result <- some_function("column_name")
```

### Module 1: NA Handling

**File**: `R/01_na_handling.R` (120 lines)

**Purpose**: Manage missing values (NA) in datasets

**Functions** (4):
1. `remove_na_columns()` - Remove rows with NA in specified columns
2. `impute_na_numeric()` - Impute NA values with median/mean
3. `flag_na_column()` - Create binary NA indicator flags
4. `summarize_na_rows()` - Generate NA statistics summaries

**Key Characteristics**:
- ✅ Focus mode support (data parameter + dataset_name parameter)
- Works with data.table, data.frame, tbl_df
- Flexible imputation strategies
- Output: Original data + new NA flag columns

**Use Cases**:
- Preprocessing datasets with missing values
- Creating missing value indicators for modeling
- Understanding missing data patterns

### Module 2: Numeric Features

**File**: `R/02_numeric_features.R` (1000+ lines)

**Purpose**: Comprehensive numeric feature engineering and transformation

**Function Categories** (24 functions):

**Scaling Functions**:
- `scale_betweenRange()` - Scale to [0,1] range
- `scale_unbounded()` - Unbounded scaling (z-score normalization)

**Transformation Functions**:
- `transform_log()` - Log transformation
- `transform_sqrt()` - Square root transformation
- `transform_exp()` - Exponential transformation

**Feature Creation**:
- `create_polynomial_features()` - Generate polynomial features
- `create_interaction_features()` - Generate interaction terms
- `create_ratio_features()` - Create ratio features
- `create_difference_features()` - Create difference features
- `create_quantile_features()` - Create quantile-based features
- `create_rank_features()` - Create rank-based features
- `create_percentage_change()` - Calculate percentage changes

**Binning Functions**:
- `binning_quantile()` - Quantile-based binning
- `binning_width()` - Equal-width binning

**Outlier Detection**:
- `flag_outliers_iqr()` - Flag outliers using IQR method
- `flag_outliers_zscore()` - Flag outliers using z-score

**Normalization**:
- `normalize_numeric()` - 4 methods: minmax, zscore, robust, log

**Statistics**:
- `compute_rolling_statistics()` - Rolling mean/sum/std
- `compute_group_statistics()` - Group-level statistics

**Advanced**:
- `generate_numeric_variants()` - Create numeric variants
- `generate_numeric_variants_advanced()` - Advanced variant generation

**Key Characteristics**:
- ✅ Focus mode support (all 24 functions)
- Handles edge cases (zero division, infinite values)
- Multiple method options (flexible configuration)
- Output: Numeric vectors/data frames

**Use Cases**:
- Feature scaling for ML models
- Creating interaction/polynomial features
- Outlier detection and handling
- Time series feature engineering (rolling stats)
- Normalization for different scales

### Module 3: Timestamp Features

**File**: `R/03_timestamp_features.R` (80 lines)

**Purpose**: Extract temporal patterns from date/time variables

**Functions** (2):
1. `extract_timestamp_features()` - Extract year/month/day/weekday from timestamps
2. `extract_year_from_string()` - Extract 4-digit year from strings

**Key Characteristics**:
- ✅ Focus mode support
- Handles various date formats
- Output: Additional temporal columns

**Use Cases**:
- Breaking down datetime into temporal components
- Extracting year values from messy text
- Seasonality and temporal pattern analysis

### Module 4: String Features

**File**: `R/04_string_features.R` (100 lines)

**Purpose**: String processing and validation

**Functions** (3):
1. `validate_ngram()` - Validate n-gram extraction parameters
2. `generate_categorical_variants()` - Generate encoding variants
3. `ensure_dataframe()` - Convert to data frame if needed

**Key Characteristics**:
- ✅ Partial focus mode support
- Type checking and validation
- Output: Data frames with variants

**Use Cases**:
- String feature validation
- Categorical encoding exploration
- Data type conversion

### Module 5: N-gram Generation

**File**: `R/05_ngram_generation.R` (250 lines)

**Purpose**: Advanced text feature extraction using n-grams

**Functions** (2):
1. `generate_ngram_char_variants()` - Character-level n-grams (4 methods: sliding, compound, split, hash)
2. `generate_ngram_word_variants()` - Word-level n-grams

**Output Structure**:
```r
list(
  sliding = list(all = data.frame, most_common = data.frame),
  compound = list(all = data.frame, most_common = data.frame),
  split = list(all = data.frame, most_common = data.frame),
  hash = list(all = data.frame, most_common = data.frame)
)
```

**Key Characteristics**:
- ✅ Focus mode support
- Multiple n-gram methods
- Highly customizable (n-value, method selection)
- Output: Expanded feature set from text

**Use Cases**:
- Text feature engineering
- Linguistic analysis
- Document classification features
- N-gram statistics

### Module 6: Position Extraction

**File**: `R/06_position_extraction.R` (150 lines)

**Purpose**: Extract position-specific patterns from text

**Functions** (3):
1. `extract_prefix_patterns()` - Extract first n-gram (prefix)
2. `extract_infix_patterns()` - Extract middle n-grams
3. `extract_suffix_patterns()` - Extract last n-gram (suffix)

**Key Characteristics**:
- ✅ Focus mode support
- Works with n-gram output
- Position-aware feature extraction
- Output: Position-specific text patterns

**Use Cases**:
- Prefix/suffix analysis (e.g., "The", "ing" patterns)
- Position importance ranking
- Structural text analysis

### Module 7: Linguistic Analysis

**File**: `R/07_linguistic_analysis.R` (400 lines)

**Purpose**: Advanced linguistic and textual analysis

**Functions** (8):
1. `extract_string_linguistic_profile()` - Extract comprehensive linguistic features
2. `compute_global_linguistic_effects()` - Compute feature effects on target
3. `compute_user_linguistic_preferences()` - Extract user-specific patterns
4. `compute_position_importance()` - Rank position importance
5. `compute_user_linguistic_compatibility()` - User compatibility measures
6. `extract_string_linguistic_profile()` - Detailed linguistic profiling
7. `linguistic_analysis()` - Main linguistic analysis function
8. `position_extraction()` - Position-based extraction

**Output Types**:
- Linguistic profiles (vector of metrics)
- Effect computations (variable importance)
- User preferences (personalization insights)
- Position importance (ranked patterns)

**Key Characteristics**:
- ✅ Focus mode support
- Advanced statistical methods
- Multi-dimensional text analysis
- Output: Metrics, profiles, rankings

**Use Cases**:
- Text-based predictive modeling
- Linguistic effect quantification
- User preference profiling
- Position-based ranking systems
- Content recommendation systems

### Module 8: Group Intelligence

**File**: `R/08_group_intelligence.R` (350 lines)

**Purpose**: Analyze group behavior and patterns in categorical data

**Functions** (9):
1. `compute_category_combinations()` - Generate category combinations
2. `compute_category_diversity()` - Measure category diversity
3. `compute_category_preferences()` - Extract category preferences
4. `compute_category_statistics()` - Category-level statistics
5. `compute_group_statistics()` - Group-level statistics
6. `count_categories()` - Count category occurrences
7. `classify_identifier_patterns()` - Pattern classification
8. `extract_primary_category()` - Extract dominant category
9. `compute_identifier_statistics()` - Identifier-level statistics

**Key Characteristics**:
- ✅ Focus mode support
- Group-based aggregation
- Pattern recognition in groups
- Output: Group-level insights

**Use Cases**:
- Customer segmentation insights
- Product category analysis
- User behavior patterns
- Classification of user types
- Group-based targeting

### Module 9: Categorical Intelligence

**File**: `R/09_categorical_intelligence.R` (300 lines)

**Purpose**: Intelligent categorical variable handling and encoding

**Functions** (7):
1. `encode_categorical_flags()` - Create one-hot encoding flags
2. `compute_category_statistics()` - Category statistics
3. `compute_category_preferences()` - Preference extraction
4. `extract_primary_category()` - Dominant category extraction
5. `classify_identifier_patterns()` - Pattern classification
6. `compute_category_diversity()` - Diversity metrics
7. `compute_category_combinations()` - Combination analysis

**Key Characteristics**:
- ✅ Focus mode support
- Multiple encoding strategies
- Pattern detection in categories
- Output: Encoded features + statistics

**Use Cases**:
- Categorical feature encoding
- Multi-class classification features
- Category dominance analysis
- Pattern-based classification

### Module 10: Dataset Inspection

**File**: `R/10_dataset_inspection.R` (200 lines)

**Purpose**: Validate and inspect datasets before processing

**Functions** (4):
1. `inspect_dataset()` - Comprehensive dataset overview
2. `validate_for_processing()` - Check if data suitable for functions
3. `preview_dataset()` - Formatted data preview
4. `check_memory_usage()` - Monitor RAM usage

**Output Types**:
- Inspection: Data frame with column info (type, class, NA count, etc.)
- Validation: Boolean + detailed report
- Preview: Formatted table display
- Memory: Data frame with size information

**Key Characteristics**:
- ✅ Focus mode support
- Type awareness (data.table, data.frame, tbl_df)
- Comprehensive validation
- Output: Reports and summaries

**Use Cases**:
- Pre-processing data validation
- Understanding data structure
- Memory optimization decisions
- Data quality checks

### Module 11: Workflow Generator

**File**: `R/11_workflow_generator.R` (300 lines)

**Purpose**: Automatically generate complete analysis workflows

**Functions** (4):
1. `detect_datasets()` - Find all datasets in memory
2. `show_dataset_columns()` - Display column info
3. `generate_workflow_interactive()` - Interactive workflow builder
4. `generate_workflow_script()` - Auto-generate R script

**Workflow Generation**:
- Detects datasets automatically
- Interactive menu for user selection
- Generates complete, runnable R code
- Saves timestamped script files

**Key Characteristics**:
- ✅ Focus mode support
- Interactive menu system
- No manual coding required
- Output: Complete R workflow scripts

**Use Cases**:
- Rapid prototyping
- Learning by example
- Workflow automation
- Non-programmer data analysis

### Package Initialization

**File**: `R/zzz.R` (61 lines)

**Purpose**: Package initialization and conflict resolution

**Key Functions**:
- `.onLoad()` - Executed on `library(DataPreparation)`
- 14 `conflict_prefer()` calls for library conflicts

**Conflicts Resolved**:
- dplyr: filter, select, mutate, summarise, group_by, rename, arrange, distinct
- zoo: lag, lead
- base: intersect, setdiff, union

**Execution**: Automatic - no user action required

## Focus Mode System

### Three Usage Patterns

**Pattern 1: Explicit Data (Always Works)**
```r
result <- normalize_numeric(movies, "rating")
```

**Pattern 2: Dataset Name (Recommended)**
```r
result <- normalize_numeric(dataset_name = "movies", column = "rating")
```

**Pattern 3: Implicit Focus (Most Convenient)**
```r
focus_dataset("movies")
result <- normalize_numeric("rating")
```

### Implementation Details

- Enabled in 49 of 81 functions (60.5%)
- Smart parameter resolution via `resolve_data_source()`
- Backward compatible - all existing code works
- No breaking changes to existing APIs

## Library Dependency Map

### Core Dependencies

```
DataPreparation
├── dplyr (data manipulation)
│   ├── filter, select, mutate, summarise, group_by
│   ├── rename, arrange, distinct
│   └── joins: left_join, inner_join
├── tidyr (data reshaping)
│   ├── pivot_wider, pivot_longer
│   └── separate_rows, unnest
├── purrr (functional programming)
│   ├── map, map_df, map_lgl, map_int, map_dbl, map_chr
│   ├── reduce, accumulate
│   └── filter, discard
├── zoo (time series)
│   ├── lag, lead, rollmean, rollsum
│   └── time series utilities
├── rlang (meta-programming)
│   ├── quo, enquo, !! (quasiquotation)
│   └── expr manipulation
├── stringr (string operations)
│   ├── str_extract, str_replace, str_split
│   └── str_length, str_trim
└── tibble (modern data frames)
    ├── tibble, as_tibble
    └── data frame utilities
```

### Conflict Resolution

**Managed Conflicts**:
- `filter()`: dplyr vs purrr
- `select()`: dplyr vs datasets
- `mutate()`: dplyr vs base
- `summarise()`: dplyr and aggregate
- `group_by()`: dplyr and plyr
- `lag()`, `lead()`: dplyr vs zoo
- `arrange()`: dplyr vs stats
- `distinct()`: dplyr and base
- `intersect()`, `setdiff()`, `union()`: dplyr vs base

**Resolution Strategy**: At package load time, `conflicted::conflict_prefer()` explicitly specifies which version to use for each conflicted function.

## Development Workflow

### Adding a New Function

1. **Create function in appropriate module** (R/XX_module.R)
2. **Add roxygen2 documentation**:
   ```r
   #' Function Title
   #' 
   #' @param data (optional) The input data frame
   #' @param dataset_name (optional) Name of registered dataset
   #' ...
   #' @export
   ```
3. **If data-dependent**: Add focus mode support
   ```r
   data_source <- resolve_data_source(data, dataset_name)
   data <- data_source$data
   ```
4. **Test backward compatibility**
5. **Run `roxygen2::roxygenise()`** to rebuild documentation
6. **Update README and DOCUMENTATION_STRATEGY.md**

### Building and Documentation

```r
# Rebuild documentation
roxygen2::roxygenise()

# Run tests
devtools::test()

# Check package
devtools::check()

# Load package
devtools::load_all()
```

## File Organization Best Practices

### Current Structure (Stable)
```
R/
  00_dataset_registry.R      # Core infrastructure
  01-11_modules.R            # Functional modules
  zzz.R                      # Package initialization

man/
  *.Rd                       # Auto-generated from roxygen2

documentation/
  CODE_STRUCTURE.md          # This file
  DOCUMENTATION_STRATEGY.md  # Master organization plan
  guides/                    # Feature guides
  startup-cores/             # Domain-specific docs
  project-status/            # Status reports
```

### Adding New Documentation

1. Place feature guides in `documentation/guides/`
2. Place architecture docs in `documentation/`
3. Ensure .Rd files are auto-generated (don't edit manually)
4. Update README when adding major features

## Testing Strategy

### Test Organization
- Module tests: `tests/testthat/test_XX_module.R`
- Integration tests: `tests/testthat/test_integration.R`
- Conflict tests: `tests/testthat/test_conflicts.R`
- Focus mode tests: `tests/testthat/test_focus_mode.R`

### Test Coverage
- All exported functions should have test cases
- Focus mode tested for data-dependent functions
- Edge cases (NA, empty data, NULL) tested
- Performance tests for large datasets

## Version History

### v1.2.0 (Current Development)
- ✅ 49 functions with focus mode support
- ✅ Conflict resolution system (R/zzz.R)
- ✅ Dataset registry system (R/00_dataset_registry.R)
- ✅ Complete documentation structure

### v1.1.0 (Previous)
- 81 total functions
- 9 functional modules
- Memory management module
- Initial documentation structure

## Quick Reference

### Function Count by Module
- Module 00: 7 registry functions
- Module 01: 4 NA handling functions
- Module 02: 24 numeric feature functions
- Module 03: 2 timestamp functions
- Module 04: 3 string feature functions
- Module 05: 2 n-gram functions
- Module 06: 3 position extraction functions
- Module 07: 8 linguistic analysis functions
- Module 08: 9 group intelligence functions
- Module 09: 7 categorical intelligence functions
- Module 10: 4 inspection functions
- Module 11: 4 workflow generator functions
- **Total**: 81 functions

### Documentation Files
- 81 .Rd files (auto-generated)
- README.md (main documentation)
- CODE_STRUCTURE.md (this file)
- DOCUMENTATION_STRATEGY.md (organization plan)
- 16+ feature guides in documentation/guides/
- 4+ domain startup guides in documentation/startup-cores/

## See Also

- [README.md](../../README.md) - Main package documentation
- [DOCUMENTATION_STRATEGY.md](DOCUMENTATION_STRATEGY.md) - Documentation organization plan
- [DOCUMENTATION_MAP.md](../../DOCUMENTATION_MAP.md) - Navigation reference
- [startup-cores/](startup-cores/) - Domain-specific implementation guides
