# DATA.TABLE INTEGRATION EXAMPLE
# Shows how to use DataPreparation package with data.table

# Install required packages
# install.packages("data.table")
# devtools::install_github("aabderrahimaariche-hue/DataPreparation")

library(DataPreparation)
library(data.table)

# ============================================================
# EXAMPLE 1: Using data.table Directly
# ============================================================

cat("\n=== EXAMPLE 1: Direct data.table Usage ===\n")

# Create a data.table
movies_dt <- data.table(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "The Dark Knight", "Inception 2"),
  year = c(1999, 2010, 2014, 2008, 2022),
  rating = c(8.7, 8.8, 8.6, 9.0, 8.5)
)

cat("Input class:", class(movies_dt)[1], "\n")
print(movies_dt)

# Use DataPreparation functions directly with data.table
# Functions automatically handle data.table format!

cat("\n--- Scaling rating column ---\n")
scaled_dt <- scale_betweenRange(movies_dt, "rating")
cat("Output class:", class(scaled_dt)[1], "\n")
print(scaled_dt)

# Check: data.table is preserved!
cat("\nFormat preserved:", is.data.table(scaled_dt), "\n")

# ============================================================
# EXAMPLE 2: Converting Between Formats
# ============================================================

cat("\n=== EXAMPLE 2: Format Conversion ===\n")

# Create a data.frame
movies_df <- data.frame(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "The Dark Knight", "Inception 2"),
  rating = c(8.7, 8.8, 8.6, 9.0, 8.5)
)

cat("Original format:", class(movies_df)[1], "\n")

# Convert to data.table
movies_as_dt <- convert_data_format(movies_df, "data.table")
cat("Converted to:", class(movies_as_dt)[1], "\n")

# Use with DataPreparation
result <- scale_betweenRange(movies_as_dt, "rating")
cat("Result format:", class(result)[1], "\n")

# Convert back to data.frame
result_df <- convert_data_format(result, "data.frame")
cat("Converted back to:", class(result_df)[1], "\n")

# ============================================================
# EXAMPLE 3: Mixed Format Workflow
# ============================================================

cat("\n=== EXAMPLE 3: Mixed Format Workflow ===\n")

# Start with data.frame
df_movies <- data.frame(
  movieId = 1:3,
  title = c("Matrix", "Inception", "Interstellar"),
  rating = c(8.7, 8.8, 8.6)
)

cat("Step 1 - Input format:", class(df_movies)[1], "\n")

# Use data.frame throughout
scaled_df <- scale_betweenRange(df_movies, "rating")
cat("Step 2 - After scaling:", class(scaled_df)[1], "\n")

# Later, user decides to use data.table for large data
dt_movies <- convert_data_format(df_movies, "data.table")
cat("Step 3 - Converted to data.table:", class(dt_movies)[1], "\n")

# Functions work seamlessly
scaled_dt <- scale_betweenRange(dt_movies, "rating")
cat("Step 4 - After scaling with data.table:", class(scaled_dt)[1], "\n")

# ============================================================
# EXAMPLE 4: Get Format Information
# ============================================================

cat("\n=== EXAMPLE 4: Data Format Information ===\n")

info_df <- get_data_format_info(movies_df)
info_dt <- get_data_format_info(movies_dt)

cat("\nData Frame Info:\n")
print(info_df)

cat("\nData Table Info:\n")
print(info_dt)

# ============================================================
# EXAMPLE 5: Numeric Feature Engineering with data.table
# ============================================================

cat("\n=== EXAMPLE 5: Feature Engineering ===\n")

# Create data.table with multiple numeric columns
products_dt <- data.table(
  productId = 1:5,
  price = c(99.99, 149.99, 199.99, 299.99, 399.99),
  rating = c(4.5, 4.8, 4.2, 4.9, 4.6),
  sales = c(1000, 2500, 800, 3200, 1500)
)

cat("Original data.table:\n")
print(products_dt)

