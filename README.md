# DataPreparation

A comprehensive, modular R package for data preparation and feature engineering. This package provides 50+ general-purpose functions organized into 7 logical modules, enabling reuse across different projects and datasets.

## ✨ Features

### 📦¦ Module 1: NA Handling
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

### 📊 Module 8: Dataset Inspection
Inspect and validate datasets before processing:
- `inspect_dataset()` - Get comprehensive dataset overview
- `validate_for_processing()` - Check if data is suitable for functions
- `preview_dataset()` - Display formatted data preview
- `check_memory_usage()` - Monitor memory usage of datasets

### ⚙️– Module 9: Automatic Workflow Generator
Generate complete analysis workflows without manual coding:
- `detect_datasets()` - Automatically find all datasets in memory
- `show_dataset_columns()` - Display column names and types
- `generate_workflow_interactive()` - Interactive menu-driven workflow generator
- `generate_workflow_script()` - Auto-generate complete R workflow code

**Key Benefit**: No more hardcoding column names! The generator:
âœ… Detects datasets and columns automatically
âœ… Shows interactive menus for selection
âœ… Generates complete, ready-to-run workflow scripts
âœ… Works with ANY dataset (movies, cancer data, products, custom data)
âœ… Saves timestamped script files for reproducibility

## � Getting Started: Choose Your Learning Path

**New to DataPreparation?** Explore our **Startup Cores** documentation:
### 📁 What are "Startup Cores"?

**Startup Cores** represents the foundational infrastructure for data preparation and analysis. Think of it as the **essential building blocks** that serve two key purposes:

1. **As Industry Foundation**: Use as the **core foundation** within your industry - providing standardized patterns and frameworks that your organization builds upon
2. **As Infrastructure Layer**: Deploy as the **infrastructure backbone** supporting multiple teams and projects - enabling consistent, reusable data pipelines across your organization

Whether you're implementing for a single team or deploying as an enterprise-wide infrastructure, Startup Cores provides domain-specific guidance tailored to your use case.
### 📁 [startup-cores/](documentation/startup-cores/) - Domain-Specific Implementation Guides

We've created comprehensive startup guides for different industries:

- **🏥 [Medical & Healthcare](documentation/startup-cores/sectors/medical/README.md)** - Patient analysis, treatment outcomes, disease patterns ([full guide](documentation/startup-cores/sectors/medical/STARTUP_GUIDE.md))
- **🎬 [Entertainment & Cinema](documentation/startup-cores/sectors/entertainment/README.md)** - Recommendation systems, audience analysis, content strategy ([full guide](documentation/startup-cores/sectors/entertainment/STARTUP_GUIDE.md))
- **💼 [Business & Finance](documentation/startup-cores/sectors/business-finance/README.md)** - Customer segmentation, financial analysis, risk management ([full guide](documentation/startup-cores/sectors/business-finance/STARTUP_GUIDE.md))
- **🤖 [Artificial Intelligence & ML](documentation/startup-cores/sectors/artificial-intelligence/README.md)** - Feature engineering, ML pipelines, intelligence extraction ([full guide](documentation/startup-cores/sectors/artificial-intelligence/STARTUP_GUIDE.md))
- **🏗️ [Universal Framework](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md)** - Foundational concepts that apply to ALL domains

Each domain guide includes:
- ✅ Real-world examples tailored to your industry
- ✅ Complete code snippets ready to use
- ✅ Domain-specific patterns and best practices
- ✅ Step-by-step implementation guide
- ✅ Quick start sections (5 minutes to first results)
- ✅ References to universal framework docs

**Core Foundation** (Universal Concepts):
- [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) - Why universal patterns exist
- [PHILOSOPHY_MEETS_SCIENCE.md](documentation/startup-cores/core-foundation/PHILOSOPHY_MEETS_SCIENCE.md) - Theory to implementation
- [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md) - All 67 functions reference

**Choose a starting point:**
1. **By Industry**: Medical | Entertainment | AI/ML (links above)
2. **By Experience**: Beginner → [Your sector] | Experienced → [Core foundation] | Executive → [Philosophy + Sector]
3. **By Time**: Quick start (5 min) | Full guide (2 hrs) | Deep dive (8+ hrs)

👉 **See [startup-cores/README.md](documentation/startup-cores/README.md) for complete navigation, learning paths, success criteria, and FAQ.**

---

## �📦¦ Installation

