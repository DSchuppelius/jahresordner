# Automatisiertes Ordner-Setup für Mandanten- und Kundenordner

Dieses Projekt enthält Skripte für PowerShell und Bash, die ein automatisiertes Setup von Ordnerstrukturen für Mandanten- bzw. Kundenordner ermöglichen. Basierend auf einem Musterverzeichnis können für jedes Jahr neue Ordner für die Jahresabschluss- und Finanzbuchhaltungsunterlagen erstellt und an die Mandantenordner angepasst werden.

## Funktionsweise

1. **Musterverzeichnis:** Im Verzeichnis `- Neuer Mandant -` werden standardmäßig die Ordner für vergangene Jahre, z. B. `2018 JA` und `2018 FIBU`, angelegt. Diese Ordner dienen als Vorlage für die Erstellung neuer Jahresordner inkl. Unterordner.
   
2. **Automatische Ordnererstellung:** Die Skripte generieren bei Bedarf automatisch Ordner für das aktuelle und das folgende Jahr, z. B. `2019 JA`, `2019 FIBU`, `2020 JA` und `2020 FIBU`. Diese neuen Jahresordner werden vom Musterverzeichnis kopiert und in die jeweiligen Mandantenordner eingefügt, falls sie noch nicht vorhanden sind.

3. **Datenverzeichnis-Struktur:** Es existieren zwei besondere Ordner im Datenverzeichnis:
   - **Backupverzeichnis:** Dient zur Archivierung alter Mandanten oder Kunden und wird durch die Skripte nicht verändert.
   - **Musterverzeichnis:** Dient als Skeleton für die Ordnerstruktur und bleibt unverändert. Es kann später versteckt oder an einen anderen Ort verschoben werden.

## Verwendung

Beide Skripte, für PowerShell und Bash, nehmen als Parameter den Pfad des Kundenordners entgegen und erstellen dort die benötigten Ordnerstrukturen. Das Backup- und Musterverzeichnis bleiben dabei unverändert.

### Beispiel

Für die Kundenordner `Mandant 1` und `Mandant 2` werden bei Ausführung der Skripte die Ordner `2019 JA`, `2019 FIBU`, `2020 JA` und `2020 FIBU` erstellt, falls diese noch nicht vorhanden sind.

### Anforderungen

- **PowerShell**: Windows-Systeme
- **Bash**: Unix-basierte Systeme

## Installation

Kopiere die Skripte in dein Verzeichnis und rufe sie mit dem entsprechenden Kundenordner als Parameter auf.

## Beispielaufruf

PowerShell:
```powershell
.\jahresordner.ps1 -CustomerPath "Pfad\zum\Mandantenordner"
```
Bash:
```bash
./jahresordner.sh /Pfad/zum/Mandantenordner
```
