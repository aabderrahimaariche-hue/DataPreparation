# WORKFLOW WITH SHARED DATASET REGISTRY
# Scenario: Using registered datasets across multiple functions
# This demonstrates how all functions can access datasets without
# passing data parameter each time

library(DataPreparation)

# ============================================================================
# SETUP: REGISTER YOUR DATASETS ONCE
# ============================================================================

# Load your data
movies <- data.frame(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "Avatar", "Inception 2"),
  year = c("1999", "2010", "2014", "2009", "2024"),
  rating = c(8.7, 8.8, 8.6, 7.8, 8.5),
  revenue = c(467222728, 839671789, 701730249, 2923706026, 1150000000)
)

cancer <- data.frame(
  patientId = 1:100,
  diagnosis = sample(c("Breast", "Lung", "Colon"), 100, replace = TRUE),
  stage = sample(1:4, 100, replace = TRUE),
  survivalMonths = sample(6:360, 100, replace = TRUE)
)

# Register them once - now all functions can access them
register_dataset(movies, name = "movies", 
                 description = "Movie database with ratings and revenue")
register_dataset(cancer, name = "cancer", 
                 description = "Cancer patient data with diagnoses and survival")

# ============================================================================
# VERIFY WHAT'S REGISTERED
# ============================================================================

cat("\n📋 CHECKING REGISTERED DATASETS:\n")
list_registered_datasets()

cat("\n🔍 SUMMARY OF MOVIES DATASET:\n")
get_dataset_summary("movies", n_rows = 3)

# ============================================================================
# USE FUNCTIONS WITH REGISTERED DATA
# ============================================================================
# With the new system, you can:
# 
# BEFORE (OLD WAY):
#   inspect_dataset(movies, verbose = TRUE)
#   ngrams <- generate_ngram_char_variants(data = movies, ...)
#   effects <- compute_global_linguistic_effects(data = movies, ...)
#
# AFTER (NEW WAY - SIMPLIFIED):
#   inspect_registered("movies")
#   ngrams <- generate_ngrams("movies", ...)
#   effects <- analyze_effects("movies", ...)

cat("\n✅ Now you can use functions with registered data:\n\n")

# Example 1: Inspect a registered dataset
cat("1️⃣  Inspect registered dataset:\n")
inspection <- inspect_registered_dataset("movies", verbose = TRUE)

# Example 2: Generate n-grams from registered data
cat("\n2️⃣  Generate n-grams from registered data:\n")
# (This would work if functions are updated to accept dataset names)
# ngrams <- generate_ngrams_from_registry("movies", 
#                                         string_cols = "title",
#                                         ngram_min = 2, 
#                                         ngram_max = 3)

# Example 3: Compare across datasets
cat("\n3️⃣  Work with multiple datasets:\n")
all_data <- list_registered_datasets(verbose = FALSE)
cat("Available datasets for analysis:\n")
print(all_data)

# ============================================================================
# CLEAN UP
# ============================================================================

# Unregister specific dataset
# unregister_dataset("temp_data")

# Clear all when done
# clear_registered_datasets(confirm = TRUE)

cat("\n✨ Registry system ready for use!\n")
cat("Use register_dataset() to add more data as needed.\n\n")