### Install from GitHub:
```r
# Install devtools if needed
install.packages("devtools")

# Install DataPreparation
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

### 🔃Load the package:
```r
library(DataPreparation)
```
---

## 🏗️ Code Structure & Architecture

### Package Organization

The DataPreparation package is organized into **9 functional modules**, each addressing specific data preparation challenges:

#### **Module 1: NA Handling (4 functions)**
- Functions: `remove_na_columns()`, `impute_na_numeric()`, `flag_na_column()`, `summarize_na_rows()`
- Purpose: Manage missing values intelligently
- Use when: Dataset contains NA/missing values

#### **Module 2: Numeric Features (24 functions)**
- Functions: Scaling, transformations, polynomial features, binning, outlier detection, normalization
- Purpose: Engineer and transform numeric variables
- Use when: Working with quantitative data (sales, measurements, metrics)

#### **Module 3: Timestamp Features (2 functions)**
- Functions: `extract_timestamp_features()`, `extract_year_from_string()`
- Purpose: Extract temporal patterns from dates/times
- Use when: Data contains date/time variables

#### **Module 4: String Features (3 functions)**
- Functions: String processing, validation, variant generation
- Purpose: Prepare and validate string-based features
- Use when: Working with categorical or text data

#### **Module 5: N-gram Generation (2 functions)**
- Functions: `generate_ngram_char_variants()`, `generate_ngram_word_variants()`
- Purpose: Generate linguistic features from text
- Use when: Analyzing text content (titles, descriptions, reviews)

#### **Module 6: Position Extraction (3 functions)**
- Functions: `extract_prefix_patterns()`, `extract_infix_patterns()`, `extract_suffix_patterns()`
- Purpose: Extract position-specific patterns from text
- Use when: Pattern location matters (e.g., prefix analysis, suffix extraction)

#### **Module 7: Linguistic Analysis (8 functions)**
- Functions: Linguistic profiling, effect computation, preference extraction, position importance
- Purpose: Advanced linguistic and textual analysis
- Use when: Performing NLP or text-based intelligence extraction

#### **Module 8: Group Intelligence (9 functions)**
- Functions: Category combinations, diversity, preferences, statistics, deviations
- Purpose: Analyze group behavior and patterns
- Use when: Working with categorical data and group-level insights

#### **Module 9: Categorical Intelligence (7 functions)**
- Functions: Category classification, encoding, pattern detection
- Purpose: Intelligent categorical variable handling
- Use when: Processing categorical features and encodings

#### **Module 10: Dataset Inspection (4 functions)**
- Functions: `inspect_dataset()`, `validate_for_processing()`, `preview_dataset()`, `check_memory_usage()`
- Purpose: Validate and inspect data before processing
- Use when: Starting data preparation workflow

#### **Module 11: Automatic Workflow Generator (4 functions)**
- Functions: `detect_datasets()`, `show_dataset_columns()`, `generate_workflow_interactive()`, `generate_workflow_script()`
- Purpose: Auto-generate complete analysis workflows
- Use when: No manual coding desired - let the system generate workflows

### File Structure

```
R/
  00_dataset_registry.R      # Dataset management & focus mode
  01_na_handling.R           # NA/missing value functions
  02_numeric_features.R      # Numeric transformation & engineering
  03_timestamp_features.R    # Date/time extraction
  04_string_features.R       # String processing
  05_ngram_generation.R      # N-gram creation
  06_position_extraction.R   # Prefix/infix/suffix extraction
  07_linguistic_analysis.R   # Advanced text analysis
  08_group_intelligence.R    # Category analysis
  09_categorical_intelligence.R # Categorical encoding
  10_dataset_inspection.R    # Dataset validation
  11_workflow_generator.R    # Auto workflow generation
  zzz.R                      # Package initialization & conflict resolution

man/
  *.Rd                       # Auto-generated roxygen documentation

documentation/
  startup-cores/             # Domain-specific implementation guides
  guides/                    # Feature guides and tutorials
  project-status/            # Status reports and changelogs
```

### Key Features

#### **🎯 Dataset Registry System**
Work with multiple datasets in memory with intelligent focus management:

```r
library(DataPreparation)

# Register datasets
movies <- data.frame(id = 1:3, title = c("Matrix", "Inception", "Interstellar"))
register_dataset(movies, "movies")

# Set focus on specific dataset
focus_dataset("movies")

