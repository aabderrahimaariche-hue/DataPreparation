#########################################################
# AUTOMATIC WORKFLOW GENERATOR
# Module: 09_workflow_generator.R
# Purpose: Automatically generate workflow scripts based on
#          available datasets and columns in memory
#########################################################

#' Detect All Data Frames in Global Environment
#'
#' Scans the global environment for all data frames and returns
#' information about them including structure and columns.
#'
#' @param envir Environment to search (default: global environment)
#' @param verbose Logical. If TRUE, prints summary
#'
#' @return Data frame with dataset information (name, rows, columns)
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(title = c("The Matrix", "Inception"))
#' cancer <- data.frame(diagnosis = c("Breast Cancer", "Lung Cancer"))
#' detect_datasets()
#' }
#'
#' @export
detect_datasets <- function(envir = .GlobalEnv, verbose = TRUE) {
  all_objects <- ls(envir = envir)
  
  dataframes <- c()
  for (obj in all_objects) {
    if (is.data.frame(get(obj, envir = envir))) {
      dataframes <- c(dataframes, obj)
    }
  }
  
  if (length(dataframes) == 0) {
    cat("\n⚠️  No data frames found in environment.\n")
    cat("   Load or create a dataset first:\n")
    cat("   movies <- data.frame(...)\n\n")
    return(invisible(NULL))
  }
  
  # Get info for each data frame
  df_info <- data.frame(
    Dataset = dataframes,
    Rows = sapply(dataframes, function(x) nrow(get(x, envir = envir))),
    Columns = sapply(dataframes, function(x) ncol(get(x, envir = envir))),
    row.names = NULL
  )
  
  if (verbose) {
    cat("\n")
    cat("=" %+% "=", strrep("=", 60), "\n")
    cat("| AVAILABLE DATASETS IN MEMORY\n")
    cat("=" %+% "=", strrep("=", 60), "\n\n")
    print(df_info)
    cat("\n")
  }
  
  invisible(df_info)
}

#' Show Dataset Columns and Types
#'
#' Displays all columns in a dataset with their data types,
#' helping users select appropriate columns for analysis.
#'
#' @param dataset_name Name of the dataset (as string)
#' @param envir Environment to search (default: global environment)
#'
#' @return Invisible data frame with column information
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(title = c("The Matrix"), rating = c(8.7))
#' show_dataset_columns("movies")
#' }
#'
#' @export
show_dataset_columns <- function(dataset_name, envir = .GlobalEnv) {
  if (!exists(dataset_name, envir = envir)) {
    stop(paste("Dataset not found:", dataset_name))
  }
  
  data <- get(dataset_name, envir = envir)
  
  col_info <- data.frame(
    Index = 1:ncol(data),
    Column = colnames(data),
    Type = sapply(data, class),
    Non_Null = sapply(data, function(x) sum(!is.na(x))),
    row.names = NULL
  )
  col_info$Null_Count <- nrow(data) - col_info$Non_Null
  
  cat("\n")
  cat("=" %+% "=", strrep("=", 60), "\n")
  cat("| DATASET COLUMNS: ", dataset_name, "\n")
  cat("=" %+% "=", strrep("=", 60), "\n\n")
  print(col_info)
  cat("\n")
  
  invisible(col_info)
}

