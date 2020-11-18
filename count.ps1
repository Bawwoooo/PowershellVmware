
$FileContent = Get-Content "count.txt"
$Matches = Select-String -InputObject $FileContent -Pattern "YES" -AllMatches

Write-Host $Matches.Matches.Count virtual machine sur 10 ont été crées -Foreground Green
$Percent = $Matches.Matches.Count / 10 * 100
Write-Host $Percent "% des machines sont crées" -Foreground Red
If ($Matches.Matches.Count -eq'1') {
Write-Host '⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'2') {
Write-Host '⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'3') {
Write-Host '⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'4') {
Write-Host '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'5') {
Write-Host '⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'6') {
Write-Host '⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'7') {
Write-Host '⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'8') {
Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜'
}
If ($Matches.Matches.Count -eq'9') {
Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜'
}
If ($Matches.Matches.Count -eq'&0') {
Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛'
}

Clear-Content "count.txt"