# Use functions without specifying data parameter
head(movies)  # Functions automatically use focused dataset
```

**Benefits:**
- ✅ Work with multiple datasets seamlessly
- ✅ No need to pass `data` parameter every time
- ✅ Automatic parameter resolution (explicit → focus → implicit)
- ✅ Backward compatible (functions still work with explicit data parameter)

#### **🔄 Focus Mode System**
Three ways to use DataPreparation functions:

**Option 1: Explicit Data Parameter (Always Works)**
```r
result <- normalize_numeric(movies, "rating")
```

**Option 2: Dataset Name Parameter (Recommended)**
```r
result <- normalize_numeric(dataset_name = "movies", column = "rating")
```

**Option 3: Implicit Focus (Most Convenient)**
```r
focus_dataset("movies")
result <- normalize_numeric("rating")  # Automatically uses focused dataset
```

#### **⚡ Conflict Resolution**
The package automatically manages function name conflicts between libraries. No action needed - conflicts are resolved at load time:

```r
library(DataPreparation)  # Automatically resolves conflicts

# These work correctly regardless of load order
movies <- data.frame(id = 1:3, rating = c(8.7, 8.8, 8.6))
filtered <- dplyr::filter(movies, rating > 8.5)
```

**Resolved Conflicts**: filter, select, mutate, summarise, group_by, rename, arrange, distinct, lag, lead, intersect, setdiff, union

#### **📊 Memory Management**
Monitor and optimize RAM usage for large datasets:

```r
# Check memory usage
memory_summary <- get_memory_summary()

# Remove datasets to free memory
drop_dataset('old_data')
drop_by_pattern('temp_.*')  # Remove all temp_* datasets
```

### Workflow Examples

See complete workflow examples:
- **Basic Workflow**: [EXAMPLE_WORKFLOW.R](EXAMPLE_WORKFLOW.R)
- **Medical Domain**: [EXAMPLE_CANCER_WORKFLOW.R](EXAMPLE_CANCER_WORKFLOW.R)
- **Interactive Generator**: Use `generate_workflow_interactive()` in R console

---
## ▶️ Quick Start

### Example 0: Automatic Workflow Generation (NEW!)
```r
# The easy way: Let the generator do everything!
library(DataPreparation)

# Load multiple datasets
movies <- data.frame(movieId = 1:3, title = c("Matrix", "Inception", "Interstellar"), rating = c(8.7, 8.8, 8.6))
cancer <- data.frame(patientId = 101:103, diagnosis = c("Breast", "Lung", "Colon"), survival = c(48, 12, 72))
products <- data.frame(productId = 1:2, description = c("Laptop Computer", "Wireless Mouse"), sales = c(500, 150))

# Discover what datasets you have
detect_datasets()
# Output: Found 3 datasets: movies, cancer, products

# Interactive workflow generation
generate_workflow_interactive()
# Follow the menu:
# 1. Choose dataset: cancer
# 2. Choose string column: diagnosis
# 3. Choose target column: survival
# 4. Choose analysis type: Full Analysis
# Generated: workflow_cancer_20260105_140530.R

# Run the generated workflow
source("workflow_cancer_20260105_140530.R")
# Complete analysis runs automatically!
```

See [documentation/guides/WORKFLOW_GENERATOR_GUIDE.md](documentation/guides/WORKFLOW_GENERATOR_GUIDE.md) for more details and examples.

### Example 1: Inspect Your Dataset First
```r
# Before processing, understand the data
library(DataPreparation)

movies <- data.frame(
  movieId = 1:3,
  title = c("The Matrix", "Inception", "Interstellar"),
  rating = c(8.7, 8.8, 8.6)
)

# Inspect the dataset
inspect_dataset(movies)

# Check if data is suitable for processing
validate_for_processing(
  data = movies,
  string_cols = "title",
  id_col = "movieId"
)

# Preview the data
preview_dataset(movies)
```

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

### Example 3: Extract N-grams & Suffix/Prefix Patterns
```r
titles <- data.frame(movieId = 1:3, title = c("The Matrix", "Inception", "Interstellar"))

# Generate n-grams
ngrams <- generate_ngram_char_variants(titles, "title", 2, 3)

# Extract suffix (last n-gram per movie)
suffixes <- extract_suffix_patterns(ngrams$sliding$all, id_col = "movieId")

# Extract prefix (first n-gram per movie)
prefixes <- extract_prefix_patterns(ngrams$sliding$all, id_col = "movieId")
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

## 📄 Documentation

Each function includes detailed documentation. Access it in R:
```r
?function_name                          # View specific function
help(package = "DataPreparation")       # View package overview
```

## 🖇️ Dependencies

- **dplyr** - Data manipulation
- **tidyr** - Data reshaping
- **stringr** - String operations
- **purrr** - Functional programming
- **zoo** - Rolling statistics
- **rlang** - Meta-programming
- **tibble** - Modern data frames

## 🎨¯ Design Philosophy

