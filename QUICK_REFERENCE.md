# DataPreparation - Quick Reference Guide

## ⚡ Super Quick Start (2 minutes)

```r
# 1. Install
devtools::install_github("aabderrahimaariche-hue/DataPreparation")

# 2. Load
library(DataPreparation)

# 3. Load your data
my_data <- read.csv("mydata.csv")

# 4. Generate workflow automatically
generate_workflow_interactive()

# 5. Follow the menu, get your analysis!
```

**That's it!** The workflow generator does the rest automatically. ✨

---

## 🎯 What Each Module Does

### Module 1: NA Handling
**When**: You have missing data
```r
cleaned <- remove_na_columns(data, "column_name")
flagged <- flag_na_column(data, "column_name")
```

### Module 2: Numeric Features
**When**: You need to engineer numeric variables
```r
scaled <- scale_betweenRange(data, "numeric_col")
poly <- create_polynomial_features(data, "numeric_col")
outliers <- flag_outliers_iqr(data, "numeric_col")
```

### Module 3: Timestamp Features
**When**: You need to extract time patterns
```r
features <- extract_timestamp_features(data, "date_col")
years <- extract_year_from_string(data, "text_col")
```

### Module 4: String Features
**When**: You need string validation
```r
validate_ngram(data, "text_col", 2)
```

### Module 5: N-gram Generation
**When**: You need text features
```r
ngrams <- generate_ngram_char_variants(data, "text_col", 2, 3)
```

### Module 6: Position Extraction
**When**: You want first/middle/last patterns
```r
first <- extract_prefix_patterns(ngrams$sliding$all, "id_col")
last <- extract_suffix_patterns(ngrams$sliding$all, "id_col")
```

### Module 7: Linguistic Analysis
**When**: You need advanced text features
```r
profile <- extract_string_linguistic_profile(data, "text_col", "id_col")
effects <- compute_global_linguistic_effects(data, "text_col", "target_col")
```

### Module 8: Dataset Inspection
**When**: You need to understand data before processing
```r
inspect_dataset(data)
validate_for_processing(data, string_cols = "text_col")
preview_dataset(data)
check_memory_usage()
```

### Module 9: Workflow Generator ⭐ (NEW!)
**When**: You want automatic analysis
```r
detect_datasets()              # See what data you have
show_dataset_columns("data")   # See column names
generate_workflow_interactive()  # Generate workflow automatically!
```

---

## 📊 Common Workflows

### Example 1: Analyze Movie Ratings
```r
library(DataPreparation)

movies <- read.csv("movies.csv")
# Columns: movieId, title, genre, year, rating, revenue

# Automatic approach
generate_workflow_interactive()
# → Select: movies dataset
# → Select: title (text), rating (target)
# → Select: Full Analysis
# → Get complete 10-step workflow!
```

### Example 2: Analyze Cancer Survival
```r
library(DataPreparation)

cancer <- read.csv("cancer.csv")
# Columns: patientId, diagnosis, age, stage, survival_months

# Automatic approach
generate_workflow_interactive()
# → Select: cancer dataset
# → Select: diagnosis (text), survival_months (target)
# → Select: Full Analysis
# → Get complete workflow!
```

### Example 3: Analyze E-commerce Sales
```r
library(DataPreparation)

products <- read.csv("products.csv")
# Columns: productId, description, category, price, sales

# Automatic approach
generate_workflow_interactive()
# → Select: products dataset
# → Select: description (text), sales (target)
# → Select: Full Analysis
# → Get complete workflow!
```

---

## 🔍 How Workflow Generator Works

```
generate_workflow_interactive()
    ↓
Step 1: Select dataset from those in memory
    ↓
Step 2: Select string column (text to analyze)
    ↓
Step 3: Select numeric column (outcome to predict)
    ↓
Step 4: Select ID column (row identifier)
    ↓
Step 5: Select analysis type (Full, N-gram only, Linguistic, Effects, etc.)
    ↓
✓ Workflow generated: workflow_[name]_[timestamp].R
✓ Ready to run: source("workflow_...")
```

