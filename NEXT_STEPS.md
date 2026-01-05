# Next Steps: Using the DataPreparation Package

## 🚀 Getting Started

Your DataPreparation R package is now complete and ready to use. Here's how to proceed:

## Step 1: Generate NAMESPACE (Important!)

The roxygen2 documentation in your code generates the NAMESPACE file automatically:

```r
# In R console, in your workspace directory:
devtools::document("DataPreparation")
```

This will:
- Parse all @export tags
- Generate NAMESPACE file
- Create man/ folder with .Rd files
- Make all your functions discoverable

## Step 2: Load the Package

**Option A: Development Mode (Recommended for now)**
```r
# Load all functions without installing
devtools::load_all("DataPreparation")

# Now all 50+ functions are available:
?na_handling
?numeric_features
head(list_all_functions())
```

**Option B: Install Locally**
```r
# Install in your R library
devtools::install("DataPreparation")

# Then load normally
library(DataPreparation)
```

## Step 3: Update Your Main Code

In your `data_prepare.R` file, replace:

```r
# OLD:
source("src/data_prepare_functions.R")

# NEW (if using local installation):
library(DataPreparation)

# OR (if still in development):
devtools::load_all("DataPreparation")
```

## Step 4: Test Everything Works

```r
# Load the package
library(DataPreparation)  # or devtools::load_all()

# Test a few functions to verify:

# Test 1: NA handling
test_data <- data.frame(x = c(1, 2, NA, 4), y = c(5, NA, 7, 8))
cleaned <- remove_na_columns(test_data, c("x", "y"))

# Test 2: Numeric features
scaled <- scale_betweenRange(mtcars, "mpg")
poly <- create_polynomial_features(mtcars, "mpg")

# Test 3: N-gram generation
text_data <- data.frame(title = c("The Matrix", "Inception"))
ngrams <- generate_ngram_char_variants(text_data, "title", 2, 3)

# Test 4: Linguistic analysis
movies <- data.frame(
  movieId = 1:3,
  title = c("The Matrix", "The Dark Knight", "Inception"),
  rating = c(8.7, 9.0, 8.8)
)
profile <- extract_string_linguistic_profile(movies, "title", "movieId")

# If all these work → ✅ Package is ready!
```

## Step 5: Publishing Options

### Option A: GitHub + Zenodo (Recommended for Academic Work)

```bash
# 1. Create GitHub repo
#    Go to github.com → New Repository → DataPreparation
#    Make it public

# 2. Initialize git in your package folder
cd DataPreparation
git init
git add .
git commit -m "Initial commit: DataPreparation v1.0.0"

# 3. Add remote and push
git remote add origin https://github.com/yourusername/DataPreparation.git
git push -u origin main

# 4. Create a release on GitHub (v1.0.0)
#    This enables Zenodo to archive it

# 5. Link to Zenodo
#    Go to zenodo.org → Sign in with GitHub
#    Activate your DataPreparation repo
#    Zenodo will auto-create archives and assign DOI
```

### Option B: Local/Internal Use

```r
# Just use the package locally:
devtools::load_all("DataPreparation")
# or
devtools::install("DataPreparation")
library(DataPreparation)
```

### Option C: CRAN Submission (Future)

```r
# Check package quality
devtools::check()

# Fix any warnings/notes

# Submit via: https://cran.r-project.org/submit.html
# After approval, users can install via:
install.packages("DataPreparation")
```

## File Structure After devtools::document()

After running `devtools::document()`, your folder will look like:

```
DataPreparation/
├── R/                          # Source files ✅
│   ├── 01_na_handling.R
│   ├── 02_numeric_features.R
│   ├── 03_timestamp_features.R
│   ├── 04_string_features.R
│   ├── 05_ngram_generation.R
│   ├── 06_position_extraction.R
│   └── 07_linguistic_analysis.R
├── man/                        # Auto-generated help files (NEW)
│   ├── validate_ngram.Rd
│   ├── generate_ngram_char_variants.Rd
│   └── ... (one per function)
├── DESCRIPTION                 # Package metadata ✅
├── NAMESPACE                   # Auto-generated exports (NEW)
├── README.md                   # User docs ✅
├── BUILD_SUMMARY.md            # Build info ✅
└── VERIFICATION.md             # Verification ✅
```

## Common Workflows

### Workflow 1: Using in Same Project

```r
# In your main analysis script (e.g., model_train.R):
devtools::load_all("../DataPreparation")  # Load from adjacent folder

# Use any function:
scaled_data <- scale_betweenRange(df, "rating")
```

### Workflow 2: Installed as Package

```r
# After: devtools::install("DataPreparation")

library(DataPreparation)

# Use directly:
profile <- extract_string_linguistic_profile(movies_df, "title", "movieId")
```

### Workflow 3: On GitHub + Zenodo

```r
# Users anywhere can install:
devtools::install_github("aabderrahimaariche-hue/DataPreparation")
library(DataPreparation)

# Or after CRAN:
install.packages("DataPreparation")
library(DataPreparation)
```

## Accessing Help

```r
# Help for specific function:
?validate_ngram
?generate_ngram_char_variants

# List all package functions:
help(package = "DataPreparation")

# Vignette (if created):
vignette("DataPreparation")
```

## Optional: Create a Vignette

To add usage examples and workflows:

```r
usethis::use_vignette("DataPreparation")
# Edit vignettes/DataPreparation.Rmd
# Run: devtools::build_vignettes()
```

## Troubleshooting

**Q: Functions not found after devtools::load_all()**
```r
# Make sure you're in the right directory:
getwd()  # Should be where DataPreparation folder is

# Or specify full path:
devtools::load_all("C:/path/to/DataPreparation")
```

**Q: Error about missing dependencies**
```r
# Install required packages:
devtools::install_deps("DataPreparation")
```

**Q: NAMESPACE not created**
```r
# Run document():
devtools::document("DataPreparation")

# Then check:
file.exists("DataPreparation/NAMESPACE")
```

## Recommended Sequence

1. ✅ **RIGHT NOW**: Run `devtools::document("DataPreparation")`
2. ✅ **NEXT**: Test with `devtools::load_all("DataPreparation")`
3. ✅ **THEN**: Update `data_prepare.R` to use the package
4. ✅ **FINALLY**: Consider GitHub + Zenodo publishing

## Citation Format (for Academic Work)

Once on Zenodo, cite as:

```
Abderrahim, A. (2025). DataPreparation: General-Purpose Data Preparation 
and Feature Engineering Library. Zenodo. 
https://doi.org/10.5281/zenodo.[DOI_NUMBER]
```

## Questions?

- **R Package Development**: devtools, roxygen2 documentation
- **GitHub**: Standard git workflow
- **Zenodo**: https://zenodo.org/features
- **CRAN**: https://cran.r-project.org/submit.html

---

**Status**: ✅ Package ready  
**Next Action**: Run `devtools::document()`  
**Time to ready**: ~1-2 minutes  
