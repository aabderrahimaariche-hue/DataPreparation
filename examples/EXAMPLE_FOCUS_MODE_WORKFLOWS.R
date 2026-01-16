# Focus Mode - Example Workflows

## Example 1: Single Dataset Analysis (Most Common)

library(DataPreparation)

# ============================================================================
# SCENARIO: Analyze movie titles to understand naming patterns
# ============================================================================

library(DataPreparation)

# ============================================================================
# SCENARIO: Analyze movie titles to understand naming patterns
# ============================================================================

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Analyze movie titles to understand naming patterns
# ============================================================================

# Step 1: Load data
movies <- data.frame(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "Avatar", "Inception 2"),
  year = c("1999", "2010", "2014", "2009", "2024"),
  rating = c(8.7, 8.8, 8.6, 7.8, 8.5)
)

# Step 2: Register and focus
register_dataset(movies, "movies")
focus_dataset("movies")

cat("\n=== ANALYZING MOVIE TITLES ===\n")

# Step 3: Inspect (no data= parameter needed!)
inspection <- inspect_dataset()

# Step 4: Generate linguistic patterns
cat("\n📊 Generating n-grams...\n")
# ngrams <- generate_ngrams(string_cols = "title")

# Step 5: Analyze effects
cat("\n📈 Computing effects...\n")
# effects <- compute_effects(string_col = "title")

# Step 6: Done - disable focus
```
```r
stop_focus()
cat("\n✓ Analysis complete. Focus mode disabled.\n")
```

---

## Example 2: Compare Multiple Datasets

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Compare movie ratings with review sentiment
# ============================================================================

# Load data
movies <- data.frame(
  movieId = 1:3,
  title = c("The Matrix", "Inception", "Interstellar"),
  rating = c(8.7, 8.8, 8.6)
)

reviews <- data.frame(
  reviewId = 1:100,
  movieId = sample(1:3, 100, replace = TRUE),
  sentiment = sample(c("positive", "negative", "neutral"), 100, replace = TRUE)
)

# Register both
register_dataset(movies, "movies")
register_dataset(reviews, "reviews")

cat("\n=== COMPARING DATASETS ===\n")
list_registered_datasets()

# ============================================================================
# PART 1: Analyze movies
# ============================================================================

cat("\n1️⃣ ANALYZING MOVIES\n")
focus_dataset("movies")
show_focus_status()

cat("Movie count:", nrow(inspect_dataset()), "\n")
# ... movie analysis ...

# ============================================================================
# PART 2: Analyze reviews
# ============================================================================

cat("\n2️⃣ ANALYZING REVIEWS\n")
focus_dataset("reviews")
show_focus_status()

cat("Review count:", nrow(inspect_dataset()), "\n")
# ... review analysis ...

# ============================================================================
# PART 3: Comparison
# ============================================================================

cat("\n3️⃣ COMPARING BOTH\n")
# Compare directly
movies_data <- get_registered_dataset("movies")
reviews_data <- get_registered_dataset("reviews")

comparison <- list(
  total_movies = nrow(movies_data),
  total_reviews = nrow(reviews_data),
  reviews_per_movie = nrow(reviews_data) / nrow(movies_data)
)
print(comparison)

# Done
stop_focus()
```

---

## Example 3: Progressive Refinement

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Clean data progressively, analyzing each stage
# ============================================================================

# Start with raw data
raw <- data.frame(
  id = 1:100,
  value = c(rnorm(95), NA, NA, NA, NA, NA),  # Some NAs
  category = sample(c("A", "B", "C", NA), 100, replace = TRUE)
)

cat("\n=== DATA REFINEMENT WORKFLOW ===\n")

# ============================================================================
# Stage 1: Raw Data Analysis
# ============================================================================

register_dataset(raw, "raw_data")
focus_dataset("raw_data")

cat("\n📊 Stage 1: Raw Data\n")
show_focus_status()
cat("Missing values in 'value':", sum(is.na(raw$value)), "\n")
cat("Missing values in 'category':", sum(is.na(raw$category)), "\n")
# raw_summary <- inspect_dataset()