# Apply multiple transformations
result <- products_dt %>%
  scale_betweenRange("price") %>%
  scale_betweenRange("rating") %>%
  scale_betweenRange("sales")

cat("\nAfter scaling (format preserved):\n")
cat("Format:", class(result)[1], "\n")
print(result)

# ============================================================
# EXAMPLE 6: N-gram Analysis with data.table
# ============================================================

cat("\n=== EXAMPLE 6: Text Analysis with N-grams ===\n")

text_data_dt <- data.table(
  id = 1:3,
  text = c("The Matrix", "Inception", "Interstellar")
)

cat("Input (data.table):\n")
print(text_data_dt)

# Generate n-grams
ngrams <- generate_ngram_char_variants(text_data_dt, "text", 2, 3)

cat("\nN-grams generated successfully\n")
cat("N-gram result class:", class(ngrams$sliding$all)[1], "\n")

# ============================================================
# EXAMPLE 7: Workflow Generator with data.table
# ============================================================

cat("\n=== EXAMPLE 7: Dataset Detection ===\n")

# Create multiple datasets (mixed formats)
df_movies <- data.frame(
  title = c("Matrix", "Inception"),
  rating = c(8.7, 8.8)
)

dt_cancer <- data.table(
  diagnosis = c("Breast Cancer", "Lung Cancer"),
  survival = c(48, 12)
)

# Both formats in global environment
cat("\nDatasets in memory:\n")
datasets <- detect_datasets(verbose = FALSE)
print(datasets)

# Show columns for each
cat("\nColumns in df_movies:\n")
show_dataset_columns("df_movies")

cat("\nColumns in dt_cancer (data.table):\n")
show_dataset_columns("dt_cancer")

# ============================================================
# EXAMPLE 8: Performance Consideration
# ============================================================

cat("\n=== EXAMPLE 8: Performance Note ===\n")

cat("
DataPreparation with data.table:
1. Input: Accepts data.table directly
2. Processing: Converts to data.frame, processes, converts back
3. Output: Returns in same format as input

Performance:
- Small datasets: No noticeable difference
- Medium datasets: ~1-5ms overhead per operation
- Large datasets: Consider native data.table implementation (Phase 2)

When to use:
- ✓ Analysis workflows (few conversions)
- ✓ Mixed format projects
- ✓ User prefers data.table interface
- ✗ 10,000+ operations on massive data (consider Phase 2)
")

# ============================================================
# EXAMPLE 9: Error Handling
# ============================================================

cat("\n=== EXAMPLE 9: Error Handling ===\n")

# If data.table not installed
cat("Checking data.table availability...\n")
if (has_datatable()) {
  cat("✓ data.table is available\n")
} else {
  cat("✗ data.table not installed\n")
}

# Validation function
cat("\nValidating inputs:\n")
tryCatch({
  validate_data_input(movies_df, "movies_df")
  cat("✓ Valid data.frame\n")
}, error = function(e) {
  cat("✗ Error:", e$message, "\n")
})

tryCatch({
  validate_data_input(movies_dt, "movies_dt")
  cat("✓ Valid data.table\n")
}, error = function(e) {
  cat("✗ Error:", e$message, "\n")
})

# ============================================================
# SUMMARY
# ============================================================

cat("\n=== SUMMARY ===\n")
cat("
DataPreparation now supports both data.frame and data.table!

Key Features:
1. ✓ Accept both formats
2. ✓ Preserve input format in output
3. ✓ Automatic format detection
4. ✓ Seamless conversion
5. ✓ Helper functions for format management

Usage:
- Use with data.frame: Works as before
- Use with data.table: Works with automatic format preservation
- Convert between: Use convert_data_format()
- Check format: Use is_datatable(), get_data_format_info()

Next Steps:
1. Use DataPreparation with your preferred format
2. If performance matters for very large data, 
   consider contributing native data.table implementations
")

cat("\nDone!\n")
