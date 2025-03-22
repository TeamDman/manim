param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("HTML", "Markdown", "All", IgnoreCase = $true)]
    [string[]]$OutputFormat
)

# If "All" is specified, ignore any other values and build both formats.
if ($OutputFormat -contains "All") {
    $formatsToBuild = @("HTML", "Markdown")
} else {
    $formatsToBuild = $OutputFormat
}

### BEGIN FONT CHECK
# Load the System.Drawing assembly (required for accessing installed fonts)
Add-Type -AssemblyName System.Drawing

# Create a hashtable mapping font names to download links
$fontDictionary = @{
    "Open Sans" = "https://fonts.google.com/specimen/Open+Sans?query=open+sans"
    "Noto Sans" = "https://fonts.google.com/noto/specimen/Noto+Sans"
    "SimHei"    = "https://fontzone.net/font-download/simhei"
    "KaiTi"     = "https://fontzone.net/font-download/kaiti"
}

# Retrieve the list of installed fonts
$installedFonts = New-Object System.Drawing.Text.InstalledFontCollection
$installedFontNames = $installedFonts.Families | ForEach-Object { $_.Name }

# Check each font in the dictionary for availability
foreach ($font in $fontDictionary.Keys) {
    if ($installedFontNames -contains $font) {
        Write-Output "Font '$font' is installed."
    }
    else {
        Write-Output "Font '$font' is NOT installed. Download it from: $($fontDictionary[$font])"
    }
}
### END FONT CHECK

try {
    Push-Location source
    $source_dir = "."
    foreach ($format in $formatsToBuild) {
        # Choose the correct builder based on format.
        $builder = if ($format -ieq "Markdown") { "markdown" } else { "html" }
        # Define a subdirectory for each format output.
        $build_dir = "..\build\$format"
        # Create the build directory if it doesn't already exist.
        if (!(Test-Path $build_dir)) {
            New-Item -ItemType Directory -Path $build_dir | Out-Null
        }
        Write-Output "Building documentation in $format format using builder '$builder'..."
        uv run sphinx-build -b $builder $source_dir $build_dir
    }
} finally {
    Pop-Location
}
