## requires -version 2

<#
.SYNOPSIS
  Vaidate that variables in config.ini are being properly parsed
.DESCRIPTION
  Reads config.ini and prints variable to screen for validation
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  None
.OUTPUTS
  Parsed variables from config.ini
.NOTES
  Version:        0.2.1
  Author:         Richard Bocchinfuso
  Email:          rbocchinfuso@gmail.com
  Creation Date:  12/20/2016
  Purpose/Change: Validate variables parsed from config.ini
.EXAMPLE
  ./check_config.ps1
  Note:  Use this sytax when running from Powershell prompt
#>

## get variables from config file
$configfile = "config.ini"
Get-Content $configfile | Where-Object {$_.trim() -ne "" } | Where-Object {$_ -notmatch "^#" -and $_ -notmatch "^\[" } | Foreach-Object {
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
    Write-Host $var[0] "=" $var[1] -ForegroundColor Green
}

