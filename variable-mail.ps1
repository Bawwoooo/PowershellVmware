## Variables for email
#
# Your email.
$From = "reportvmware@gmail.com"
#
# Destinator email
$ToManager = 'aurelien.bert23@gmail.com'
$ToTechnician = 'aurelien.bert23@gmail.com'
#
#SMTP Server of your mail provider.
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
#
#Username and password of your account.
$Username = "reportvmware"
$PwdFile = "passwordmail.txt"
#
#Subject of your mail.
$subjectCM = "Report Script : User create virtual machines on vCenter"
$subjectTec = "Report Script: Errors"
$subjectCreator = "Report Script : Creation of virtual machines"
#
#Body of your mail.
$bodyCM = "Hello, This is a report of virtual machines which have been created by $ToCreator"
$bodyTec = "Hello, This is a report of virtual machines errors, in attached files"
$bodyCreator = "Hello, This is a report of virtual machines which have been created."
#
$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: blue; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: blue; background-color: #b0f2b6;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: blue;}
</style>
"@
#
## End Variables