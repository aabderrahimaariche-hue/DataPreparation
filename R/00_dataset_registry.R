#########################################################
# DATASET REGISTRY - Shared Dataset Management System
# Module: 00_dataset_registry.R
# Purpose: Manages datasets globally so all functions 
#          can access them without passing data parameter
#########################################################

#' Initialize Dataset Registry
#'
#' Creates a new environment for storing shared datasets.
#' This is called automatically when the package loads.
#'
#' @keywords internal
#' @return Environment for storing datasets
#'
.initialize_dataset_registry <- function() {
  if (!exists(".DataPreparation_Registry", envir = .GlobalEnv)) {
    assign(".DataPreparation_Registry", 
            new.env(parent = emptyenv()),
            envir = .GlobalEnv)
  }
  get(".DataPreparation_Registry", envir = .GlobalEnv)
}

# Initialize registry on package load
.DataPreparation_Registry <- .initialize_dataset_registry()

#' Register a Dataset
#'
#' Adds a dataset to the shared registry so it can be accessed
#' by all package functions without passing it as a parameter.
#'
#' @param data Data frame or data.table to register
#' @param name Character string. Name for the dataset in registry.
#'            If NULL, uses the name of the calling variable.
#' @param description Optional character string describing the dataset
#' @param replace Logical. If TRUE, replaces existing dataset with same name.
#'                If FALSE, raises error if name already exists. Default: FALSE
#' @param verbose Logical. If TRUE, prints confirmation message
#'
#' @return Invisibly returns the registry
#'
#' @examples
#' \dontrun{
#' # Register a dataset
#' movies <- data.frame(title = c("The Matrix", "Inception"))
#' register_dataset(movies, name = "movies")
#' 
#' # Now all functions can use it without passing data parameter
#' detect_datasets()  # Will show "movies" in registry
#' }
#'
#' @export
register_dataset <- function(data, name = NULL, description = NULL, 
                            replace = FALSE, verbose = TRUE) {
  
  # Get variable name if not provided
  if (is.null(name)) {
    name <- deparse(substitute(data))
  }
  
  # Check if dataset already exists
  if (exists(name, envir = .DataPreparation_Registry) && !replace) {
    stop(paste0("Dataset '", name, "' already exists in registry. ",
                "Set replace=TRUE to overwrite."))
  }
  
  # Validate input
  if (!is.data.frame(data)) {
    stop("Input must be a data.frame or data.table")
  }
  
  # Store metadata
  metadata <- list(
    data = data,
    rows = nrow(data),
    cols = ncol(data),
    column_names = colnames(data),
    column_types = sapply(data, class),
    registered_at = Sys.time(),
    description = description
  )
  
  # Register in registry
  assign(name, metadata, envir = .DataPreparation_Registry)
  
  if (verbose) {
    cat("\n✓ Dataset registered: ", name, "\n")
    cat("  Rows: ", nrow(data), " | Columns: ", ncol(data), "\n")
    if (!is.null(description)) {
      cat("  Description: ", description, "\n")
    }
    cat("\n")
  }
  
  invisible(.DataPreparation_Registry)
}

#' Get Registered Dataset
#'
#' Retrieves a dataset from the registry by name.
#' Use this internally in functions to access registered data.
#'
#' @param name Character string. Name of the dataset to retrieve
#' @param return_data Logical. If TRUE, returns just the data frame.
#'                    If FALSE, returns full metadata. Default: TRUE
#'
#' @return Data frame (if return_data=TRUE) or metadata list
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' # Get just the data
#' movies_data <- get_registered_dataset("movies")
#' 
#' # Get full metadata
#' movies_metadata <- get_registered_dataset("movies", return_data = FALSE)
#' }
#'
#' @export
get_registered_dataset <- function(name, return_data = TRUE) {
  
  if (!exists(name, envir = .DataPreparation_Registry)) {
    stop(paste0("Dataset '", name, "' not found in registry. ",
                "Use register_dataset() first."))
  }
  
  metadata <- get(name, envir = .DataPreparation_Registry)
  
  if (return_data) {
    return(metadata$data)
  } else {
    return(metadata)
  }
}