# ============================================================================
# Stage 2: Cleaned Data
# ============================================================================

# Clean it
cleaned <- raw[!is.na(raw$value) & !is.na(raw$category), ]

register_dataset(cleaned, "cleaned_data")
focus_dataset("cleaned_data")

cat("\n🧹 Stage 2: Cleaned Data\n")
show_focus_status()
cat("Rows removed:", nrow(raw) - nrow(cleaned), "\n")
# cleaned_summary <- inspect_dataset()

# ============================================================================
# Stage 3: Final Analysis Data
# ============================================================================

# Further refine
final <- cleaned[cleaned$value > 0, ]

register_dataset(final, "analysis_data")
focus_dataset("analysis_data")

cat("\n✨ Stage 3: Analysis Data\n")
show_focus_status()
cat("Final rows:", nrow(final), "\n")

# ... analysis on final data ...

# Done
stop_focus()

cat("\n📋 Summary of stages:\n")
list_registered_datasets()
```

---

## Example 4: Mixed Mode (Focus + Explicit Parameters)

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Mostly use focused dataset, sometimes override
# ============================================================================

# Setup data
primary <- data.frame(x = 1:100, y = rnorm(100))
secondary <- data.frame(x = 1:50, y = rnorm(50))

register_dataset(primary, "primary")
register_dataset(secondary, "secondary")

focus_dataset("primary")

cat("\n=== MIXED MODE EXAMPLE ===\n")

# ============================================================================
# Using focused dataset (primary)
# ============================================================================

cat("\n1️⃣ Working with FOCUSED dataset (primary)\n")
cat("Current focus:", get_current_focus(), "\n")

# These use primary automatically:
# summary1 <- analyze()  # Uses primary
# result1 <- process()   # Uses primary

# ============================================================================
# Override focus temporarily
# ============================================================================

cat("\n2️⃣ Override focus - use SECONDARY dataset\n")

# Pass explicit data to override focus
# summary2 <- analyze(data = secondary)  # Uses secondary, not primary!

# Focus is still on primary (not changed):
cat("Current focus:", get_current_focus(), "\n")

# ============================================================================
# Use both together
# ============================================================================

cat("\n3️⃣ Comparing PRIMARY vs SECONDARY\n")

# Get both datasets
prim <- get_registered_dataset("primary")
sec <- get_registered_dataset("secondary")

cat("Primary rows:", nrow(prim), "\n")
cat("Secondary rows:", nrow(sec), "\n")

# ============================================================================
# Done
# ============================================================================

stop_focus()
cat("\n✓ Focus mode disabled.\n")
```

---

## Example 5: Conditional Focus Logic

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Smart workflow that checks focus state
# ============================================================================

# Setup
movies <- data.frame(title = c("Matrix", "Inception"), rating = c(8.7, 8.8))
register_dataset(movies, "movies")

# ============================================================================
# Function that works with or without focus
# ============================================================================

analyze_data <- function(use_focus = TRUE) {
  
  if (use_focus) {
    # Check if focus is set
    focus <- get_current_focus()
    
    if (is.null(focus)) {
      cat("⚠️  No focus set. Setting default...\n")
      focus_dataset("movies")
    } else {
      cat("✓ Using focused dataset:", focus, "\n")
    }
    
    # Get data from focus
    data <- get_registered_dataset(get_current_focus())
    
  } else {
    cat("Working without focus mode.\n")
    # Would require data parameter in real function
    data <- movies
  }
  
  cat("Analyzing", nrow(data), "rows\n")
  return(data)
}

# ============================================================================
# Test the function
# ============================================================================

cat("\n=== TEST 1: With focus ===\n")
analyze_data(use_focus = TRUE)

cat("\n=== TEST 2: Without focus ===\n")
analyze_data(use_focus = FALSE)

# Cleanup
stop_focus()
```

---

## Example 6: Project Workflow Template

```r
library(DataPreparation)

# ============================================================================
# COMPLETE PROJECT TEMPLATE WITH FOCUS MODE
# ============================================================================

# 1. CLEANUP FROM PREVIOUS PROJECT
# ============================================================================

cat("\n📁 PROJECT SETUP\n")

