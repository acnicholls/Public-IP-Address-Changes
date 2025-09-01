###########################################################################################
# Script Name: Public IP Address Check
# Script Purpose: Sends and email alert if the public IP address of the device changes
# Created By: Woodward.Digital
# Edited By: acnicholls
# Website: https://woodward.digital
# Email: contact@woodward.digital
# Version: v1.1
###########################################################################################

# Variables
###########################################################################################

# Find current public IP Address
# Run the following command in a PowerShell Console
# (Invoke-WebRequest ipecho.net/plain).content

# Enter the current public IP address below
$CurrentPublicIP = Get-Content -Path ".\currentip.txt"

# Email alert settings

# Where to send the email alerts to
$EmailTo = "acnicholls@gmail.com"

# SMTP Server details
$SMTPServer = "smtp.gmail.com"
$SMTPPort = 587

# SMTP authentication details
$EmailAuthUser = "<needs a gmail account>"
$EmailAuthPassword = "<needs an app password>"

###########################################################################################

# Email Authentication
$SecuredEmailAuthPassword = ConvertTo-SecureString $EmailAuthPassword -AsPlainText -Force
$EmailAuth = New-Object System.Management.Automation.PSCredential ($EmailAuthUser, $SecuredEmailAuthPassword)


# Check public IP address
if ((Invoke-WebRequest ipecho.net/plain).content -eq $CurrentPublicIP) {
    # IP address hasn't changed
    # Uncomment line below if you want to recive an email to confrim it hasnt changed
    Send-MailMessage -Body "IP Address is has not changed" -From $EmailAuthUser -To $EmailTo -Subject "IP address has not changed" -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $EmailAuth
}
Else {
    # IP address has changed
    Send-MailMessage -Body "IP Address is has changed" -From $EmailAuthUser -To $EmailTo -Subject "IP Address Change - ALERT" -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $EmailAuth
    (Invoke-WebRequest ipecho.net/plain).content > ".\currentip.txt"
}