
## requires -version 3

<#
.SYNOPSIS
  OpsGenine POSH Module
.DESCRIPTION
  Parses csv for failures and triggers OpsGenie Alert via API
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  None
.OUTPUTS
  JSON payload
.NOTES
  Version:        0.1.0
  Author:         Richard Bocchinfuso
  Creation Date:  6/30/2017
  Purpose/Change: Initial build
  
.EXAMPLE
  ./opsgenie_alert.ps1
  Note:  Use this sytax when running from Powershell prompt
.EXAMPLE
  start powershell "& "./opsgenie_alert.ps1"
  Note:  Use this syntax when running from Windows command prompt or as a scheduled task
#>

#region ---------------------------------------------------------[Initialization]---------------------------------------------------------

## get vars from config file
$configfile = "config.ini"
Get-Content $configfile | Where-Object {$_.trim() -ne "" } | Where-Object {$_ -notmatch "^#" -and $_ -notmatch "^\[" } | Foreach-Object {
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
}

#endregion

#region ----------------------------------------------------------[Declarations]----------------------------------------------------------

$date = Get-Date -Format D
$now = Get-Date -uformat "%Y-%m-%d_%H-%M-%S"
### csv input file
$csvfile = $reportstore + $rawdata + ".csv"

#endregion

#region ------------------------------------------------------------[Functions]----------------------------------------------------------

Function Alert {
  
  Param ($message, $arr)
  foreach ($s in $arr) {
     $description = $s | Out-String
  }

  $uri = $OpsGenieAPIuri
  $headers = @{
      Accept = 'application/json'
  }
  $json = @{
      apiKey = $OpsGenieAPIkey
      source = $site
      message = $message
      teams = $teams
      description = $description
  } | ConvertTo-Json

  Invoke-WebRequest -Uri $uri -Body $json -Headers $headers -Method Post
}

#endregion

#region -----------------------------------------------------------[Execution]------------------------------------------------------------

try {

$nullMessage = "Report from server " + $nwsvr + " in datazone " + $datazone + " at site " + $site + " is NULL check server processes!"

if (Test-Path $csvfile) {

  $csvData = Get-Content -Path $csvfile | Select-Object -Skip 10 | ConvertFrom-Csv

  if ($csvData -eq $null) {
    Alert $nullMessage
  }
  else {
    for ($i=0; $i -lt $csvData.count; $i++)
    {
      $failCount = [int]$csvData[$i].Failed
      if ($failCount -gt 0) {
        $message = $site + ": " + $csvData[$i]."Failed" + " failed job(s) on client " + $csvData[$i]."Client Name" + " on server " + $csvData[$i]."Server Name"
        Alert $message $csvData[$i]
      }
    }
  }

  ## cleanup
  # Remove-Item $csvfile

  }
  else {
    Alert $nullMessage
  }


}

catch [system.exception] {
    # "caught a system exception"
    Write-Output $_.Exception|format-list -force
}

finally {
    Write-Host "Output parsed for failure and OpsGenie Alerts triggered" -ForegroundColor "Green"
}

#endregion