# Make sure no focus from previous project
stop_focus()

# Clear old data if needed
# clear_registered_datasets(confirm = FALSE)

# 2. LOAD DATA
# ============================================================================

cat("\n📥 LOADING DATA\n")

raw_data <- data.frame(
  id = 1:1000,
  name = paste0("item_", 1:1000),
  value = rnorm(1000),
  category = sample(LETTERS[1:5], 1000, replace = TRUE)
)

# 3. REGISTER AND FOCUS
# ============================================================================

cat("\n📍 REGISTERING AND FOCUSING\n")

register_dataset(raw_data, "raw", "Raw imported data")
focus_dataset("raw")

# Verify
show_focus_status()

# 4. EXPLORATORY DATA ANALYSIS
# ============================================================================

cat("\n🔍 EXPLORATORY ANALYSIS\n")

# All these use 'raw' automatically (when functions support focus)
# summary_raw <- inspect_dataset()
# profile <- extract_profile()
# patterns <- analyze_patterns()

# 5. DATA PREPROCESSING
# ============================================================================

cat("\n⚙️ PREPROCESSING\n")

# Create cleaned version
cleaned <- raw_data[raw_data$value > quantile(raw_data$value, 0.1), ]

# Register new version
register_dataset(cleaned, "cleaned", "After removing outliers")

# 6. MAIN ANALYSIS
# ============================================================================

cat("\n📊 MAIN ANALYSIS\n")

# Switch focus to cleaned data
focus_dataset("cleaned")
show_focus_status()

# All analysis now uses cleaned data
# results <- full_analysis()
# effects <- compute_effects()

# 7. RESULTS
# ============================================================================

cat("\n✅ RESULTS\n")

# Collect results
final_results <- list(
  original_rows = nrow(raw_data),
  cleaned_rows = nrow(cleaned),
  rows_removed = nrow(raw_data) - nrow(cleaned)
)

print(final_results)

# 8. CLEANUP
# ============================================================================

cat("\n🏁 PROJECT COMPLETE\n")

stop_focus()
cat("Focus mode disabled.\n")

cat("Datasets saved:\n")
list_registered_datasets()

cat("\n✓ Project workflow complete!\n")
```

---

## Example 7: Error Handling

```r
library(DataPreparation)

# ============================================================================
# SCENARIO: Proper error handling with focus mode
# ============================================================================

cat("\n=== ERROR HANDLING EXAMPLES ===\n")

# Example 1: Try to focus on non-existent dataset
# ============================================================================

cat("\n1️⃣ Error: Dataset not found\n")

tryCatch({
  focus_dataset("nonexistent")
}, error = function(e) {
  cat("✓ Caught error:", e$message, "\n")
  cat("  Solution: register_dataset(df, 'nonexistent') first\n")
})

# Example 2: Verify focus before analyzing
# ============================================================================

cat("\n2️⃣ Verify focus before analysis\n")

# Create robust function
safe_analyze <- function() {
  focus <- get_current_focus()
  
  if (is.null(focus)) {
    stop("No dataset focused. Use focus_dataset() first.")
  }
  
  cat("✓ Analyzing:", focus, "\n")
  return(TRUE)
}

# Test it
df <- data.frame(x = 1:10)
register_dataset(df, "mydata")

tryCatch({
  safe_analyze()  # Error - no focus yet
}, error = function(e) {
  cat("✓ Caught:", e$message, "\n")
})

# Now with focus
focus_dataset("mydata")
safe_analyze()  # Works!

# Example 3: Clean exit
# ============================================================================

cat("\n3️⃣ Clean exit\n")

stop_focus()
cat("✓ Focus mode safely disabled\n")
cat("✓ All resources cleaned up\n")
```

---

## Summary

These examples show:
- ✅ Single dataset analysis (most common)
- ✅ Comparing multiple datasets
- ✅ Progressive data refinement
- ✅ Mixed mode (focus + override)
- ✅ Conditional logic based on focus
- ✅ Complete project template
- ✅ Error handling

**Key Takeaway**: Focus mode makes your code cleaner, safer, and more professional while maintaining backward compatibility.