#' List All Registered Datasets
#'
#' Shows all datasets currently in the registry with their sizes and columns.
#'
#' @param verbose Logical. If TRUE, prints formatted summary.
#'                If FALSE, returns data frame silently. Default: TRUE
#'
#' @return Invisibly returns data frame with dataset information
#'
#' @examples
#' \dontrun{
#' # Register some datasets
#' register_dataset(data.frame(x = 1:5), "dataset1")
#' register_dataset(data.frame(y = 1:10), "dataset2")
#' 
#' # List all
#' list_registered_datasets()
#' }
#'
#' @export
list_registered_datasets <- function(verbose = TRUE) {
  
  datasets <- ls(envir = .DataPreparation_Registry)
  
  if (length(datasets) == 0) {
    if (verbose) {
      cat("\n⚠️  No datasets registered yet.\n")
      cat("   Use register_dataset() to add datasets.\n\n")
    }
    return(invisible(data.frame()))
  }
  
  registry_info <- data.frame(
    Dataset = datasets,
    Rows = sapply(datasets, function(x) {
      get(x, envir = .DataPreparation_Registry)$rows
    }),
    Columns = sapply(datasets, function(x) {
      get(x, envir = .DataPreparation_Registry)$cols
    }),
    Registered = sapply(datasets, function(x) {
      format(get(x, envir = .DataPreparation_Registry)$registered_at, 
             "%Y-%m-%d %H:%M:%S")
    }),
    row.names = NULL
  )
  
  if (verbose) {
    cat("\n")
    cat("=" %+% "=", strrep("=", 70), "\n")
    cat("| REGISTERED DATASETS\n")
    cat("=" %+% "=", strrep("=", 70), "\n\n")
    print(registry_info)
    cat("\n")
  }
  
  invisible(registry_info)
}

#' Unregister a Dataset
#'
#' Removes a dataset from the registry.
#'
#' @param name Character string or vector of dataset names to remove
#' @param verbose Logical. If TRUE, prints confirmation message
#'
#' @return Invisibly returns the registry
#'
#' @examples
#' \dontrun{
#' register_dataset(data.frame(x = 1:5), "temp_data")
#' 
#' # Later, remove it
#' unregister_dataset("temp_data")
#' }
#'
#' @export
unregister_dataset <- function(name, verbose = TRUE) {
  
  if (!is.character(name)) {
    stop("name must be character string or vector")
  }
  
  removed <- c()
  not_found <- c()
  
  for (dataset_name in name) {
    if (exists(dataset_name, envir = .DataPreparation_Registry)) {
      rm(list = dataset_name, envir = .DataPreparation_Registry)
      removed <- c(removed, dataset_name)
    } else {
      not_found <- c(not_found, dataset_name)
    }
  }
  
  if (verbose) {
    if (length(removed) > 0) {
      cat("\n✓ Removed datasets: ", paste(removed, collapse = ", "), "\n")
    }
    if (length(not_found) > 0) {
      cat("⚠️  Not found: ", paste(not_found, collapse = ", "), "\n")
    }
    cat("\n")
  }
  
  invisible(.DataPreparation_Registry)
}

#' Clear All Registered Datasets
#'
#' Removes all datasets from the registry.
#'
#' @param confirm Logical. If TRUE, asks for confirmation.
#'               If FALSE, clears without asking. Default: TRUE
#' @param verbose Logical. If TRUE, prints confirmation message
#'
#' @return Invisibly returns the registry
#'
#' @examples
#' \dontrun{
#' clear_registered_datasets(confirm = TRUE)
#' }
#'
#' @export
clear_registered_datasets <- function(confirm = TRUE, verbose = TRUE) {
  
  if (confirm) {
    datasets <- ls(envir = .DataPreparation_Registry)
    if (length(datasets) > 0) {
      cat("\nDatasets to clear: ", paste(datasets, collapse = ", "), "\n")
      response <- readline("Clear all? (yes/no): ")
      
      if (tolower(response) != "yes") {
        if (verbose) cat("Cancelled.\n\n")
        return(invisible(.DataPreparation_Registry))
      }
    }
  }
  
  # Clear all
  rm(list = ls(envir = .DataPreparation_Registry), 
     envir = .DataPreparation_Registry)
  
  if (verbose) {
    cat("✓ Registry cleared.\n\n")
  }
  
  invisible(.DataPreparation_Registry)
}

#' Check if Dataset is Registered
#'
#' Test whether a dataset exists in the registry.
#'
#' @param name Character string. Name of dataset to check
#'
#' @return Logical: TRUE if registered, FALSE otherwise
#'
#' @examples
#' \dontrun{
#' register_dataset(data.frame(x = 1:5), "my_data")
#' is_registered("my_data")   # TRUE
#' is_registered("other")     # FALSE
#' }
#'
#' @export
is_registered <- function(name) {
  exists(name, envir = .DataPreparation_Registry)
}

