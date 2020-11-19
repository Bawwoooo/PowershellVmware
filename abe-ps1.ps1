#################################################################
######## Script creating Virtual Machines in VMWare ESXi ########
#################################################################


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
# Load variable email
. ./variable-mail.ps1
#
## End Variables

Write-Host "`nFile where Logs are redirected :`n" -Foreground DarkYellow

$Logs

Write-Host "`nList of Virtual Machines you want to create:" -Foreground DarkBlue

$ListVMs

Write-Host "`nConnecting to vCenter Server..." -Foreground Yellow

# Specify vCenter Server, vCenter Server username and vCenter Server user password (encrypt password for security)
$PasswordFile = "pwdvcenter.txt"
$Password = Get-Content $PasswordFile | ConvertTo-SecureString
$credential = New-Object System.Management.Automation.PSCredential ("administrator@vsphere.local", $Password)
$vCenter = "172.180.0.200"

Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

Connect-VIServer -server $vCenter -Protocol https -Credential $credential

Write-Host 'Enter your email to receive a report after the creation of a machine: ' -Foreground Green
$ToCreateur = Read-Host

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
            
            # Variable machine create for email
            $ReportVM = Get-VM -name $VMname | Select Name, VMHost, @{N = "Datastore"; E = { [string]::Join(',', (Get-Datastore -Id $_.DatastoreIdList)) } }, @{N = "DiskMB"; E = { [math]::round($_.UsedSpaceGB, 6) * 1024 } }, MemoryMB, NumCpu, @{N = "DiskStorageFormat"; E = { [string]::Join(',', (Get-VM | Get-HardDisk | Select-Object -ExpandProperty StorageFormat)) } }, Version, Description, PowerState | ConvertTo-Html -Head $Header

            # Send email after creation of virtual machine.
            Send-MailMessage -To $ToCreator -From $From -Subject $subjectCreator -SmtpServer $SMTPServer -BodyAsHtml $bodyCreator`r`n`n`n$ReportVM -Port $SMTPPort -UseSsl -Credential $Credential2 -DeliverynotificationOption neve
            
            # Grep errors creation virtual machine
            $error[0] >> errors$date.txt

            Write-Host "`nVirtual Machine was created.`n" -Foreground Green
            Write-Host "You will receive an email with a summary of the machine created" -Foreground Yellow
			
            Start-Sleep 2
				
        }
    
        else {
            Write-Host "`nVirtual Machine wasn't created.`n" -Foreground Red
        }
            
    }
}

else {
    Write-Host 'Your order is canceled.' -BackgroundColor Red -ForegroundColor Black
    exit
}

#Count number of "YES"
$FileContent = Get-Content "count.txt"
$Matches = Select-String -InputObject $FileContent -Pattern "YES" -AllMatches

#Nomber of machines / 10
Write-Host $Matches.Matches.Count virtual machine sur 10 ont été crées -Foreground Green

#Percent machines create
$Percent = $Matches.Matches.Count / 10 * 100
Write-Host $Percent "% machines are created" -Foreground Red

#Boucle for progress bar.
If ($Matches.Matches.Count -eq '1') {
    Write-Host '⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '2') {
    Write-Host '⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '3') {
    Write-Host '⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '4') {
    Write-Host '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '5') {
    Write-Host '⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '6') {
    Write-Host '⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '7') {
    Write-Host '⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜'
}
If ($Matches.Matches.Count -eq '8') {
    Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜'
}
If ($Matches.Matches.Count -eq '9') {
    Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜'
}
If ($Matches.Matches.Count -eq '&0') {
    Write-Host '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛'
}

Clear-Content "count.txt"

Write-Host 'Your technician will receive mail with errors' -Foreground Blue
Write-Host 'Your manager will receive a summary email' -Foreground DarkCyan

Stop-Transcript

Start-Sleep 2

$Report = Get-VM | Select Name, VMHost, @{N = "Datastore"; E = { [string]::Join(',', (Get-Datastore -Id $_.DatastoreIdList)) } }, @{N = "DiskMB"; E = { [math]::round($_.UsedSpaceGB, 6) * 1024 } }, MemoryMB, NumCpu, @{N = "DiskStorageFormat"; E = { [string]::Join(',', (Get-VM | Get-HardDisk | Select-Object -ExpandProperty StorageFormat)) } }, Version, Description, PowerState | ConvertTo-Html -Head $Header

$Pwdmail = Get-Content $PwdFile | ConvertTo-SecureString
$Credential2 = New-Object System.Management.Automation.PSCredential ($Username, $PwdMail)

#Send mail to manager with all informations.
Send-MailMessage -To $ToManager -From $From -Subject $subjectCM -SmtpServer $SMTPServer -BodyAsHtml $bodyCM`r`n`n`n$Report -Port $SMTPPort -UseSsl -Credential $Credential2 -DeliverynotificationOption never

#Send mail to technician (only error).
Send-MailMessage -To $ToTechnician -From $From -Subject $subjectTec -SmtpServer $SMTPServer -BodyAsHtml $bodyTec`r`n`n`n -Attachments errors$date.txt -Port $SMTPPort -UseSsl -Credential $Credential2 -DeliverynotificationOption never

Disconnect-VIServer -Server * -Force -Confirm:$false
