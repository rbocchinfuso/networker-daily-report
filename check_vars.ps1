## requires -version 2

<#
.SYNOPSIS
  Vaidate that variables in nw_vars.txt are being properly parsed
.DESCRIPTION
  Reads nw_vars.txt and prints variable to screen for validation
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  None
.OUTPUTS
  Parsed variables from nw_vars.txt
.NOTES
  Version:        0.2
  Author:         Richard Bocchinfuso
  Email:          rbocchinfuso@gmail.com
  Creation Date:  12/20/2016
  Purpose/Change: Validate variables parsed from nw_vars.txt
.EXAMPLE
  ./check_vars.ps1
  Note:  Use this sytax when running from Powershell prompt
#>

## get variables from config file
$configfile = "nw_vars.txt"
Get-Content $configfile | Where-Object {$_.trim() -ne "" } | Where-Object {$_ -notmatch "^#"} | Foreach-Object {
    $var = $_.Split('=')
    New-Variable -Name $var[0] -Value $var[1]
    Write-Host $var[0] "=" $var[1] -ForegroundColor Green
}

