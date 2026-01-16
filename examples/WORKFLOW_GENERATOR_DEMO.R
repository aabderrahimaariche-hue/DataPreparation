# WORKFLOW GENERATOR DEMO
# Shows how to automatically generate workflow scripts based on available data

library(DataPreparation)

cat("\n")
cat("╔════════════════════════════════════════════════════════════════╗\n")
cat("║  WORKFLOW GENERATOR DEMO                                       ║\n")
cat("║  Automatically generates analysis scripts from datasets in memory ║\n")
cat("╚════════════════════════════════════════════════════════════════╝\n\n")

# ============================================================================
# CREATE SAMPLE DATASETS IN MEMORY (Simulating MovieLens/Cancer datasets)
# ============================================================================

cat("SETTING UP DEMO DATASETS...\n\n")

# Dataset 1: Movies (Entertainment Domain)
movies <- data.frame(
  movieId = 1:5,
  title = c("The Matrix", "Inception", "Interstellar", "Avatar", "Inception 2"),
  year = c("1999", "2010", "2014", "2009", "2024"),
  rating = c(8.7, 8.8, 8.6, 7.8, 8.5),
  revenue = c(467222728, 839671789, 701730249, 2923706026, 1150000000)
)

# Dataset 2: Cancer Patients (Healthcare Domain)
cancer_patients <- data.frame(
  patientId = 1001:1007,
  diagnosis = c(
    "Breast Cancer Stage 2",
    "Lung Cancer Advanced",
    "Pancreatic Cancer Metastatic",
    "Colon Cancer Early",
    "Melanoma Stage 3",
    "Lymphoma B-cell",
    "Prostate Cancer Localized"
  ),
  age = c(45, 62, 58, 71, 34, 52, 68),
  survival_months = c(48, 12, 8, 72, 36, 24, 60),
  treatment_type = c("Surgery", "Chemo", "Chemo", "Surgery", "Immuno", "Radiation", "Surgery"),
  biomarker_level = c(2.3, 7.8, 9.2, 1.5, 5.6, 4.2, 2.1)
)

# Dataset 3: E-commerce Products (Business Domain)
products <- data.frame(
  productId = 1:6,
  product_name = c("Premium Coffee Maker", "Wireless Headphones Pro", "4K Smart TV", 
                   "Portable Bluetooth Speaker", "Wireless Charging Pad", "USB-C Hub Adapter"),
  category = c("Kitchen", "Electronics", "Electronics", "Audio", "Accessories", "Accessories"),
  price = c(149.99, 199.99, 899.99, 79.99, 34.99, 49.99),
  sales = c(2500, 3200, 1500, 4100, 5600, 3900),
  rating = c(4.6, 4.8, 4.3, 4.7, 4.5, 4.4)
)

cat("✅ Created 3 sample datasets:\n")
cat("   1. movies (5 movies, 5 columns)\n")
cat("   2. cancer_patients (7 patients, 5 columns)\n")
cat("   3. products (6 products, 6 columns)\n\n")

# ============================================================================
# OPTION 1: AUTOMATIC WORKFLOW DETECTION
# ============================================================================

cat("=" %+% "=", strrep("=", 70), "\n")
cat("| OPTION 1: AUTOMATIC WORKFLOW GENERATION (INTERACTIVE)\n")
cat("=" %+% "=", strrep("=", 70), "\n\n")

cat("DETECTING DATASETS IN MEMORY:\n\n")
available_datasets <- detect_datasets(verbose = FALSE)
print(available_datasets)

cat("\nYou can now run the interactive generator:\n")
cat("  params <- generate_workflow_interactive()\n\n")
cat("This will:\n")
cat("  1. ✓ Show all available datasets\n")
cat("  2. ✓ Let you select a dataset\n")
cat("  3. ✓ Show all available columns\n")
cat("  4. ✓ Let you select which column to analyze (text)\n")
cat("  5. ✓ Let you select target variable (numeric)\n")
cat("  6. ✓ Let you choose analysis type\n")
cat("  7. ✓ AUTOMATICALLY GENERATE workflow script\n")
cat("  8. ✓ SAVE script to file\n")
cat("  9. ✓ Ready to run!\n\n")

# ============================================================================
# OPTION 2: SHOW COLUMNS FOR EACH DATASET
# ============================================================================

cat("=" %+% "=", strrep("=", 70), "\n")
cat("| OPTION 2: SHOW AVAILABLE COLUMNS FOR EACH DATASET\n")
cat("=" %+% "=", strrep("=", 70), "\n\n")

cat("MOVIES DATASET COLUMNS:\n")
show_dataset_columns("movies")