#' Get Dataset Summary from Registry
#'
#' Quick overview of a registered dataset's structure and contents.
#'
#' @param name Character string. Name of the registered dataset
#' @param n_rows Numeric. Number of rows to preview (default: 5)
#'
#' @return Invisibly returns list with summary information
#'
#' @examples
#' \dontrun{
#' register_dataset(data.frame(x = 1:100, y = letters[1:10]), "data")
#' get_dataset_summary("data", n_rows = 10)
#' }
#'
#' @export
get_dataset_summary <- function(name, n_rows = 5) {
  
  metadata <- get_registered_dataset(name, return_data = FALSE)
  data <- metadata$data
  
  cat("\n")
  cat("=" %+% "=", strrep("=", 60), "\n")
  cat("| DATASET SUMMARY: ", name, "\n")
  cat("=" %+% "=", strrep("=", 60), "\n\n")
  
  cat("Dimensions: ", nrow(data), " rows × ", ncol(data), " columns\n\n")
  
  cat("Registered: ", metadata$registered_at, "\n")
  if (!is.null(metadata$description)) {
    cat("Description: ", metadata$description, "\n")
  }
  cat("\n")
  
  cat("Columns:\n")
  col_info <- data.frame(
    Index = seq_len(ncol(data)),
    Column = colnames(data),
    Type = metadata$column_types,
    Non_NA = colSums(!is.na(data)),
    row.names = NULL
  )
  print(col_info)
  
  cat("\nPreview (first ", min(n_rows, nrow(data)), " rows):\n")
  print(head(data, n_rows))
  
  cat("\n")
  invisible(list(
    name = name,
    dimensions = c(nrow(data), ncol(data)),
    metadata = metadata
  ))
}

# ============================================================================
# FOCUS MODE - Allow functions to target a specific dataset automatically
# ============================================================================

#' Set Focus on a Dataset
#'
#' Sets the "current" dataset that all subsequent functions will use by default.
#' Functions will target this focused dataset unless another dataset is explicitly
#' passed via parameters.
#'
#' Use this to streamline workflows where you're working primarily with one dataset.
#' When done, call `stop_focus()` to disable focus mode.
#'
#' @param dataset_name Character string. Name of the registered dataset to focus on.
#'        Must be a registered dataset (use `register_dataset()` first).
#' @param verbose Logical. If TRUE, prints confirmation message. Default: TRUE
#'
#' @return Invisibly returns the registry
#'
#' @details
#' **Focus Mode Workflow:**
#' \preformatted{
#' register_dataset(df1, "movies")
#' register_dataset(df2, "reviews")
#'
#' # Set focus on movies
#' focus_dataset("movies")
#'
#' # These functions now use 'movies' by default:
#' inspect_dataset()                # Uses movies (when updated in Phase 2)
#' generate_ngrams(string_cols = "title")  # Uses movies
#'
#' # Switch focus to reviews
#' focus_dataset("reviews")
#'
#' # Now uses reviews instead:
#' inspect_dataset()  # Now uses reviews
#'
#' # Disable focus mode
#' stop_focus()
#'
#' # Back to regular mode - must pass data explicitly
#' inspect_dataset(data = df1)
#' }
#'
#' @examples
#' \dontrun{
#' movies <- data.frame(title = c("Matrix", "Inception"))
#' cancer <- data.frame(diagnosis = c("Breast", "Lung"))
#'
#' register_dataset(movies, "movies")
#' register_dataset(cancer, "cancer")
#'
#' # Set focus on movies
#' focus_dataset("movies")
#' get_current_focus()  # "movies"
#'
#' # Switch to cancer
#' focus_dataset("cancer")
#' get_current_focus()  # "cancer"
#'
#' # Disable focus
#' stop_focus()
#' get_current_focus()  # NULL
#' }
#'
#' @export
focus_dataset <- function(dataset_name, verbose = TRUE) {
  
  # Validate input
  if (!is.character(dataset_name) || length(dataset_name) != 1) {
    stop("dataset_name must be a single character string")
  }
  
  # Check if dataset exists
  if (!is_registered(dataset_name)) {
    stop(paste0("Dataset '", dataset_name, "' not found in registry. ",
                "Register it first with register_dataset()"))
  }
  
  # Set the focus
  assign(".DataPreparation_Focus", dataset_name, envir = .DataPreparation_Registry)
  
  if (verbose) {
    metadata <- get_registered_dataset(dataset_name, return_data = FALSE)
    cat("\n✓ Focus set to: ", dataset_name, "\n")
    cat("  Rows: ", metadata$rows, " | Columns: ", metadata$cols, "\n")
    cat("  All functions will now target this dataset by default.\n")
    cat("  Use stop_focus() to disable focus mode.\n\n")
  }
  
  invisible(.DataPreparation_Registry)
}

