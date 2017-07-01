## requires -version 2
## NOTE: JAVA_HOME must be set in gstclreport.bat script

<#
.SYNOPSIS
  DellEMC NetWorker Daily Status Report
.DESCRIPTION
  Queries NetWorker server, generates a html formated tabular status report and sends report via email
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  None
.OUTPUTS
  html report located in "reportstore" location set in config file
.NOTES
  Version:        0.2.1
  Author:         Richard Bocchinfuso
  Email:          rbocchinfuso@gmail.com
  Creation Date:  12/20/2016
  Purpose/Change: Created config file for variables and cleaned up script
  
.EXAMPLE
  ./nw_daily_rpt.ps1
  Note:  Use this sytax when running from Powershell prompt
.EXAMPLE
  start powershell "& "./nw_daily_rpt.ps1"
  Note:  Use this syntax when running from Windows command prompt or as a scheduled task
#>

#region ---------------------------------------------------------[Initialization]---------------------------------------------------------

## get vars from config file
$configfile = "config.ini"
Get-Content $configfile | Where-Object {$_.trim() -ne "" } | Where-Object {$_ -notmatch "^#" -and $_ -notmatch "^\[" } | Foreach-Object {
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
    # Write-Host $var[0] "=" $var[1] -ForegroundColor Green
}

#endregion

#region ----------------------------------------------------------[Declarations]----------------------------------------------------------

$date = Get-Date -Format D
$now = Get-Date -uformat "%Y-%m-%d_%H-%M-%S"
### embeded mail settings when using local smtp server
# $emailFrom = "${nwsvr}@${domain}"
# $smtpUser = "${nwsvr}@${domain}"
### csv output file
$csvfile = $reportstore + $rawdata + ".csv"
### report output
$htmlout = "${reportstore}${nwsvr}_${rpttype}_${now}.html"

#endregion

#region -----------------------------------------------------------[Execution]------------------------------------------------------------

try {

## generate networker csv report
# Write-Host "`"$gstclrpt`" -u $nmcuser -P $nmcpassword -r `"$rpt`" -x $rptformat -o landscape -f `"$reportstore$rawdata`" -C `"Group Start Time`" `"1 day ago`" -C `"Server Name`" $nwsvr"
Invoke-Command -ScriptBlock { & $gstclrpt -u $nmcuser -P $nmcpassword -r `"$rpt`" -x $rptformat -o landscape -f `"$reportstore$rawdata`" -C `"Group Start Time`" `"1 day ago`" -C `"Server Name`" $nwsvr }


### convert csv to html
# html report format
$title = "$nwsvr Daily Backup Report"
$style = @"
<style>
TABLE{border-width: 3px;border-style: solid;border-color: black;border-collapse: collapse;}
TH{border-width: 2px;text-align: center;padding: 10px;border-style: solid;border-color: black;font-family: Arial;color: #FFFFFF;background-color:#08088A}
TD{border-width: 2px;text-align: center;padding: 10px;border-style: solid;border-color: black;font-family: Arial;color: #0A0A2A;background-color: #FAFAFA}
tr.special {background: #000080;} <tr class="special"></tr>
</style>
"@
$rpthead = @"
<font face="Arial"><b>
Data Zone:  $site<br>
datazone:  $datazone<br>
NetWorker Server:  $nwsvr<br>
Report Date:  $date<br>
</b></font>
"@

# Write-Host "Get-Content $csvfile | select -skip 10 | ConvertFrom-Csv | ConvertTo-Html -head $style | Out-File $htmlout"
Get-Content $csvfile | select -skip 10 | ConvertFrom-Csv | ConvertTo-Html -title $title -head $style -body $rpthead | Out-File $htmlout

## email variables
$subject = " $site - $datazone - $nwsvr Daily Backup Report - " + $date
$body = (Get-Content $htmlout | out-string)


## email snippet for use with internal SMTP server that does NOT require AUTH
# Send-MailMessage -from $EmailFrom -to $EmailTo -subject $subject -body $body -bodyashtml -attachment $csvfile -smtpserver $smtpServer

## email snippet for sending message via AWS SES or other SMTP service requiring AUTH
$smtpMessage = New-Object System.Net.Mail.MailMessage($emailFrom,$emailTo,$subject,$body)
$smtpMessage.IsBodyHTML = $true
$smtpMessage.Attachments.Add($csvfile)
$smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort) 
$smtpClient.EnableSsl = $true 
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword); 
$smtpClient.Send($smtpMessage)

## cleanup
$smtpMessage.Dispose()
# Remove-Item $csvfile
Remove-Item $htmlout

}

catch [system.exception] {
    # "caught a system exception"
    Write-Output $_.Exception|format-list -force
}

finally {
    Write-Host "Report Script Complete" -ForegroundColor "Green"
}

## trigger failure check and OpsGenie alert module
& ".\opsgenie_alert.ps1"

#endregion