cat("CANCER_PATIENTS DATASET COLUMNS:\n")
show_dataset_columns("cancer_patients")

cat("PRODUCTS DATASET COLUMNS:\n")
show_dataset_columns("products")

# ============================================================================
# OPTION 3: AUTOMATIC GENERATION (NON-INTERACTIVE)
# ============================================================================

cat("=" %+% "=", strrep("=", 70), "\n")
cat("| OPTION 3: GENERATE WORKFLOWS FOR ALL DATASETS (AUTO MODE)\n")
cat("=" %+% "=", strrep("=", 70), "\n\n")

# For demonstration, let's generate workflows for all three datasets
analysis_configs <- list(
  list(
    dataset = "movies",
    string_col = "title",
    numeric_col = "rating",
    id_col = "movieId",
    analysis = "Full Analysis"
  ),
  list(
    dataset = "cancer_patients",
    string_col = "diagnosis",
    numeric_col = "survival_months",
    id_col = "patientId",
    analysis = "Full Analysis"
  ),
  list(
    dataset = "products",
    string_col = "product_name",
    numeric_col = "sales",
    id_col = "productId",
    analysis = "Full Analysis"
  )
)

cat("Generating workflows for all datasets...\n\n")

for (config in analysis_configs) {
  cat("---\n")
  cat("Dataset: ", config$dataset, "\n")
  cat("String Column: ", config$string_col, "\n")
  cat("Target Column: ", config$numeric_col, "\n")
  cat("Analysis Type: ", config$analysis, "\n")
  cat("---\n\n")
  
  # Get the data
  data <- get(config$dataset)
  
  # Generate script
  script <- generate_workflow_script(
    dataset_name = config$dataset,
    string_col = config$string_col,
    numeric_col = config$numeric_col,
    id_col = config$id_col,
    analysis_type = config$analysis,
    data = data
  )
  
  # Save to file
  filename <- paste0("workflow_", tolower(config$dataset), "_auto_", 
                     format(Sys.time(), "%Y%m%d_%H%M%S"), ".R")
  
  writeLines(script, filename)
  
  cat("✅ Workflow saved to: ", filename, "\n\n")
}

# ============================================================================
# SUMMARY
# ============================================================================

cat("=" %+% "=", strrep("=", 70), "\n")
cat("| DEMO COMPLETE - HOW TO USE\n")
cat("=" %+% "=", strrep("=", 70), "\n\n")

cat("METHOD 1: INTERACTIVE GENERATOR (Recommended for exploration)\n")
cat("  ─────────────────────────────────────────────────────────\n")
cat("  Run this in R console:\n")
cat("    library(DataPreparation)\n")
cat("    generate_workflow_interactive()\n\n")
cat("  This will:\n")
cat("    • Show all datasets in memory\n")
cat("    • Let you choose which dataset\n")
cat("    • Show all columns\n")
cat("    • Let you select string column, target, and analysis type\n")
cat("    • AUTOMATICALLY generate and save workflow script\n\n")

cat("METHOD 2: DETECT DATASETS (For inspection)\n")
cat("  ─────────────────────────────────────────────────────────\n")
cat("  Run this in R console:\n")
cat("    detect_datasets()\n")
cat("    show_dataset_columns('your_dataset')\n\n")

cat("METHOD 3: GENERATE FOR SPECIFIC DATASET (For automation)\n")
cat("  ─────────────────────────────────────────────────────────\n")
cat("  Run this in R console:\n")
cat("    script <- generate_workflow_script(\n")
cat("      dataset_name = 'movies',\n")
cat("      string_col = 'title',\n")
cat("      numeric_col = 'rating',\n")
cat("      id_col = 'movieId',\n")
cat("      analysis_type = 'Full Analysis',\n")
cat("      data = movies\n")
cat("    )\n")
cat("    writeLines(script, 'my_workflow.R')\n\n")

cat("=" %+% "=", strrep("=", 70), "\n\n")

cat("🎯 KEY ADVANTAGES:\n")
cat("   ✓ No manual column name entry - discover automatically\n")
cat("   ✓ Works with ANY dataset in memory\n")
cat("   ✓ Interactive menus for easy selection\n")
cat("   ✓ Generates optimized workflows based on your data types\n")
cat("   ✓ Saves scripts for reproducibility\n")
cat("   ✓ Works across all domains (movies, cancer, products, etc.)\n\n")

cat("💾 GENERATED FILES:\n")
cat("   Check your working directory for saved workflow files:\n")
cat("   - workflow_movies_auto_*.R\n")
cat("   - workflow_cancer_patients_auto_*.R\n")
cat("   - workflow_products_auto_*.R\n\n")

cat("Ready to generate your own workflows!\n")
cat("===========================================\n\n")