#' Interactive Workflow Generator
#'
#' Guides user through menu to select dataset, columns, and analysis type,
#' then generates an appropriate workflow script.
#'
#' @param envir Environment to search (default: global environment)
#' @param auto_mode Logical. If TRUE, uses default selections (for testing)
#'
#' @return Invisible list with selected parameters
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(title = c("The Matrix"), rating = c(8.7))
#' cancer <- data.frame(diagnosis = c("Breast Cancer"), survival = c(48))
#' generate_workflow_interactive()
#' }
#'
#' @export
generate_workflow_interactive <- function(envir = .GlobalEnv, auto_mode = FALSE) {
  cat("\n")
  cat("=" %+% "=", strrep("=", 70), "\n")
  cat("| 🚀 AUTOMATIC WORKFLOW GENERATOR\n")
  cat("| Generates custom analysis scripts based on your data\n")
  cat("=" %+% "=", strrep("=", 70), "\n\n")
  
  # Step 1: Detect datasets
  cat("STEP 1: Detecting datasets in memory...\n\n")
  datasets_info <- detect_datasets(envir = envir, verbose = TRUE)
  
  if (is.null(datasets_info)) {
    return(invisible(NULL))
  }
  
  # Step 2: Select dataset
  cat("STEP 2: Select a dataset to analyze\n\n")
  for (i in 1:nrow(datasets_info)) {
    cat(sprintf("  [%d] %s (%d rows, %d columns)\n", 
                i, datasets_info$Dataset[i], datasets_info$Rows[i], datasets_info$Columns[i]))
  }
  cat("\n")
  
  if (auto_mode) {
    dataset_choice <- 1
    cat(sprintf("Auto-selected: %s\n\n", datasets_info$Dataset[dataset_choice]))
  } else {
    dataset_choice <- as.integer(readline("Enter number (1-" %+% nrow(datasets_info) %+% "): "))
    if (is.na(dataset_choice) || dataset_choice < 1 || dataset_choice > nrow(datasets_info)) {
      stop("Invalid selection")
    }
    cat("\n")
  }
  
  selected_dataset <- datasets_info$Dataset[dataset_choice]
  data <- get(selected_dataset, envir = envir)
  
  # Step 3: Show columns
  cat("STEP 3: Available columns in", selected_dataset, "\n\n")
  col_info <- show_dataset_columns(selected_dataset, envir = envir)
  
  # Step 4: Select string column (for text analysis)
  cat("STEP 4: Select STRING column for text analysis\n")
  cat("(For n-gram generation, linguistic analysis, etc.)\n\n")
  
  string_cols <- col_info$Column[col_info$Type == "character"]
  if (length(string_cols) == 0) {
    cat("❌ No character/string columns found in this dataset.\n")
    cat("   (Text analysis requires string columns)\n\n")
    string_col <- NULL
  } else {
    for (i in 1:length(string_cols)) {
      cat(sprintf("  [%d] %s\n", i, string_cols[i]))
    }
    cat("\n")
    
    if (auto_mode) {
      string_choice <- 1
      cat(sprintf("Auto-selected: %s\n\n", string_cols[string_choice]))
    } else {
      string_choice <- as.integer(readline("Enter number (1-" %+% length(string_cols) %+% ") or 0 to skip: "))
      if (is.na(string_choice)) string_choice <- 0
      cat("\n")
    }
    
    if (string_choice > 0 && string_choice <= length(string_cols)) {
      string_col <- string_cols[string_choice]
    } else {
      string_col <- NULL
      cat("Skipping string column analysis.\n\n")
    }
  }
  
  # Step 5: Select numeric column (for analysis target)
  cat("STEP 5: Select NUMERIC column for analysis target\n")
  cat("(For effects, survival prediction, outcome prediction, etc.)\n\n")
  
  numeric_cols <- col_info$Column[col_info$Type %in% c("numeric", "integer")]
  if (length(numeric_cols) == 0) {
    cat("❌ No numeric columns found in this dataset.\n\n")
    numeric_col <- NULL
  } else {
    for (i in 1:length(numeric_cols)) {
      cat(sprintf("  [%d] %s\n", i, numeric_cols[i]))
    }
    cat("\n")
    
    if (auto_mode) {
      numeric_choice <- 1
      cat(sprintf("Auto-selected: %s\n\n", numeric_cols[numeric_choice]))
    } else {
      numeric_choice <- as.integer(readline("Enter number (1-" %+% length(numeric_cols) %+% ") or 0 to skip: "))
      if (is.na(numeric_choice)) numeric_choice <- 0
      cat("\n")
    }
    
    if (numeric_choice > 0 && numeric_choice <= length(numeric_cols)) {
      numeric_col <- numeric_cols[numeric_choice]
    } else {
      numeric_col <- NULL
      cat("Skipping numeric column analysis.\n\n")
    }
  }
  
  # Step 6: Select ID column
  cat("STEP 6: Select ID column (unique identifier per row)\n")
  cat("(For grouping, position extraction, linguistic analysis, etc.)\n\n")
  
  for (i in 1:nrow(col_info)) {
    cat(sprintf("  [%d] %s\n", i, col_info$Column[i]))
  }
  cat("\n")
  
  if (auto_mode) {
    id_choice <- 1
    cat(sprintf("Auto-selected: %s\n\n", col_info$Column[id_choice]))
  } else {
    id_choice <- as.integer(readline("Enter number (1-" %+% nrow(col_info) %+% "): "))
    if (is.na(id_choice) || id_choice < 1 || id_choice > nrow(col_info)) {
      stop("Invalid selection")
    }
    cat("\n")
  }
  
  id_col <- col_info$Column[id_choice]
  
  # Step 7: Select analysis type
  cat("STEP 7: Select analysis type\n\n")
  cat("  [1] Full Analysis (All functions)\n")
  cat("  [2] N-gram Analysis Only\n")
  cat("  [3] Position-based Analysis (Prefix/Infix/Suffix)\n")
  cat("  [4] Linguistic Analysis Only\n")
  cat("  [5] Effects Analysis Only\n\n")
  
  if (auto_mode) {
    analysis_choice <- 1
    cat("Auto-selected: Full Analysis\n\n")
  } else {
    analysis_choice <- as.integer(readline("Enter number (1-5): "))
    if (is.na(analysis_choice) || analysis_choice < 1 || analysis_choice > 5) {
      analysis_choice <- 1
    }
    cat("\n")
  }
  
  analysis_types <- c(
    "Full Analysis",
    "N-gram Analysis Only",
    "Position-based Analysis",
    "Linguistic Analysis Only",
    "Effects Analysis Only"
  )
  
  selected_analysis <- analysis_types[analysis_choice]
  
  # Generate workflow script
  cat("=" %+% "=", strrep("=", 70), "\n")
  cat("| ✨ GENERATING WORKFLOW SCRIPT\n")
  cat("=" %+% "=", strrep("=", 70), "\n\n")
  
  workflow_script <- generate_workflow_script(
    dataset_name = selected_dataset,
    string_col = string_col,
    numeric_col = numeric_col,
    id_col = id_col,
    analysis_type = selected_analysis,
    data = data
  )
  
  # Display generated script
  cat("GENERATED WORKFLOW SCRIPT:\n\n")
  cat(workflow_script)
  cat("\n\n")
  
  # Save script to file
  filename <- paste0("workflow_", tolower(gsub(" ", "_", selected_dataset)), "_", 
                     format(Sys.time(), "%Y%m%d_%H%M%S"), ".R")
  
  cat("SAVING SCRIPT TO FILE:\n")
  cat("Filename:", filename, "\n\n")
  
  writeLines(workflow_script, filename)
  
  cat("✅ Script saved! You can run it with:\n")
  cat("   source('", filename, "')\n\n")
  
  # Return parameters
  params <- list(
    dataset_name = selected_dataset,
    string_col = string_col,
    numeric_col = numeric_col,
    id_col = id_col,
    analysis_type = selected_analysis,
    script_file = filename
  )
  
  invisible(params)
}

