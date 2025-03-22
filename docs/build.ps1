### BEGIN FONT CHECK
# Load the System.Drawing assembly (required for accessing installed fonts)
Add-Type -AssemblyName System.Drawing

# Create a hashtable mapping font names to download links
$fontDictionary = @{
    "Open Sans" = "https://fonts.google.com/specimen/Open+Sans?query=open+sans"
    "Noto Sans" = "https://fonts.google.com/noto/specimen/Noto+Sans"
    "SimHei" = "https://fontzone.net/font-download/simhei"
    "KaiTi" = "https://fontzone.net/font-download/kaiti"
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
    # We have to run from the "source" dir because of asset resolution pathing for things like click.wav

    $source_dir = "."
    $build_dir = "..\build"
    uv run sphinx-build $source_dir $build_dir
} finally {
    Pop-Location
}