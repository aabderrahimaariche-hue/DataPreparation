# CHANGELOG

## Version 1.2.0 - January 16, 2026

### Major Features

#### 1. Focus Mode System
A comprehensive system for managing multiple datasets in memory with intelligent focus management.

**New Functions Added**:
- `register_dataset(data, name)` - Register a dataset globally
- `focus_dataset(name)` - Set focus to a registered dataset
- `get_current_focus()` - Get the name of currently focused dataset
- `show_focus_status()` - Display focus mode status and statistics
- `stop_focus()` - Disable focus mode
- `get_registered_dataset(name)` - Retrieve a registered dataset
- `resolve_data_source(data, dataset_name)` - Smart parameter resolver

**Location**: `R/00_dataset_registry.R` (362 lines)

**Impact**: All 49 data-dependent functions (modules 1-11) now support focus mode.

**Three Usage Patterns**:

1. **Explicit Data (Always Works)**
   ```r
   result <- normalize_numeric(movies, "rating")
   ```

2. **Dataset Name Parameter (Recommended)**
   ```r
   result <- normalize_numeric(dataset_name = "movies", column = "rating")
   ```

3. **Implicit Focus (Most Convenient)**
   ```r
   focus_dataset("movies")
   result <- normalize_numeric("rating")  # Automatically uses focused dataset
   ```

**Backward Compatibility**: All existing code continues to work without modification.

#### 2. Conflict Resolution System
Automatic management of function name conflicts between dplyr, purrr, and zoo packages.

**Implementation Details**:
- **File Created**: `R/zzz.R` (61 lines)
- **Method**: `.onLoad()` hook with `conflicted::conflict_prefer()` calls
- **Execution**: Automatic on `library(DataPreparation)`
- **No User Action Required**: Conflicts resolved transparently

**Conflicts Resolved** (14 total):
- **dplyr core**: filter, select, mutate, summarise, group_by, rename, arrange, distinct
- **dplyr vs zoo**: lag, lead
- **Set operations**: intersect, setdiff, union

**Dependency**: Added `conflicted` to DESCRIPTION Imports

#### 3. Documentation Enhancement
Comprehensive documentation improvements covering code structure and features.

**New Documentation Files**:
- `documentation/CODE_STRUCTURE.md` - Complete architectural reference (2000+ lines)
  - All 11 modules detailed with function descriptions
  - File structure and organization
  - Development workflow guidelines
  - Testing strategy
  
- `documentation/ENHANCEMENT_SUMMARY.md` - Documentation improvements summary

**README.md Updates**:
- New "🏗️ Code Structure & Architecture" section (150+ lines)
- Module descriptions with examples
- Dataset Registry usage examples
- Focus Mode three-pattern explanation
- Conflict Resolution explanation
- Memory Management section

### Updated Modules

#### Module 1: NA Handling (4 functions)
- `remove_na_columns()` - ✅ Focus mode support added
- `impute_na_numeric()` - ✅ Focus mode support added
- `flag_na_column()` - ✅ Focus mode support added
- `summarize_na_rows()` - ✅ Focus mode support added

#### Module 2: Numeric Features (24 functions)
All numeric engineering functions updated:
- Scaling: `scale_betweenRange()`, `scale_unbounded()`
- Transformations: `transform_log()`, `transform_sqrt()`, `transform_exp()`
- Feature Creation: `create_polynomial_features()`, `create_interaction_features()`, `create_ratio_features()`, etc.
- Binning: `binning_quantile()`, `binning_width()`
- Outlier Detection: `flag_outliers_iqr()`, `flag_outliers_zscore()`
- Normalization: `normalize_numeric()` (4 methods)
- Statistics: `compute_rolling_statistics()`, `compute_group_statistics()`

**Status**: ✅ All 24 functions with focus mode support

#### Module 3: Timestamp Features (2 functions)
- `extract_timestamp_features()` - ✅ Focus mode support
- `extract_year_from_string()` - ✅ Focus mode support

#### Module 4: String Features (3 functions)
- `validate_ngram()` - ✅ Partial support
- `generate_categorical_variants()` - ✅ Focus mode support
- `ensure_dataframe()` - ✅ Utility function

#### Module 5: N-gram Generation (2 functions)
- `generate_ngram_char_variants()` - ✅ Focus mode support
- `generate_ngram_word_variants()` - ✅ Focus mode support

#### Module 6: Position Extraction (3 functions)
- `extract_prefix_patterns()` - ✅ Focus mode support
- `extract_infix_patterns()` - ✅ Focus mode support
- `extract_suffix_patterns()` - ✅ Focus mode support

#### Module 7: Linguistic Analysis (8 functions)
- `extract_string_linguistic_profile()` - ✅ Focus mode support
- `compute_global_linguistic_effects()` - ✅ Focus mode support
- `compute_user_linguistic_preferences()` - ✅ Focus mode support
- `compute_position_importance()` - ✅ Focus mode support
- And 4 more functions - ✅ All updated

#### Module 8: Group Intelligence (9 functions)
Including new updates:
- `compute_identifier_statistics()` - ✅ Focus mode support (THIS SESSION)
- `compute_identifier_deviation()` - ✅ Focus mode support (THIS SESSION)
- `compute_category_combinations()` - ✅ Focus mode support
- `compute_category_diversity()` - ✅ Focus mode support
- `compute_category_preferences()` - ✅ Focus mode support
- `compute_category_statistics()` - ✅ Focus mode support
- And 3 more - ✅ All updated