- **Modular**: Functions organized into 7 logical modules for easy navigation
- **Reusable**: General-purpose functions work across different datasets
- **Well-documented**: Comprehensive documentation for all 50+ functions
- **Consistent API**: Predictable function names and parameter conventions
- **Dynamic**: Linguistic analysis functions discover patterns automatically

## 🪪 License

MIT License - See LICENSE file for details

## 🥮 Author

AARICHE ABDERRAHIM

## 👮– Citation

If you use this package in your research, please cite:

```bibtex
@software{abderrahim2025datapreparation,
  author = {Abderrahim, Aariche},
  title = {DataPreparation: General-Purpose Data Preparation and Feature Engineering Library},
  year = {2025},
  url = {https://github.com/aabderrahimaariche-hue/DataPreparation}
}
```

## ⛓️ Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 💁‍♂️ Support

For issues, questions, or suggestions, please open an issue on [GitHub](https://github.com/aabderrahimaariche-hue/DataPreparation/issues).

---

## 📚 Complete Documentation Map

### 🚀 Getting Started (START HERE)
- **[startup-cores/README.md](documentation/startup-cores/README.md)** - Navigation hub for all learning paths
- **[Medical Sector README](documentation/startup-cores/sectors/medical/README.md)** - 15 min overview
- **[Medical Sector STARTUP_GUIDE](documentation/startup-cores/sectors/medical/STARTUP_GUIDE.md)** - 2 hours implementation
- **[Entertainment Sector README](documentation/startup-cores/sectors/entertainment/README.md)** - 15 min overview
- **[Entertainment Sector STARTUP_GUIDE](documentation/startup-cores/sectors/entertainment/STARTUP_GUIDE.md)** - 2 hours implementation
- **[Business & Finance README](documentation/startup-cores/sectors/business-finance/README.md)** - 15 min overview
- **[Business & Finance STARTUP_GUIDE](documentation/startup-cores/sectors/business-finance/STARTUP_GUIDE.md)** - 2-3 hours implementation
- **[AI/ML Sector README](documentation/startup-cores/sectors/artificial-intelligence/README.md)** - 15 min overview
- **[AI/ML Sector STARTUP_GUIDE](documentation/startup-cores/sectors/artificial-intelligence/STARTUP_GUIDE.md)** - 3 hours implementation

### 📖 Core Theory & Reference
- **[core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md)** - Why universal patterns work across domains
- **[core-foundation/PHILOSOPHY_MEETS_SCIENCE.md](documentation/startup-cores/core-foundation/PHILOSOPHY_MEETS_SCIENCE.md)** - Mathematical foundations
- **[core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md)** - All 67 functions with signatures

### 📋 Workflow Guides
- **[guides/INDEX.md](documentation/guides/INDEX.md)** - Complete guides navigation and index (START HERE for workflow docs)
- **[guides/](documentation/guides/)** - 16 comprehensive workflow tutorials and advanced guides
- **[WORKFLOW_GENERATOR_GUIDE.md](WORKFLOW_GENERATOR_GUIDE.md)** - Auto-generate analysis workflows
- **[EXAMPLE_WORKFLOW.R](EXAMPLE_WORKFLOW.R)** - Working code example
- **[EXAMPLE_CANCER_WORKFLOW.R](EXAMPLE_CANCER_WORKFLOW.R)** - Medical domain example

### 📊 Project Status & Information
- **[project-status/PROJECT_STATUS.md](documentation/project-status/PROJECT_STATUS.md)** - Complete project status report
- **[project-status/NEWS.md](documentation/project-status/NEWS.md)** - Release notes and changelog
- **[DESCRIPTION](DESCRIPTION)** - Package metadata
- **[NAMESPACE](NAMESPACE)** - Exported functions list

### 🎯 Quick Reference by Role

**Healthcare Professionals**
1. [Medical Sector README](documentation/startup-cores/sectors/medical/README.md) - 15 min overview
2. [Medical STARTUP_GUIDE](documentation/startup-cores/sectors/medical/STARTUP_GUIDE.md) - 2 hrs comprehensive guide
3. [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md) - Function reference

**Business & Finance Professionals**
1. [Business & Finance README](documentation/startup-cores/sectors/business-finance/README.md) - 15 min overview
2. [Business & Finance STARTUP_GUIDE](documentation/startup-cores/sectors/business-finance/STARTUP_GUIDE.md) - 2-3 hrs comprehensive
3. [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md) - Function reference

**Entertainment Professionals**
1. [Entertainment Sector README](documentation/startup-cores/sectors/entertainment/README.md) - 15 min overview
2. [Entertainment STARTUP_GUIDE](documentation/startup-cores/sectors/entertainment/STARTUP_GUIDE.md) - 2 hrs comprehensive
3. [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md) - Function reference

**ML Engineers**
1. [AI/ML Sector README](documentation/startup-cores/sectors/artificial-intelligence/README.md) - 15 min overview
2. [AI/ML STARTUP_GUIDE](documentation/startup-cores/sectors/artificial-intelligence/STARTUP_GUIDE.md) - Complete ML integration
3. [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) - Conceptual foundations
4. [guides/](documentation/guides/) - Workflow examples

**Data Scientists**
1. Your [sector guide](documentation/startup-cores/sectors/) - Industry-specific examples
2. [guides/](documentation/guides/) - Workflow tutorials
3. [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md) - Function reference
4. [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) - Theory

**Executives/Decision Makers**
1. [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) - Business case and scalability (30 min)
2. Your [sector STARTUP_GUIDE](documentation/startup-cores/sectors/) - Real-world examples
3. [PROJECT_STATUS](documentation/project-status/PROJECT_STATUS.md) - Features and completeness

**Students/Researchers**
1. [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) - Theory first
2. [PHILOSOPHY_MEETS_SCIENCE](documentation/startup-cores/core-foundation/PHILOSOPHY_MEETS_SCIENCE.md) - Mathematical foundations
3. [Sector STARTUP_GUIDE](documentation/startup-cores/sectors/) - Practical application
4. [guides/](documentation/guides/) - Advanced patterns

### 🔍 Discovery Index

**By Topic**:
- Intelligence/Readables/Writables framework → [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md)
- Function reference (all 67) → [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md)
- Workflow examples → [guides/](documentation/guides/)
- Medical applications → [Medical STARTUP_GUIDE](documentation/startup-cores/sectors/medical/STARTUP_GUIDE.md)
- Entertainment applications → [Entertainment STARTUP_GUIDE](documentation/startup-cores/sectors/entertainment/STARTUP_GUIDE.md)
- Business & Finance applications → [Business & Finance STARTUP_GUIDE](documentation/startup-cores/sectors/business-finance/STARTUP_GUIDE.md)
- AI/ML integration → [AI/ML STARTUP_GUIDE](documentation/startup-cores/sectors/artificial-intelligence/STARTUP_GUIDE.md)
- Project status → [PROJECT_STATUS](documentation/project-status/PROJECT_STATUS.md)

**By Learning Time**:
- 5 minutes → Quick Start in any sector README
- 30 minutes → UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY
- 2 hours → Full sector STARTUP_GUIDE
- 8+ hours → Complete mastery with all core-foundation docs + sector guides + guides/

### 🆘 Finding What You Need

**"I want to learn the framework"**
→ [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md)

**"I want to get started immediately"**
→ Your [sector README Quick Start](documentation/startup-cores/sectors/) section

**"I want complete implementation examples"**
→ Your [sector STARTUP_GUIDE](documentation/startup-cores/sectors/)

**"I need a function reference"**
→ [PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE](documentation/startup-cores/core-foundation/PROFESSIONAL_SCALABLE_TOOLKIT_GUIDE.md)

**"I want workflow examples"**
→ [guides/](documentation/guides/) folder

**"I want to build a machine learning model"**
→ [AI/ML STARTUP_GUIDE](documentation/startup-cores/sectors/artificial-intelligence/STARTUP_GUIDE.md)

**"I want to evaluate DataPreparation for my organization"**
→ [UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY](documentation/startup-cores/core-foundation/UNIVERSAL_INFRASTRUCTURE_PHILOSOPHY.md) + [PROJECT_STATUS](documentation/project-status/PROJECT_STATUS.md)

## Memory Management Module (v1.1.0)

Optimize RAM usage when working with large datasets. Particularly useful for machine learning workflows with big data.

### Functions

- **get_dataset_size()** - Check memory usage of datasets
- **drop_dataset()** - Remove single dataset and free memory
- **drop_datasets()** - Remove multiple datasets at once
- **drop_if_exists()** - Safe removal (no error if missing)
- **drop_by_pattern()** - Remove datasets matching regex pattern
- **get_memory_summary()** - View all memory usage in formatted table
- **workflow_extract_drop()** - Automated load  extract  drop pattern

### Quick Start

@"
# Check which datasets use the most RAM
summary <- get_memory_summary()

# Remove a large dataset
drop_dataset('raw_data')

# Clean up temporary data
drop_if_exists(c('temp1', 'temp2', 'temp3'))
@

See [documentation/project-status/NEWS.md](documentation/project-status/NEWS.md) for version 1.1.0 details.