**Key Benefit**: No column name typing! Auto-detected from your data.

---

## 💡 Pro Tips

### Tip 1: Explore First
```r
# Before generating workflow, understand data
inspect_dataset(my_data)
preview_dataset(my_data)
check_memory_usage()
```

### Tip 2: Generate Multiple Workflows
```r
# Try different analysis types
generate_workflow_interactive()  # First: Full Analysis
# Later...
generate_workflow_interactive()  # Second: Position-based
# Compare results!
```

### Tip 3: Batch Processing
```r
# Detect all datasets
detect_datasets()

# Generate for each
datasets <- detect_datasets(verbose = FALSE)
for (i in 1:nrow(datasets)) {
  ds_name <- datasets$Dataset[i]
  data <- get(ds_name)
  # Auto-identify columns and generate...
}
```

### Tip 4: Reproducibility
```r
# Generated workflows are timestamped
# workflow_movies_20260105_140530.R

# Source anytime to reproduce
source("workflow_movies_20260105_140530.R")
```

---

## ❓ FAQ

**Q: Do I need to know R to use this?**
A: No! The workflow generator guides you through menus. Generated code runs automatically.

**Q: Can I use my own data?**
A: Yes! Load any CSV with text columns and numeric outcomes. Generator auto-detects.

**Q: Does it work for different data types?**
A: Yes! Movies, cancer data, products, sports, finance, any text + numeric outcome.

**Q: What if my column names are different?**
A: No problem! Generator discovers your actual column names automatically.

**Q: Can I modify generated workflows?**
A: Yes! Generated code is readable R code you can edit or adapt.

**Q: How fast is it?**
A: 2-5 minutes from data to complete analysis. Beats 30+ minutes of manual coding!

---

## 🚀 Installation Steps

### Step 1: Install devtools (if needed)
```r
install.packages("devtools")
```

### Step 2: Install DataPreparation
```r
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
```

### Step 3: Load package
```r
library(DataPreparation)
```

### Step 4: Start using!
```r
# Option A: Auto-generate (recommended for most users)
generate_workflow_interactive()

# Option B: Direct function calls (advanced users)
ngrams <- generate_ngram_char_variants(data, "text_col")
effects <- compute_global_linguistic_effects(data, "text_col", "target")
```

---

## 📖 Detailed Documentation

For more information:
- **README.md** - Package overview and features
- **WORKFLOW_GENERATOR_GUIDE.md** - Complete workflow generator documentation
- **MODULE_9_COMPLETION_SUMMARY.md** - Technical details
- **EXAMPLE_WORKFLOW.R** - Movie analysis example
- **EXAMPLE_CANCER_WORKFLOW.R** - Healthcare example
- **FINAL_STATUS_REPORT.md** - Comprehensive project summary

---

## 🎯 Recommended Learning Path

1. **Start Here**: Run quick example in README.md
2. **Explore**: `inspect_dataset()` on your data
3. **Generate**: Use `generate_workflow_interactive()`
4. **Learn**: Read through generated workflow code
5. **Adapt**: Modify for your specific needs
6. **Master**: Read detailed module documentation

---

## 🔗 Quick Links

- 📦 Package: https://github.com/aabderrahimaariche-hue/DataPreparation
- 📚 Complete Guide: WORKFLOW_GENERATOR_GUIDE.md
- 🎓 Examples: EXAMPLE_WORKFLOW.R, EXAMPLE_CANCER_WORKFLOW.R
- 💻 Demo: WORKFLOW_GENERATOR_DEMO.R
- 📋 License: MIT (open source, use freely)

---

## 🎉 Start Now!

```r
# Copy-paste to get started:
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
library(DataPreparation)
my_data <- read.csv("your_data.csv")
generate_workflow_interactive()
```

**That's it! Enjoy! ✨**

---

*For issues, questions, or suggestions, visit: https://github.com/aabderrahimaariche-hue/DataPreparation/issues*