#' Stop Focus Mode
#'
#' Disables focus mode and returns to regular operation where you must
#' explicitly pass datasets to functions.
#'
#' @param verbose Logical. If TRUE, prints confirmation message. Default: TRUE
#'
#' @return Invisibly returns the registry
#'
#' @details
#' After calling `stop_focus()`:
#' - No dataset is "focused"
#' - Functions return to requiring explicit data parameters
#' - You must pass `data =` or equivalent parameter to all functions
#'
#' @examples
#' \dontrun{
#' register_dataset(movies, "movies")
#' focus_dataset("movies")
#'
#' # ... work with focused dataset ...
#'
#' # Disable focus mode
#' stop_focus()
#'
#' # Back to regular mode
#' inspect_dataset(data = movies)  # Must pass data explicitly
#' }
#'
#' @export
stop_focus <- function(verbose = TRUE) {
  
  # Check if focus is active
  had_focus <- exists(".DataPreparation_Focus", envir = .DataPreparation_Registry)
  
  # Remove the focus
  if (had_focus) {
    rm(".DataPreparation_Focus", envir = .DataPreparation_Registry)
  }
  
  if (verbose) {
    if (had_focus) {
      cat("\n✓ Focus mode disabled.\n")
      cat("  Functions now require explicit data parameter.\n")
      cat("  Use focus_dataset() to enable focus mode again.\n\n")
    } else {
      cat("\n⚠️  Focus mode was not active.\n\n")
    }
  }
  
  invisible(.DataPreparation_Registry)
}

#' Get Current Focus
#'
#' Returns the name of the currently focused dataset, or NULL if focus mode
#' is not active.
#'
#' @return Character string (dataset name) or NULL if no focus set
#'
#' @details
#' Use this to check what dataset is currently focused:
#' - Returns dataset name if focus is active
#' - Returns NULL if focus mode is disabled
#' - Useful for conditional logic in workflows
#'
#' @examples
#' \dontrun{
#' register_dataset(movies, "movies")
#'
#' # No focus yet
#' get_current_focus()  # NULL
#'
#' # Set focus
#' focus_dataset("movies")
#' get_current_focus()  # "movies"
#'
#' # Disable focus
#' stop_focus()
#' get_current_focus()  # NULL
#' }
#'
#' @export
get_current_focus <- function() {
  if (exists(".DataPreparation_Focus", envir = .DataPreparation_Registry)) {
    return(get(".DataPreparation_Focus", envir = .DataPreparation_Registry))
  }
  return(NULL)
}

#' Smart Data Resolution (Internal)
#'
#' Helper function to resolve which dataset to use. This is for internal use
#' by functions that support both explicit data and focus mode.
#'
#' Resolution order:
#' 1. If data parameter is provided → use it
#' 2. If focus is set → use focused dataset from registry
#' 3. If neither → return NULL (function will handle error)
#'
#' @param data Data frame or data.table (optional)
#' @param data_name Character. Parameter name for better error messages
#'
#' @return Data frame or data.table, or NULL if not resolved
#'
#' @keywords internal
#'
resolve_data_source <- function(data = NULL, data_name = "data") {
  
  # If explicit data provided, use it
  if (!is.null(data)) {
    if (!is.data.frame(data)) {
      stop(paste0(data_name, " must be a data frame or data.table"))
    }
    return(data)
  }
  
  # If focus is set, use focused dataset
  focus <- get_current_focus()
  if (!is.null(focus)) {
    return(get_registered_dataset(focus, return_data = TRUE))
  }
  
  # Neither provided nor focused
  return(NULL)
}

#' Show Focus Status
#'
#' Displays current focus mode status and provides helpful information.
#'
#' @return Invisibly returns list with status information
#'
#' @examples
#' \dontrun{
#' register_dataset(movies, "movies")
#' register_dataset(cancer, "cancer")
#'
#' # No focus
#' show_focus_status()
#'
#' # With focus
#' focus_dataset("movies")
#' show_focus_status()
#' }
#'
#' @export
show_focus_status <- function() {
  
  focus <- get_current_focus()
  
  cat("\n")
  cat("=" %+% "=", strrep("=", 70), "\n")
  cat("| FOCUS MODE STATUS\n")
  cat("=" %+% "=", strrep("=", 70), "\n\n")
  
  if (is.null(focus)) {
    cat("Status: INACTIVE\n\n")
    cat("No dataset is currently focused.\n")
    cat("Functions require explicit data parameters.\n\n")
    cat("To activate focus mode:\n")
    cat("  focus_dataset(\"dataset_name\")\n\n")
  } else {
    metadata <- get_registered_dataset(focus, return_data = FALSE)
    cat("Status: ACTIVE\n\n")
    cat("Focused Dataset: ", focus, "\n")
    cat("  Rows: ", metadata$rows, " | Columns: ", metadata$cols, "\n\n")
    cat("Behavior:\n")
    cat("  - Functions default to this dataset\n")
    cat("  - Can override with explicit parameters\n")
    cat("  - Functions don't require 'data =' parameter\n\n")
    cat("To switch focus:\n")
    cat("  focus_dataset(\"another_dataset\")\n\n")
    cat("To disable focus:\n")
    cat("  stop_focus()\n\n")
  }
  
  invisible(list(
    active = !is.null(focus),
    focused_dataset = focus
  ))
}
