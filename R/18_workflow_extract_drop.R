#' Workflow: Load, Extract, Drop Pattern
#'
#' Helper function for the common pattern:
#'   1. Load large dataset
#'   2. Extract features/transform
#'   3. Drop original (frees RAM)
#'
#' This workflow helps optimize memory by keeping only the transformed data.
#'
#' @param load_fun Function that loads the dataset
#' @param transform_fun Function that extracts/transforms data and returns result
#' @param drop_original Logical: drop original datasets after transform? (default: TRUE)
#' @param verbose Logical: print workflow messages? (default: TRUE)
#'
#' @return Result from transform_fun (invisibly)
#'
#' @examples
#' \dontrun{
#' # Load MovieLens, extract features, automatically drop raw data
#' features <- workflow_extract_drop(
#'   load_fun = function() {
#'     source('setup/edx_setup.R')  # Creates: edx, final_test_set
#'   },
#'   transform_fun = function() {
#'     # Extract features from edx
#'     features <- extract_features(edx)
#'     return(features)
#'   },
#'   drop_original = TRUE  # Automatically drops edx, final_test_set
#' )
#' }
#'
#' @export
workflow_extract_drop <- function(
  load_fun,
  transform_fun,
  drop_original = TRUE,
  verbose = TRUE
) {
  
  if (verbose) {
    cat("[WORKFLOW] Starting extract & drop workflow...\n")
    cat("[WORKFLOW] Step 1: Loading data...\n")
  }
  
  # Step 1: Load original data
  load_fun()
  
  if (verbose) {
    cat("[WORKFLOW] Step 2: Extracting features...\n")
  }
  
  # Step 2: Extract/transform
  result <- transform_fun()
  
  if (drop_original && verbose) {
    cat("[WORKFLOW] Step 3: Dropping original datasets to free RAM...\n")
  }
  
  # Step 3: Drop originals if requested
  if (drop_original) {
    # Find large datasets (likely the originals)
    all_datasets <- setdiff(ls(envir = globalenv()), deparse(substitute(result)))
    
    if (length(all_datasets) > 0) {
      drop_datasets(all_datasets, verbose = verbose)
    }
  }
  
  if (verbose) {
    cat("[WORKFLOW]  Complete!\n\n")
  }
  
  return(invisible(result))
}
