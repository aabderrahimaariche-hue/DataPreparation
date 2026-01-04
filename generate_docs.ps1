# PowerShell script to generate NAMESPACE
# This script runs R commands to generate documentation

$rScript = @'
library(devtools)
library(roxygen2)

cat("Generating NAMESPACE and documentation...\n\n")

# Generate documentation from roxygen2 comments
document()

cat("\n✅ SUCCESS: NAMESPACE and man pages generated!\n")
'@

# Write script to temp file
$tempScript = [System.IO.Path]::GetTempFileName() + ".R"
Set-Content -Path $tempScript -Value $rScript

# Run R with the script
Write-Host "Running roxygen2 documentation generation..."
& "C:\Program Files\R\R-4.5.2\bin\Rscript.exe" $tempScript

# Clean up
Remove-Item -Path $tempScript -Force