#' Generate Workflow Script Code
#'
#' Creates R code for a complete workflow based on selected parameters.
#'
#' @param dataset_name Name of the dataset
#' @param string_col Name of string column for text analysis
#' @param numeric_col Name of numeric column for target variable
#' @param id_col Name of ID column
#' @param analysis_type Type of analysis to perform
#' @param data The actual dataset (for column validation)
#'
#' @return Character string containing complete R script
#'
#' @keywords internal
generate_workflow_script <- function(dataset_name, string_col, numeric_col, 
                                     id_col, analysis_type, data) {
  
  # Start with header
  script <- paste0(
    "# AUTO-GENERATED WORKFLOW SCRIPT\n",
    "# Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n",
    "# Dataset: ", dataset_name, "\n",
    "# Analysis Type: ", analysis_type, "\n",
    "# ============================================================================\n\n",
    "library(DataPreparation)\n\n",
    "cat('\\n=== AUTO-GENERATED WORKFLOW FOR ", toupper(dataset_name), " ===\\n\\n')\n\n"
  )
  
  # Step 1: Load and inspect
  script <- paste0(script,
    "# STEP 1: INSPECT DATASET\n",
    "cat('📊 STEP 1: INSPECT DATASET\\n\\n')\n",
    "inspect_dataset(", dataset_name, ")\n\n"
  )
  
  # Step 2: Validate
  if (!is.null(string_col) && !is.null(numeric_col)) {
    script <- paste0(script,
      "# STEP 2: VALIDATE FOR PROCESSING\n",
      "cat('✅ STEP 2: VALIDATE FOR PROCESSING\\n\\n')\n",
      "is_valid <- validate_for_processing(\n",
      "  data = ", dataset_name, ",\n",
      "  string_cols = '", string_col, "',\n",
      "  numeric_cols = '", numeric_col, "',\n",
      "  id_col = '", id_col, "',\n",
      "  verbose = TRUE\n",
      ")\n\n"
    )
  }
  
  # Step 3: Preview
  script <- paste0(script,
    "# STEP 3: PREVIEW DATA\n",
    "cat('📄 STEP 3: PREVIEW DATA\\n\\n')\n",
    "preview_dataset(", dataset_name, ")\n\n"
  )
  
  # N-gram analysis (if text column selected and analysis includes n-grams)
  if (!is.null(string_col) && analysis_type %in% c("Full Analysis", "N-gram Analysis Only", "Position-based Analysis")) {
    script <- paste0(script,
      "# STEP 4: GENERATE N-GRAMS\n",
      "cat('🔤 STEP 4: GENERATE N-GRAMS FROM ", toupper(string_col), "\\n\\n')\n",
      "ngrams <- generate_ngram_char_variants(\n",
      "  data = ", dataset_name, ",\n",
      "  string_cols = '", string_col, "',\n",
      "  ngram_min = 2,\n",
      "  ngram_max = 3\n",
      ")\n\n",
      "cat('N-grams generated from \"", string_col, "\" column\\n\\n')\n\n"
    )
    
    # Position extraction (if selected)
    if (analysis_type %in% c("Full Analysis", "Position-based Analysis")) {
      script <- paste0(script,
        "# STEP 5: EXTRACT POSITION-BASED PATTERNS\n",
        "cat('📍 STEP 5: EXTRACT PREFIX, INFIX, SUFFIX\\n\\n')\n",
        "prefixes <- extract_prefix_patterns(\n",
        "  ngram_data_list = ngrams$sliding$all,\n",
        "  id_col = '", id_col, "'\n",
        ")\n",
        "suffixes <- extract_suffix_patterns(\n",
        "  ngram_data_list = ngrams$sliding$all,\n",
        "  id_col = '", id_col, "'\n",
        ")\n",
        "cat('Position patterns extracted\\n\\n')\n\n"
      )
    }
  }
  
  # Linguistic analysis
  if (!is.null(string_col) && analysis_type %in% c("Full Analysis", "Linguistic Analysis Only")) {
    step_num <- if (analysis_type == "Linguistic Analysis Only") "4" else "6"
    script <- paste0(script,
      "# STEP ", step_num, ": EXTRACT LINGUISTIC PROFILE\n",
      "cat('🎯 STEP ", step_num, ": LINGUISTIC PROFILE\\n\\n')\n",
      "profile <- extract_string_linguistic_profile(\n",
      "  data = ", dataset_name, ",\n",
      "  string_col = '", string_col, "',\n",
      "  id_col = '", id_col, "'\n",
      ")\n\n",
      "cat('Linguistic features extracted\\n\\n')\n\n"
    )
  }
  
  # Effects analysis
  if (!is.null(string_col) && !is.null(numeric_col) && 
      analysis_type %in% c("Full Analysis", "Effects Analysis Only")) {
    
    step_num <- if (analysis_type == "Effects Analysis Only") "4" else "7"
    script <- paste0(script,
      "# STEP ", step_num, ": COMPUTE EFFECTS ON ", toupper(numeric_col), "\n",
      "cat('📈 STEP ", step_num, ": EFFECTS ON ", toupper(numeric_col), "\\n\\n')\n",
      "effects <- compute_global_linguistic_effects(\n",
      "  data = ", dataset_name, ",\n",
      "  string_col = '", string_col, "',\n",
      "  rating_col = '", numeric_col, "'\n",
      ")\n\n",
      "cat('Effects computed: which patterns affect ", numeric_col, "?\\n\\n')\n\n"
    )
    
    # Position importance
    if (analysis_type == "Full Analysis") {
      script <- paste0(script,
        "# STEP 8: RANK POSITION IMPORTANCE\n",
        "cat('⭐ STEP 8: POSITION IMPORTANCE\\n\\n')\n",
        "position_importance <- compute_position_importance(\n",
        "  data = ", dataset_name, ",\n",
        "  string_col = '", string_col, "',\n",
        "  rating_col = '", numeric_col, "',\n",
        "  id_col = '", id_col, "'\n",
        ")\n",
        "print(position_importance)\n\n"
      )
    }
  }
  
  # Summary and insights
  if (analysis_type == "Full Analysis" && !is.null(string_col) && !is.null(numeric_col)) {
    script <- paste0(script,
      "# STEP 9: COMPREHENSIVE SUMMARY\n",
      "cat('📊 STEP 9: SUMMARY\\n\\n')\n",
      "summary_report <- summarize_linguistic_analysis(\n",
      "  data = ", dataset_name, ",\n",
      "  string_col = '", string_col, "',\n",
      "  rating_col = '", numeric_col, "',\n",
      "  id_col = '", id_col, "'\n",
      ")\n\n",
      "# STEP 10: MEMORY USAGE\n",
      "cat('💾 STEP 10: MEMORY USAGE\\n\\n')\n",
      "check_memory_usage()\n\n"
    )
  }
  
  # Conclusion
  script <- paste0(script,
    "cat('\\n✅ WORKFLOW COMPLETE!\\n\\n')\n",
    "cat('Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\n')\n"
  )
  
  script
}
