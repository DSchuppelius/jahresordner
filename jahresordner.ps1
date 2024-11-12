param ($customerFolder)

function ExitWithMessage($message) {
    Write-Host $message
    exit
}

function CopyFolderIfNotExist($sourcePath, $destinationPath) {
    if (-not (Test-Path -Path $destinationPath)) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
    }
}

function CopyYearlyFolders($sourcePath, $destinationPath, $years, $folderTypes, $clonePreviousYear) {
    foreach ($year in $years) {
        foreach ($folderType in $folderTypes) {
            $srcYear = $year
            if($clonePreviousYear -eq $True) {
              $srcYear -= 1
            }
            $sourceChildPath = Join-Path -Path $sourcePath -ChildPath "${srcYear} $folderType"
            $destinationChildPath = Join-Path -Path $destinationPath -ChildPath "${year} $folderType"
            CopyFolderIfNotExist $sourceChildPath $destinationChildPath
        }
    }
}

# Überprüfen, ob das Mandantenverzeichnis existiert
if ([string]::IsNullOrWhitespace($customerFolder)) {
    ExitWithMessage "Bitte als Parameter das Mandantenverzeichnis angeben."
} elseif (-not (Test-Path -Path $customerFolder)) {
    ExitWithMessage "Mandantenverzeichnis existiert nicht."
}

# Pfad-Variablen festlegen
$customerFolder = [System.IO.Path]::GetFullPath($customerFolder)
$newCustomerFolder = Join-Path -Path $customerFolder -ChildPath "- Neuer Mandant -"
$bakCustomerFolder = Join-Path -Path $customerFolder -ChildPath "- Backup (Altdaten) -"

# Überprüfen, ob das Mandanten-Musterverzeichnis existiert
if (-not (Test-Path -Path $newCustomerFolder)) {
    ExitWithMessage "Mandanten-Musterverzeichnis existiert nicht."
}

# Aktuelles und nächstes Jahr festlegen
$years = @((Get-Date).Year, (Get-Date).AddYears(1).Year)

# Jahresordner Suffix
$folderTypes = @("JA", "FIBU")

# Kopiere Vorjahresordner innerhalb des Mandanten-Musterverzeichnis
CopyYearlyFolders $newCustomerFolder $newCustomerFolder $years $folderTypes true

Write-Host "Durchlaufe Mandantenverzeichnis."
Get-ChildItem -Path $customerFolder -Directory | ForEach-Object {
    $subFolder = $_.FullName
    Write-Host "    Prüfe auf Mandantenverzeichnis: " $subFolder
    if ($subFolder -ne $newCustomerFolder -and $subFolder -ne $bakCustomerFolder) {
        Write-Host "       Darf beschrieben werden!"
        CopyYearlyFolders $newCustomerFolder $subFolder $years $folderTypes false
    }
}