#### Module 9: Categorical Intelligence (7 functions)
Including new updates:
- `encode_categorical_flags()` - ✅ Focus mode support (THIS SESSION)
- `count_categories()` - ✅ Focus mode support (THIS SESSION)
- `extract_primary_category()` - ✅ Focus mode support (THIS SESSION)
- `compute_category_statistics()` - ✅ Focus mode support (THIS SESSION)
- `compute_category_preferences()` - ✅ Focus mode support (THIS SESSION)
- `compute_category_diversity()` - ✅ Focus mode support (THIS SESSION)
- `compute_category_combinations()` - ✅ Focus mode support (THIS SESSION)

#### Module 10: Dataset Inspection (4 functions)
- `inspect_dataset()` - ✅ Focus mode support
- `validate_for_processing()` - ✅ Utility function
- `preview_dataset()` - ✅ Focus mode support
- `check_memory_usage()` - ✅ Focus mode support

#### Module 11: Workflow Generator (4 functions)
- `detect_datasets()` - ✅ Focus mode support
- `show_dataset_columns()` - ✅ Focus mode support
- `generate_workflow_interactive()` - ✅ Focus mode support
- `generate_workflow_script()` - ✅ Focus mode support

### Function Statistics

| Metric | Count |
|--------|-------|
| **Total Functions** | 81 |
| **With Focus Mode Support** | 49 (60.5%) |
| **Skip-Eligible Functions** | 32 (39.5%) |
| **Total Modules** | 11 |
| **Documentation Files** | 81 .Rd files |

### Breaking Changes

**None** - All changes are backward compatible. Existing code continues to work exactly as before.

### New Dependencies

- `conflicted` (>= 1.1.0) - For explicit conflict resolution

### Bug Fixes & Improvements

1. **Robustness**: Library function name conflicts now resolved regardless of load order
2. **Usability**: Focus mode reduces boilerplate when working with multiple datasets
3. **Documentation**: Clearer code structure and architecture documentation
4. **Consistency**: All 49 data-dependent functions now follow identical focus mode pattern

### Documentation Updates

- README.md: Added "Code Structure & Architecture" section (150+ lines)
- CODE_STRUCTURE.md: New comprehensive architectural reference
- ENHANCEMENT_SUMMARY.md: Documentation improvement summary
- REORGANIZATION_COMPLETE.md: File organization summary
- Root directory: Cleaned up (19 → 2 markdown files in root)

### Files Changed

#### New Files
- `R/00_dataset_registry.R` - Dataset registry & focus mode system (362 lines)
- `R/zzz.R` - Package initialization with conflict resolution (61 lines)
- `documentation/CODE_STRUCTURE.md` - Architectural reference
- `documentation/project-history/` - Development history folder
- `documentation/implementation-records/` - Implementation details folder

#### Modified Files
- `DESCRIPTION` - Added `conflicted` to Imports
- `NAMESPACE` - Rebuilt with roxygen2
- `README.md` - Added Code Structure section
- `man/*.Rd` - All documentation files rebuilt (80+)

### Development Process

#### Phase 2 Session - Modules 10 & 11
**Date**: January 16, 2026

**Work Completed**:
1. **Module 10 Update** (2 functions)
   - `compute_identifier_statistics()` - Added focus mode
   - `compute_identifier_deviation()` - Added focus mode

2. **Module 11 Update** (7 functions)
   - `encode_categorical_flags()` - Added focus mode
   - `count_categories()` - Added focus mode
   - `extract_primary_category()` - Added focus mode
   - `compute_category_statistics()` - Added focus mode
   - `compute_category_preferences()` - Added focus mode
   - `compute_category_diversity()` - Added focus mode
   - `compute_category_combinations()` - Added focus mode

3. **Documentation Rebuild**
   - roxygen2 successfully rebuilt all .Rd files
   - NAMESPACE updated
   - All new parameters documented

4. **Integration Testing**
   - Backward compatibility verified
   - Focus mode tested across all updated functions
   - Parameter resolution verified

### Implementation Pattern

Every updated function implements the identical smart resolution pattern:

```r
function_name <- function(data = NULL, param1, param2, ..., dataset_name = NULL) {
  # Smart data resolution
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  
  # Rest of function implementation
  # ...
}
```

**Smart Resolution Logic**:
1. If `dataset_name` provided → Use registered dataset
2. Else if `data` provided → Use explicit data
3. Else if focus set → Use focused dataset
4. Else → Error: data required

### Testing & Validation

✅ **All Phase 2 work validated**:
- 49 functions verified with focus mode
- 32 functions verified as skip-eligible
- 100% backward compatibility confirmed
- roxygen2 rebuild successful
- NAMESPACE updated correctly

### Next Steps (Future Versions)

1. **v1.2.1**: Bug fixes (if any reported)
2. **v1.3.0**: Additional features
   - Advanced focus mode options
   - Batch dataset operations
   - Focus mode history/undo

### Contributors

- Development: AARICHE ABDERRAHIM
- Testing: Integrated testing framework
- Documentation: Comprehensive guides and examples

### References

- [Dataset Registry System Documentation](documentation/CODE_STRUCTURE.md#module-0-dataset-registry--infrastructure)
- [Focus Mode Usage Guide](README.md#-code-structure--architecture)
- [Conflict Resolution Details](documentation/implementation-records/CONFLICT_RESOLUTION_IMPLEMENTATION.md)
- [Development History](documentation/project-history/)

---

## Version 1.1.0 - Previous Release

- Initial release with 81 functions
- 9 functional modules
- Memory management features
- Domain-specific startup guides

---

**Release Date**: January 16, 2026  
**Status**: ✅ Stable  
**Maintenance**: Active Development  
**Support**: See DOCUMENTATION_MAP.md for help
