#########################################################
# Package Initialization & Conflict Resolution
# Purpose: Resolve function name conflicts between 
#          imported libraries (dplyr, tidyr, purrr, zoo)
# Philosophy: Explicitly prefer dplyr/tidyr functions
#            over conflicting names from other packages
#########################################################

#' @import conflicted
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  # Resolve function name conflicts explicitly
  # These functions exist in multiple packages with different behavior
  # We explicitly prefer the dplyr/tidyr versions
  
  # Core dplyr functions (conflict with purrr, stats)
  conflicted::conflict_prefer("filter", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("select", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("mutate", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("summarise", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("group_by", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("rename", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("arrange", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("distinct", "dplyr", quiet = TRUE)
  
  # dplyr functions that conflict with zoo (lag/lead for time series)
  # In this package, we use dplyr's lag/lead for data manipulation
  conflicted::conflict_prefer("lag", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("lead", "dplyr", quiet = TRUE)
  
  # Additional dplyr verbs that may have conflicts
  conflicted::conflict_prefer("intersect", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("setdiff", "dplyr", quiet = TRUE)
  conflicted::conflict_prefer("union", "dplyr", quiet = TRUE)
  
  # Note: purrr functions (map, reduce, etc.) are unique enough
  # and explicitly called when needed. tidyr functions are mostly unique.
}

#########################################################
# Conflict Resolution Summary
#########################################################
# 
# This .onLoad hook ensures that when DataPreparation is loaded,
# all function name conflicts are explicitly resolved in favor of
# dplyr/tidyr functions, which are the primary data manipulation
# tools in this package.
#
# Why this matters:
# - dplyr::filter() operates on data frames (our use case)
# - purrr::filter() operates on lists/vectors (different purpose)
# - Using unqualified names could cause silent bugs if load order changes
#
# Benefits:
# - Explicit and self-documenting
# - Independent of package load order
# - Professional and robust
# - Users can still access other implementations via package:: prefix
#
# Example for users who want purrr::filter instead:
#   conflicted::conflict_prefer("filter", "purrr")
#########################################################
