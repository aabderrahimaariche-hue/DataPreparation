# Professional Development Workflow

**For**: DataPreparation Package Contributors  
**Purpose**: Guide for adding new features, modules, and functions  
**Version**: 1.0  
**Last Updated**: January 16, 2026

---

## Table of Contents

1. [Overview](#overview)
2. [The 8-Step Professional Workflow](#the-8-step-professional-workflow)
3. [Step-by-Step Implementation](#step-by-step-implementation)
4. [Templates & Checklists](#templates--checklists)
5. [Examples from Phase 2](#examples-from-phase-2)
6. [Best Practices](#best-practices)
7. [Quality Standards](#quality-standards)

---

## Overview

This document describes the **professional development workflow** used in the DataPreparation package. Following this process ensures:

- ✅ **Consistency** - All modules follow same patterns
- ✅ **Quality** - Code passes all checks before merging
- ✅ **Documentation** - Features are properly documented
- ✅ **Backward Compatibility** - Existing code never breaks
- ✅ **Maintainability** - Future contributors understand decisions
- ✅ **Scalability** - Process works as project grows

---

## The 8-Step Professional Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    MODULE DEVELOPMENT FLOW                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. SPECIFICATION                                               │
│     └─> Define requirements, plan signatures                   │
│                                                                 │
│  2. DESIGN                                                      │
│     └─> Create design document, plan dependencies              │
│                                                                 │
│  3. IMPLEMENTATION                                              │
│     └─> Write code, add docs, implement patterns               │
│                                                                 │
│  4. UNIT TESTING                                                │
│     └─> Test functions, edge cases, integrations               │
│                                                                 │
│  5. CODE REVIEW                                                 │
│     └─> Self-review checklist, style consistency               │
│                                                                 │
│  6. INTEGRATION TESTING                                         │
│     └─> Test with other modules, cross-module functions        │
│                                                                 │
│  7. DOCUMENTATION                                               │
│     └─> Update README, CODE_STRUCTURE, CHANGELOG               │
│                                                                 │
│  8. FINAL CLEANUP & MERGE                                       │
│     └─> Clean code, rebuild roxygen2, commit git               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Implementation

### STEP 1: SPECIFICATION

**Purpose**: Define what you're building before writing code

**Create a specification document** with:

#### 1.1 Module Overview
```
Module Name: [Name]
Purpose: [What this module does]
Target Version: [e.g., v1.3.0]
Estimated Timeline: [Time estimate]
Dependencies: [Other modules/packages needed]
```

#### 1.2 Function List
```
Function 1: name_function()
  - Purpose: What it does
  - Inputs: parameter1 (type), parameter2 (type)
  - Outputs: Return type and structure
  - Focus Mode: Yes/No
  
Function 2: name_function()
  - Purpose: What it does
  - Inputs: ...
  - Outputs: ...
  - Focus Mode: Yes/No
```

#### 1.3 Dependencies & Integration
```
- Module depends on: [Other modules]
- Functions that will use this module: [List]
- Backward compatibility: [Any breaking changes?]
```

#### 1.4 Success Criteria
```
- [ ] All X functions implemented
- [ ] All functions pass unit tests
- [ ] Focus mode works (if applicable)
- [ ] Documentation complete
- [ ] Zero backward incompatibilities
```

**Example from Phase 2:**
```
Module Name: Module 10 & 11 Updates
Purpose: Add focus mode support to remaining functions
Functions: compute_identifier_statistics, compute_identifier_deviation, 
           encode_categorical_flags, count_categories, etc.
Focus Mode: Yes (all functions)
Success: 9 functions updated with focus mode support
```

---

### STEP 2: DESIGN

**Purpose**: Plan how you'll implement before writing code

**Create a design document** with:

#### 2.1 Architecture Decisions
```
- How will this module interact with others?
- Will it modify existing functions? (version impact)
- Any new data structures?
- Performance considerations?
```

#### 2.2 Function Signatures (Draft)
```r
# Function 1 signature
function_name <- function(data = NULL, param1, param2, ..., dataset_name = NULL)

# Function 2 signature
another_function <- function(data = NULL, param1, ..., dataset_name = NULL)
```

#### 2.3 Dependencies Map
```
This module depends on:
  - dplyr functions: filter, mutate, group_by
  - Custom functions: resolve_data_source()
  - Package: zoo (lag, lead functions)
```

#### 2.4 Testing Strategy
```
- Unit tests for: [each function]
- Integration tests for: [cross-module interactions]
- Edge cases to test: [NA, empty data, NULL, etc.]
```

**Example from Phase 2:**
```
Design Decision: Use smart resolver pattern for focus mode
  - All 49 functions follow same 3-line resolver block
  - Consistent behavior across entire package
  - Easy to understand and maintain

Function Signature Pattern:
  function_name <- function(data = NULL, ..., dataset_name = NULL) {
    data_source <- resolve_data_source(data, dataset_name)
    data <- data_source$data
    # rest of implementation
  }
```

---

### STEP 3: IMPLEMENTATION

**Purpose**: Write the actual code following established patterns

#### 3.1 File Organization
```
Location: R/[module_number]_[module_name].R
Example: R/10_group_intelligence.R

Structure:
  - Header comment (module description)
  - Function 1 (roxygen2 docs + code)
  - Function 2 (roxygen2 docs + code)
  - ... (additional functions)
```

#### 3.2 Code Pattern
```r
#' Function Title
#'
#' Detailed description of what function does.
#'
#' @param data Optional. Input dataset. If NULL, uses dataset_name or focus.
#'   Default: NULL
#'
#' @param param1 Required. Description
#'
#' @param dataset_name Optional. Name of registered dataset to use.
#'   Default: NULL
#'
#' @details
#' Supports three usage modes:
#' 1. Explicit: function(data, param1)
#' 2. Dataset name: function(dataset_name = "name", param1)
#' 3. Focus mode: focus_dataset("name"); function(param1)
#'
#' @return Description of return value
#'
#' @export
function_name <- function(data = NULL, param1, param2, ..., dataset_name = NULL) {
  
  # Smart data resolution (required for focus mode)
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  
  # Validate inputs
  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }
  
  # Main implementation
  result <- # ... your logic ...
  
  # Return result
  result
}
```

#### 3.3 Focus Mode Integration (if applicable)
All data-dependent functions must support focus mode:
- ✅ Make `data` parameter optional (default NULL)
- ✅ Add `dataset_name` parameter (default NULL)
- ✅ Add 3-line smart resolver block
- ✅ Document all three usage modes

#### 3.4 Documentation Requirements
```
Every function must have:
  - Title (@title)
  - Description (@description)
  - Parameter documentation (@param for each parameter)
  - Return value documentation (@return)
  - Usage examples (@examples)
  - @export tag (if should be available to users)
```

**Example from Phase 2:**
```r
#' Compute Identifier Statistics
#'
#' Calculate per-identifier statistics (mean, std, median, count) 
#' for numeric values within groups.
#'
#' @param data Optional. A data frame. If NULL, uses dataset_name or focus.
#' @param identifier_col Column containing identifier/group names
#' @param value_col Column containing numeric values to summarize
#' @param include_stats Vector of statistics to compute
#' @param dataset_name Optional. Registered dataset name to use
#'
#' @return Data frame with identifier and computed statistics
#'
#' @export
compute_identifier_statistics <- function(
  data = NULL,
  identifier_col,
  value_col,
  include_stats = c("mean", "std", "median", "min", "max", "count"),
  dataset_name = NULL
) {
  
  # Smart resolution
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  
  # Implementation...
}
```

---

### STEP 4: UNIT TESTING

**Purpose**: Verify each function works correctly in isolation

#### 4.1 Test Coverage
Create tests for each function covering:

```
Basic Functionality:
  - [ ] Function runs without error
  - [ ] Output is correct type (data.frame, vector, etc.)
  - [ ] Output dimensions are correct
  - [ ] Output values are reasonable

Parameter Testing:
  - [ ] Required parameters are enforced
  - [ ] Optional parameters work correctly
  - [ ] Invalid parameters raise errors

Edge Cases:
  - [ ] Empty data.frame
  - [ ] Single row data
  - [ ] NA/NULL values in data
  - [ ] Special characters in strings
  - [ ] Extreme numeric values
  - [ ] Column not found errors
```

#### 4.2 Test Template
```r
# Test file: test-10-group-intelligence.R
test_that("compute_identifier_statistics works with explicit data", {
  df <- data.frame(
    id = c("A", "A", "B", "B"),
    value = c(10, 20, 30, 40)
  )
  
  result <- compute_identifier_statistics(df, "id", "value")
  
  expect_is(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("mean" %in% names(result))
})

test_that("compute_identifier_statistics works with focus mode", {
  df <- data.frame(id = c("A", "A", "B"), value = c(10, 20, 30))
  register_dataset(df, "test")
  focus_dataset("test")
  
  result <- compute_identifier_statistics("id", "value")
  
  expect_is(result, "data.frame")
  expect_equal(nrow(result), 2)
})
```

#### 4.3 Running Tests
```r
# In R console:
devtools::test()

# Or run specific test file:
devtools::test(file = "test-10-group-intelligence.R")
```

**Phase 2 Example:**
```
Tested 9 new functions (Modules 10-11):
  - compute_identifier_statistics: ✅ Passed
  - compute_identifier_deviation: ✅ Passed
  - encode_categorical_flags: ✅ Passed
  - count_categories: ✅ Passed
  - extract_primary_category: ✅ Passed
  - compute_category_statistics: ✅ Passed
  - compute_category_preferences: ✅ Passed
  - compute_category_diversity: ✅ Passed
  - compute_category_combinations: ✅ Passed
```

---

### STEP 5: CODE REVIEW

**Purpose**: Ensure code quality, style, and best practices

#### 5.1 Self-Review Checklist
```
Code Quality:
  - [ ] Code is readable and understandable
  - [ ] Variable names are descriptive
  - [ ] No unnecessary comments (code should be self-documenting)
  - [ ] No duplicate code (DRY principle)
  - [ ] Error handling for invalid inputs
  - [ ] Appropriate data structures used

Style Consistency:
  - [ ] Follows R style guide (snake_case for functions)
  - [ ] Consistent indentation (2 spaces)
  - [ ] Consistent naming conventions
  - [ ] Consistent code structure with other modules

Documentation:
  - [ ] roxygen2 comments complete
  - [ ] @param for all parameters
  - [ ] @return documented
  - [ ] @examples provided and tested
  - [ ] @details explains usage modes

Focus Mode (if applicable):
  - [ ] data parameter is optional
  - [ ] dataset_name parameter exists
  - [ ] Smart resolver block present
  - [ ] Three usage modes documented
  - [ ] All three modes tested

Performance:
  - [ ] Function runs in reasonable time
  - [ ] Memory usage is acceptable
  - [ ] No unnecessary loops/operations
  - [ ] Vectorized operations used where appropriate

Backward Compatibility:
  - [ ] No breaking changes to existing functions
  - [ ] New functions don't conflict with existing names
  - [ ] Default parameters maintain existing behavior
```

#### 5.2 Review Process
```
1. Read your own code as if seeing it first time
2. Check each item on the checklist
3. Make corrections
4. Ask: "Would another developer understand this easily?"
5. Run devtools::check() to catch any issues
```

**Phase 2 Example:**
```
Reviewed 9 functions:
  ✅ All followed consistent focus mode pattern
  ✅ roxygen2 documentation complete
  ✅ No style inconsistencies
  ✅ Error handling appropriate
  ✅ 100% backward compatible
```

---

### STEP 6: INTEGRATION TESTING

**Purpose**: Verify module works correctly with other modules

#### 6.1 Integration Test Checklist
```
Cross-Module Interaction:
  - [ ] Functions work with data from other modules
  - [ ] Outputs compatible with other module inputs
  - [ ] No function name conflicts
  - [ ] Proper use of shared utilities

Backward Compatibility:
  - [ ] Existing tests still pass
  - [ ] Existing functions still work
  - [ ] No performance degradation
  - [ ] No API changes to public functions

Registry/Focus Mode:
  - [ ] Focus mode works across modules
  - [ ] Datasets persist across function calls
  - [ ] Focus switching works correctly
  - [ ] Multiple datasets can be registered

Conflict Resolution:
  - [ ] No new library conflicts
  - [ ] Existing conflict resolution still works
  - [ ] No ambiguous function calls
```

#### 6.2 Integration Test Example
```r
test_that("new module integrates with existing functions", {
  # Use multiple datasets
  df1 <- data.frame(id = 1:5, value = c(10, 20, 30, 40, 50))
  df2 <- data.frame(id = 1:3, category = c("A", "B", "A"))
  
  # Register both
  register_dataset(df1, "data1")
  register_dataset(df2, "data2")
  
  # Use old module
  focus_dataset("data1")
  result1 <- normalize_numeric("value")
  
  # Switch to new module with new function
  focus_dataset("data2")
  result2 <- encode_categorical_flags("category")
  
  # Verify both work
  expect_is(result1, "data.frame")
  expect_is(result2, "data.frame")
})
```

**Phase 2 Example:**
```
Integration Testing:
  ✅ New functions work with Module 1-9 functions
  ✅ Focus mode works across all modules
  ✅ All 49 focus-enabled functions tested together
  ✅ Backward compatibility verified
  ✅ No regressions detected
```

---

### STEP 7: DOCUMENTATION

**Purpose**: Update package documentation to reflect changes

#### 7.1 Files to Update

**README.md**
```markdown
# Add to Features section if new capability:
### Module X: [New Module Name]
- Function1() - Description
- Function2() - Description
```

**documentation/CODE_STRUCTURE.md**
```markdown
# Add module documentation:
### Module X: [Module Name]
**File**: R/X_module_name.R (XXX lines)
**Purpose**: [What module does]
**Functions**: [List with descriptions]
**Key Features**: [Notable aspects]
```

**documentation/CHANGELOG.md**
```markdown
## Module [X] - [New Module Name]
- Added X functions
- Features: [List]
- All functions support focus mode
```

**documentation/DEVELOPMENT_HISTORY.md**
```markdown
### Module X Addition - [Date]
**Work Completed**:
- Implemented X functions
- Added focus mode support
- Comprehensive testing

**Statistics**:
- Functions added: X
- Lines of code: XXX
- Test coverage: 100%
```

#### 7.2 Update Checklist
```
- [ ] README.md updated with new features
- [ ] CODE_STRUCTURE.md updated with module details
- [ ] CHANGELOG.md updated with version info
- [ ] DEVELOPMENT_HISTORY.md updated with timeline
- [ ] Examples added to documentation (if applicable)
- [ ] All cross-references updated
```

**Phase 2 Example:**
```
Updated Documentation:
  ✅ README.md - Added Module 10-11 descriptions
  ✅ CODE_STRUCTURE.md - Detailed all new functions
  ✅ CHANGELOG.md - Created v1.2.0 release notes
  ✅ DEVELOPMENT_HISTORY.md - Added Phase 2 timeline
  ✅ All 9 functions documented in .Rd files
```

---

### STEP 8: FINAL CLEANUP & MERGE

**Purpose**: Finalize code and prepare for release

#### 8.1 Final Checklist
```
Code:
  - [ ] All code follows style guide
  - [ ] No debug code or comments left
  - [ ] No hardcoded values
  - [ ] Proper error handling

Documentation:
  - [ ] roxygen2 documentation complete
  - [ ] README updated
  - [ ] CODE_STRUCTURE updated
  - [ ] CHANGELOG updated
  - [ ] Examples work

Testing:
  - [ ] All unit tests pass
  - [ ] All integration tests pass
  - [ ] devtools::check() passes
  - [ ] No warnings or errors

Git:
  - [ ] Changes staged
  - [ ] Commit message clear
  - [ ] Branch merged to main
```

#### 8.2 Pre-Release Steps
```r
# Rebuild documentation
roxygen2::roxygenise()

# Run full check
devtools::check()

# Run tests
devtools::test()

# Build and verify
devtools::build()
```

#### 8.3 Git Commit
```bash
git add .
git commit -m "Add Module X: [Module Name]

- Implemented X functions
- All functions support focus mode
- Complete test coverage
- Updated documentation
- Backward compatible"

git push origin main
```

**Phase 2 Example:**
```
Final Steps:
  ✅ roxygen2::roxygenise() - Documentation rebuilt
  ✅ devtools::check() - No errors or warnings
  ✅ devtools::test() - All tests pass
  ✅ Git commit - Clear commit message
  ✅ Version bump - 1.1.0 → 1.2.0 (CHANGELOG updated)
```

---

## Templates & Checklists

### Module Development Checklist

Use this checklist when starting a new module:

```
PHASE 1: SPECIFICATION
  [ ] Write module overview
  [ ] List all functions to implement
  [ ] Define function signatures
  [ ] Plan dependencies
  [ ] Identify integration points
  [ ] Set success criteria

PHASE 2: DESIGN
  [ ] Create design document
  [ ] Plan architecture
  [ ] Decide on patterns (focus mode, etc.)
  [ ] Plan testing strategy
  [ ] Design error handling

PHASE 3: IMPLEMENTATION
  [ ] Create R/[module].R file
  [ ] Implement all functions
  [ ] Add roxygen2 documentation
  [ ] Implement focus mode (if applicable)
  [ ] Add code comments where necessary

PHASE 4: UNIT TESTING
  [ ] Write tests for each function
  [ ] Test normal cases
  [ ] Test edge cases
  [ ] Test error conditions
  [ ] Run devtools::test()

PHASE 5: CODE REVIEW
  [ ] Self-review against checklist
  [ ] Check code quality
  [ ] Verify documentation completeness
  [ ] Run devtools::check()

PHASE 6: INTEGRATION TESTING
  [ ] Test with other modules
  [ ] Verify backward compatibility
  [ ] Test focus mode across modules
  [ ] Run full test suite

PHASE 7: DOCUMENTATION
  [ ] Update README.md
  [ ] Update CODE_STRUCTURE.md
  [ ] Update CHANGELOG.md
  [ ] Update DEVELOPMENT_HISTORY.md
  [ ] Add examples to documentation

PHASE 8: FINAL CLEANUP & MERGE
  [ ] Final code review
  [ ] Run roxygen2::roxygenise()
  [ ] Run devtools::check()
  [ ] Run devtools::test()
  [ ] Commit to git with clear message
  [ ] Update version number
```

### Module Template

**File**: `R/XX_module_name.R`

```r
#' Module Title
#'
#' Comprehensive description of what this module does, 
#' what problems it solves, and what functions it contains.
#'
#' This module includes X functions for [purpose]:
#' - function_name1() - What it does
#' - function_name2() - What it does
#'
#' All functions support three usage modes:
#' 1. Explicit data: function_name(data, param)
#' 2. Dataset name: function_name(dataset_name = "name", param)
#' 3. Focus mode: focus_dataset("name"); function_name(param)
#'
#' @import dplyr
#' @import tidyr
#'
#' @keywords internal
"_PACKAGE"

# ============================================================================
# Function 1: function_name1
# ============================================================================

#' Function Title
#'
#' Detailed description of what the function does.
#'
#' @param data Optional. A data frame. If NULL, uses dataset_name or focus.
#'   Default: NULL
#'
#' @param param1 Required. Description of param1
#'
#' @param param2 Optional. Description of param2
#'
#' @param dataset_name Optional. Name of registered dataset.
#'   Default: NULL
#'
#' @details
#' Additional details about how the function works, 
#' any important notes, or special behaviors.
#'
#' Supports three usage modes:
#' 1. Explicit: function_name1(my_data, param1)
#' 2. Dataset name: function_name1(dataset_name = "mydata", param1)
#' 3. Focus mode: focus_dataset("mydata"); function_name1(param1)
#'
#' @return Description of what the function returns
#'
#' @examples
#' # Create example data
#' df <- data.frame(
#'   id = 1:5,
#'   value = c(10, 20, 30, 40, 50)
#' )
#'
#' # Method 1: Explicit data
#' result <- function_name1(df, param1 = "value")
#'
#' # Method 2: Dataset name
#' register_dataset(df, "mydf")
#' result <- function_name1(dataset_name = "mydf", param1 = "value")
#'
#' # Method 3: Focus mode
#' focus_dataset("mydf")
#' result <- function_name1(param1 = "value")
#'
#' @export
function_name1 <- function(
  data = NULL,
  param1,
  param2 = NULL,
  dataset_name = NULL
) {
  
  # Smart data resolution
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  
  # Input validation
  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }
  
  if (!(param1 %in% names(data))) {
    stop("param1 column not found in data")
  }
  
  # Main implementation
  result <- # ... your logic ...
  
  return(result)
}

# ============================================================================
# Function 2: function_name2
# ============================================================================

# ... (additional functions follow same pattern)
```

---

## Examples from Phase 2

### Real Example: Module 10 Update

**SPECIFICATION**:
```
Module: Group Intelligence (Module 10)
New Functions: 2
  - compute_identifier_statistics()
  - compute_identifier_deviation()
Purpose: Add focus mode support
Target: v1.2.0
```

**IMPLEMENTATION** (First function):
```r
#' Compute Identifier Statistics
#'
#' Calculate per-identifier statistics for numeric values.
#'
#' @param data Optional. Data frame with identifier and value columns
#' @param identifier_col Column containing identifier/group names
#' @param value_col Column containing numeric values
#' @param include_stats Statistics to compute: mean, std, median, etc.
#' @param dataset_name Optional. Registered dataset name
#'
#' @details
#' Supports three usage modes:
#' 1. Explicit: compute_identifier_statistics(df, "id", "value")
#' 2. Dataset: compute_identifier_statistics(dataset_name="mydf", "id", "value")
#' 3. Focus: focus_dataset("mydf"); compute_identifier_statistics("id", "value")
#'
#' @export
compute_identifier_statistics <- function(
  data = NULL,
  identifier_col,
  value_col,
  include_stats = c("mean", "std", "median", "min", "max", "count"),
  dataset_name = NULL
) {
  
  # Smart resolver
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  
  # Implementation...
}
```

**TESTING**:
```r
test_that("compute_identifier_statistics works", {
  df <- data.frame(
    id = c("A", "A", "B"),
    value = c(10, 20, 30)
  )
  
  result <- compute_identifier_statistics(df, "id", "value")
  expect_is(result, "data.frame")
  expect_equal(nrow(result), 2)
})
```

**DOCUMENTATION UPDATE** (CHANGELOG):
```
### Module 10: Group Intelligence - Phase 2 Updates

**Functions Updated**:
- `compute_identifier_statistics()` - Added focus mode support
- `compute_identifier_deviation()` - Added focus mode support

**Status**: ✅ Complete
**Test Coverage**: ✅ 100%
**Breaking Changes**: None
```

---

## Best Practices

### 1. Always Use Focus Mode for Data-Dependent Functions
```r
# ✅ GOOD - Supports all three modes
my_function <- function(data = NULL, col, dataset_name = NULL) {
  data_source <- resolve_data_source(data, dataset_name)
  data <- data_source$data
  # ... implementation
}

# ❌ AVOID - Only supports explicit data
my_function <- function(data, col) {
  # ... implementation
}
```

### 2. Document All Three Usage Modes
```r
#' @details
#' Supports three usage modes:
#' 1. Explicit: my_function(data, param)
#' 2. Dataset name: my_function(dataset_name = "name", param)
#' 3. Focus mode: focus_dataset("name"); my_function(param)
```

### 3. Use Smart Parameter Names
```r
# ✅ GOOD - Clear, descriptive
function(data = NULL, identifier_col, value_col, dataset_name = NULL)

# ❌ AVOID - Ambiguous
function(d = NULL, id, val, dn = NULL)
```

### 4. Always Handle Edge Cases
```r
# ✅ GOOD - Handles edge cases
if (nrow(data) == 0) {
  return(data.frame())  # Return empty with correct structure
}

if (any(is.na(data[[col]]))) {
  warning("Column contains NA values, they will be removed")
}
```

### 5. Keep Functions Focused
```r
# ✅ GOOD - Single responsibility
scale_betweenRange <- function(data, col) {
  # Scales to 0-1 range only
}

# ❌ AVOID - Too many responsibilities
process_data <- function(data, ...) {
  # Scales, normalizes, encodes, transforms, etc.
}
```

### 6. Use Consistent Error Messages
```r
# ✅ GOOD - Clear, actionable
if (!is.data.frame(data)) {
  stop("'data' must be a data frame. Got ", class(data))
}

# ❌ AVOID - Vague
if (!is.data.frame(data)) {
  stop("Invalid input")
}
```

---

## Quality Standards

### Code Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Test Coverage** | 100% | All functions have tests |
| **Documentation** | 100% | All functions documented with roxygen2 |
| **Backward Compatibility** | 100% | No breaking changes |
| **Function Consistency** | 100% | All data-dependent functions follow same pattern |
| **Code Style** | 100% | Consistent with R style guide |
| **Error Handling** | >95% | All edge cases handled |

### Definition of Done

A module is considered "done" when ALL of the following are true:

```
✅ Specification document completed
✅ Design document created
✅ All functions implemented
✅ All roxygen2 documentation complete
✅ 100% unit test coverage
✅ 100% integration test coverage
✅ Self-review checklist passed
✅ Code style consistent
✅ README updated
✅ CODE_STRUCTURE updated
✅ CHANGELOG updated
✅ DEVELOPMENT_HISTORY updated
✅ devtools::check() passes with no errors/warnings
✅ devtools::test() passes all tests
✅ No backward incompatibilities
✅ Git commit completed
```

---

## Using This Document as a Prompt

### For AI Assistants / Code Generators

When adding a new module, you can use this workflow as a prompt:

```
I'm adding a new module to the DataPreparation R package.
Follow the Professional Development Workflow documented in DEVELOPMENT_WORKFLOW.md:

Module Name: [Module Name]
Functions: [List functions to add]
Purpose: [What the module does]

Please help me:
1. Create specification document
2. Write the module code with proper focus mode support
3. Create comprehensive tests
4. Update documentation
5. Ensure all steps are completed
```

---

## Summary

Following this **8-step professional workflow** ensures:

✅ **Consistency** across the codebase  
✅ **Quality** through multiple review stages  
✅ **Documentation** at every step  
✅ **Testing** at unit and integration levels  
✅ **Maintainability** for future contributors  
✅ **Scalability** as the project grows  

This workflow has been validated through Phase 2 development of the DataPreparation package.

---

**Questions?** Refer to:
- [README.md](README.md) - Package overview
- [documentation/CODE_STRUCTURE.md](documentation/CODE_STRUCTURE.md) - Architecture reference
- [documentation/IMPLEMENTATION_GUIDE.md](documentation/IMPLEMENTATION_GUIDE.md) - Technical details
- [documentation/DEVELOPMENT_HISTORY.md](documentation/DEVELOPMENT_HISTORY.md) - Past implementations

**Last Updated**: January 16, 2026  
**Status**: Production Ready  
**Version**: 1.0
