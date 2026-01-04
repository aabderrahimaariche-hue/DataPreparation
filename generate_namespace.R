#!/usr/bin/env Rscript
# Generate NAMESPACE and man pages from roxygen2 documentation

library(devtools)
library(roxygen2)

cat("Generating NAMESPACE and documentation...\n")

# Generate documentation
document()

cat("\n✅ NAMESPACE and man pages generated successfully!\n")
cat("Files created in: man/ folder\n")
