#!/bin/bash

# Funktion zum Beenden mit einer Nachricht
function ExitWithMessage() {
    echo "$1"
    exit 1
}

# Funktion zum Kopieren eines Ordners, falls dieser nicht existiert
function CopyFolderIfNotExist() {
    local sourcePath="$1"
    local destinationPath="$2"
    if [ ! -d "$destinationPath" ]; then
        cp -R "$sourcePath" "$destinationPath"
    fi
}

# Funktion zum Kopieren der Jahresordner
function CopyYearlyFolders() {
    local sourcePath="$1"
    local destinationPath="$2"
    local years=("${!3}")
    local folderTypes=("${!4}")
    local clonePreviousYear="$5"

    for year in "${years[@]}"; do
        for folderType in "${folderTypes[@]}"; do
            local srcYear="$year"
            if [ "$clonePreviousYear" = true ]; then
                ((srcYear--))
            fi
            local sourceChildPath="$sourcePath/${srcYear} $folderType"
            local destinationChildPath="$destinationPath/${year} $folderType"
            CopyFolderIfNotExist "$sourceChildPath" "$destinationChildPath"
        done
    done
}

# Überprüfen, ob das Mandantenverzeichnis übergeben wurde
customerFolder="$1"
if [ -z "$customerFolder" ]; then
    ExitWithMessage "Bitte als Parameter das Mandantenverzeichnis angeben."
elif [ ! -d "$customerFolder" ]; then
    ExitWithMessage "Mandantenverzeichnis existiert nicht."
fi

# Pfad-Variablen festlegen
customerFolder=$(realpath "$customerFolder")
newCustomerFolder="$customerFolder/- Neuer Mandant -"
bakCustomerFolder="$customerFolder/- Backup (Altdaten) -"

# Überprüfen, ob das Mandanten-Musterverzeichnis existiert
if [ ! -d "$newCustomerFolder" ]; then
    ExitWithMessage "Mandanten-Musterverzeichnis existiert nicht."
fi

# Aktuelles und nächstes Jahr festlegen
currentYear=$(date +%Y)
nextYear=$((currentYear + 1))
years=("$currentYear" "$nextYear")

# Jahresordner Suffix
folderTypes=("JA" "FIBU")

# Kopiere Vorjahresordner innerhalb des Mandanten-Musterverzeichnis
CopyYearlyFolders "$newCustomerFolder" "$newCustomerFolder" years[@] folderTypes[@] true

echo "Durchlaufe Mandantenverzeichnis."
for subFolder in "$customerFolder"/*/; do
    subFolder=${subFolder%/}  # Entferne den letzten Schrägstrich
    echo "    Prüfe auf Mandantenverzeichnis: $subFolder"
    if [ "$subFolder" != "$newCustomerFolder" ] && [ "$subFolder" != "$bakCustomerFolder" ]; then
        echo "       Darf beschrieben werden!"
        CopyYearlyFolders "$newCustomerFolder" "$subFolder" years[@] folderTypes[@] false
    fi
done
