                                ##########################################################################
                                ######## Script creating multiple Virtual Machines in VMWare ESXi ########
                                ##########################################################################


# Create by: Aurélien BERT
# Latest version: 17/11/2020
# Contact: aurelien.bert23@gmail.com
# School: ESGI


## Variables
#
# Path of the csv file
$VMs = "abe-csv.csv"
#
# Import csv and delimiter
$ListVMs = Import-csv -Path "abe-csv.csv" -Delimiter ","
#
# Logs script with date
$date = get-date -format yyyy-MM-dd-hhmm
$Logs = Start-Transcript -Path "abe-logs-$date.txt"
#
$i = 1
#
## End Variables

Write-Host "`nFile where Logs are redirected :`n" -Foreground DarkYellow

$Logs

Write-Host "`nList of Virtual Machines you want to create:" -Foreground DarkBlue

$ListVMs

Write-Host "`nConnecting to vCenter Server..." -Foreground Yellow

Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Write-Host "We are going to create the 10 Virtual Machines. Do you want to proceed ? (Enter " -Foreground DarkCyan -NoNewLine
Write-Host "YES" -Foreground Green -NoNewLine 
Write-Host " or " -Foreground DarkCyan -NoNewLine 
Write-Host "NO" -Foreground Red -NoNewLine 
Write-Host ")`n" -Foreground DarkCyan

$Read = Read-Host

if ($Read -eq "YES") {

    foreach ($VM in $ListVMs) {
            
        ## Assign Variables
        #
        # Specify the vSphere Cluster
        $VMCluster = $VM.VMCluster
        #
        # Specify the DatastoreCluster
        $ClusterData = $VM.DSCluster   
        #
        # Specify the Virtual Machine name 
        $VMPrefix = $VM.Name
        $VMname = $VMPrefix
        #
        # Specify number of VM CPUs
        $vCpu = $VM.vCpu
        #
        # Specify number of VM vMemory (in MB)
        $vMemoryMB = $VM.vMemoryMB
        #
        # Specify VM Disk size (in MB)
        $VHDiskMB = $VM.VHDiskMB
        #
        # Specify VM Disk storage format (in EagerZeroedThick)
        $VHDiskStorageFormat = $VM.VHDiskStorageFormat
        #
        # Specify description of the Virtual Machine
        $Description = $VM.Description
        #
        # Specify the version of the Virtual Machine
        $Version = $VM.Version
        #
        ## End of Assign Variables
			
        Write-Host "`nSummary :`n" -Foreground Yellow
            
        $VM
            
        Write-Host "`nDo you want to create the Virtual Machine number" $i " : " -NoNewLine
        Write-Host "YES" -Foreground Green -NoNewLine 
        Write-Host " or " -NoNewLine 
        Write-Host "NO" -Foreground Red -NoNewLine 
        Write-Host " ?`n" 
            
        $i++

        $Read2 = Read-Host
        $Read2 >> "./count.txt"
        if ($Read2 -eq "YES") {
            Write-Host "`nBuilding Virtual Machine..." -Foreground Green
			
            $DSCluster = Get-DatastoreCluster -Name $ClusterData
            $ESXi = Get-Cluster $VMCluster | Get-VMHost -state connected | Get-Random
			
            NEW-VM -VMHost $ESXi -Datastore $DSCluster -Name $VMName -NumCpu $vCpu -MemoryMB $vMemoryMB -DiskMB $VHDiskMB -DiskStorageFormat $VHDiskStorageFormat -Version $Version -Location $Folder -Notes $Description
                
            $error[0] >> errors$date.txt

            Write-Host "`nVirtual Machine was created.`n" -Foreground Green  
			
            Start-Sleep 2
				
        }
    
        else {
            Write-Host "`nVirtual Machine wasn't created.`n" -Foreground Red
        }
            
    }
}

else {
    exit
}
$FileContent = Get-Content "count.txt"
$Matches = Select-String -InputObject $FileContent -Pattern "YES" -AllMatches
Write-Host $Matches.Matches.Count virtual machine sur 10 ont été crées -Foreground Green
$Percent = $Matches.Matches.Count / 10 * 100
Write-Host $Percent "% des machines sont crées" -Foreground Red
If ($Matches.Matches.Count -eq'1') {
Write-Host '🟩⬜⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'2') {
Write-Host '🟩🟩⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'3') {
Write-Host '🟩🟩🟩⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'4') {
Write-Host '🟩🟩🟩🟩⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'5') {
Write-Host '🟩🟩🟩🟩🟩⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'6') {
Write-Host '🟩🟩🟩🟩🟩🟩⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'7') {
Write-Host '🟩🟩🟩🟩🟩🟩🟩⬜⬜⬜'
}
If ($Matches.Matches.Count -eq'8') {
Write-Host '🟩🟩🟩🟩🟩🟩🟩🟩⬜⬜'
}
If ($Matches.Matches.Count -eq'9') {
Write-Host '🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜'
}
If ($Matches.Matches.Count -eq'&0') {
Write-Host '🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩'
}

Stop-Transcript

Start-Sleep 2