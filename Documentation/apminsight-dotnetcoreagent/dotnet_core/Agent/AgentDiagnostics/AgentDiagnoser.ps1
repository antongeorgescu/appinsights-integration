Write-Progress -Activity "Collecting diagnostics information for .NET Core agent" -Status "Please wait"  

try
{
$w3svc = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC 
$was = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\WAS 
$OFS = "`r`n"

$parentPath = Split-Path $PSScriptRoot -Parent
$versionPath = (Join-Path $parentPath "version.info")	

$AgentDiagnosticsPath = ".\AgentDiagnostics"

if (Test-Path $AgentDiagnosticsPath) { Remove-Item $AgentDiagnosticsPath -Recurse; }

$result = New-Item -ItemType directory -Path $AgentDiagnosticsPath
$path = (Resolve-Path -Path $AgentDiagnosticsPath).Path
$applicationEventLog = "$path\Application.evtx"
$systemInfofile = "$AgentDiagnosticsPath\system.info"
$diagnosticFile = ".\AgentDiagnostics.zip"
#-------------------------------------------------------------------------------------

systeminfo | Out-File -FilePath $systemInfofile -NoClobber

Add-Content $systemInfofile "$OFS--------------HKLM:\SYSTEM\ControlSet001\Services\W3SVC:Environment----------"
$w3svc.Environment | Out-File -FilePath $systemInfofile -NoClobber -Append

Add-Content $systemInfofile "$OFS--------------HKLM:\SYSTEM\ControlSet001\Services\WAS:Environment----------"
$was.Environment | Out-File -FilePath $systemInfofile -NoClobber -Append


Add-Content $systemInfofile "$OFS--------------Global:Environment----------"
echo "CORECLR_ENABLE_PROFILING=$env:CORECLR_ENABLE_PROFILING" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "CORECLR_PROFILER=$env:CORECLR_PROFILER" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "CORECLR_PROFILER_PATH_64=$env:CORECLR_PROFILER_PATH_64" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "CORECLR_PROFILER_PATH_32=$env:CORECLR_PROFILER_PATH_32" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "CORECLR_SITE24X7_HOME=$env:CORECLR_SITE24X7_HOME" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "DOTNET_ADDITIONAL_DEPS=$env:DOTNET_ADDITIONAL_DEPS" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "DOTNET_SHARED_STORE=$env:DOTNET_SHARED_STORE" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "S247_LICENSE_KEY=$env:S247_LICENSE_KEY" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "COR_ENABLE_PROFILING=$env:COR_ENABLE_PROFILING" | Out-File -FilePath $systemInfofile -NoClobber -Append
echo "COR_PROFILER=$env:COR_PROFILER" | Out-File -FilePath $systemInfofile -NoClobber -Append

Add-Content $systemInfofile "$OFS--------------.NET Core info----------"
dotnet --info | Out-File -FilePath $systemInfofile -NoClobber -Append

#Reading .NET Core process with environment variables--------------------------
Add-Content $systemInfofile "$OFS***************************.NET Core processes***********************************"
$currentPath = (Get-Location).Path

try 
{
	$Assembly = [System.Reflection.Assembly]::LoadFrom("$currentPath\ProcessUtil.dll");

	$processes = get-process | where {$_.ProcessName -eq "w3wp"}

	foreach ($process in $processes)
	{ 
		try {
				Add-Content $systemInfofile "$OFS--------------Process Id : $($process.Id) -------------------"
				Get-Process -Id $process.Id | Out-File -FilePath $systemInfofile -NoClobber -Append -Width 100
				[ProcessUtil.Util.ProcessExtensions]::GetEnvironmentVariables($process.Id) | Out-File -FilePath $systemInfofile -NoClobber -Append
				Add-Content $systemInfofile "$OFS---------------------------------------------------"
			}
		catch {
				Add-Content $systemInfofile $_
		}
	}

	$processes = get-process | where {$_.ProcessName -eq "dotnet"}
	foreach ($process in $processes) 
	{  
		try {
				Add-Content $systemInfofile "$OFS--------------Process Id : $($process.Id) -------------------"
				Get-Process -Id $process.Id | Out-File -FilePath $systemInfofile -NoClobber -Append -Width 100
				[ProcessUtil.Util.ProcessExtensions]::GetEnvironmentVariables($process.Id) | Out-File -FilePath $systemInfofile -NoClobber -Append
				Add-Content $systemInfofile "$OFS---------------------------------------------------"
			}
		catch {
				Add-Content $systemInfofile $_
		}
	}
}
catch {
	Add-Content $systemInfofile $_
}
#-------------------------------------------------------------------------
Add-Content $systemInfofile "$OFS*********************************************************************************************"
#Exporting eventlog
$eventLog = (Get-WmiObject -Class Win32_NTEventlogFile | Where-Object LogfileName -EQ 'Application').BackupEventlog($applicationEventLog)

#Copying the agent log files
Copy-Item (Join-Path $parentPath "DotNetAgent") -destination $AgentDiagnosticsPath -recurse -for
Copy-Item $versionPath -destination $AgentDiagnosticsPath -recurse -for


$compress = @{
LiteralPath= $AgentDiagnosticsPath
CompressionLevel = "Fastest"
DestinationPath = $diagnosticFile
}
Compress-Archive @compress -Force

Remove-Item $AgentDiagnosticsPath -Recurse

Write-Host "Diagnostics zip file is generated." 
Write-Host "Send the file AgentDiagnostics.zip to support@site24x7.com for analysis." 
}
catch
{
    "An error occurred:"
    Write-Error $_
    Add-Content $systemInfofile "$OFS-------------Error in Agent Diagnostics script.---------------"
    Add-Content $systemInfofile $_
    Write-Host "If you find the AgentDiagnostics folder with the some log files, kindly zip the folder and send it to support@site24x7.com for analysis."
}


# SIG # Begin signature block
# MIIl6AYJKoZIhvcNAQcCoIIl2TCCJdUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBRKvr82Rz51xHJ
# LU+vZYO+TKeLiY9/ULh759RFMgx5BaCCC30wggWAMIIEaKADAgECAhEA0Z2xpUL/
# 09mbgyCP6egP4zANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJHQjEbMBkGA1UE
# CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQK
# Ew9TZWN0aWdvIExpbWl0ZWQxJDAiBgNVBAMTG1NlY3RpZ28gUlNBIENvZGUgU2ln
# bmluZyBDQTAeFw0yMDEyMTAwMDAwMDBaFw0yMzEyMTAyMzU5NTlaMIHFMQswCQYD
# VQQGEwJJTjEPMA0GA1UEEQwGNjAzMjAyMRMwEQYDVQQIDApUYW1pbCBOYWR1MRUw
# EwYDVQQHDAxDaGVuZ2FscGF0dHUxIzAhBgNVBAkMGkVzdGFuY2lhIElUIFBhcmss
# IEdTVCBSb2FkMSkwJwYDVQQKDCBaT0hPIENvcnBvcmF0aW9uIFByaXZhdGUgTGlt
# aXRlZDEpMCcGA1UEAwwgWk9ITyBDb3Jwb3JhdGlvbiBQcml2YXRlIExpbWl0ZWQw
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDi3HeMGAIKgDfQ4UK+K//K
# i/IWnxPm4gsK9i3o6bX1nzqZOaPPwA8h7nDKjdwSaP0Xk47NlABcTfakTjIUinIY
# mHlYYgRafFc6+tcyP7GPJW82N3cRR0nfXygLK1A+mf0lWfwihngvwpTa4xOy+0ce
# ClOuT+38PXD4GR3MRm4tmZAmlQ1AXr4giFCtNDfcQMfIKZ5C+Tkoy13awIJsyJAJ
# uf8203YjySdS204K3GVkiRy+KhvGtQRU+eqRopWgEnSDvdz47F1QRGcDuuUVgflF
# f1SdUwXRL81ESohTlo3c4m0vWb7u/ODhggEsTOK4B61e+x7utPCquFJm8mf1oujh
# AgMBAAGjggGxMIIBrTAfBgNVHSMEGDAWgBQO4TqoUzox1Yq+wbutZxoDha00DjAd
# BgNVHQ4EFgQU+IlX0lpCD0WzABsU/rMugtg1d6owDgYDVR0PAQH/BAQDAgeAMAwG
# A1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwEQYJYIZIAYb4QgEBBAQD
# AgQQMEoGA1UdIARDMEEwNQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0
# dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEATBDBgNVHR8EPDA6MDigNqA0
# hjJodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29SU0FDb2RlU2lnbmluZ0NB
# LmNybDBzBggrBgEFBQcBAQRnMGUwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jcnQuc2Vj
# dGlnby5jb20vU2VjdGlnb1JTQUNvZGVTaWduaW5nQ0EuY3J0MCMGCCsGAQUFBzAB
# hhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTAfBgNVHREEGDAWgRRwcmFiaHVwQHpv
# aG9jb3JwLmNvbTANBgkqhkiG9w0BAQsFAAOCAQEAYp6kI49tFad0lkVzbeY38GTs
# AGLvoj6p57Q6mqF4bz3Igr7DeXU/sUrh2W6hSewJm/00V5uY3UQ8YtHLNki56NeF
# Ja0zISd6FJVpasL0x2+BboKiNKlogTBQO1s6a43DTrJ4cPeRafh9ZHbAM6nTarCV
# MD5RiinFNrwinIYFO65FVswVtm56+8x5vM//9RkgD3/ey3JYWZOydGbdtsKKLfqu
# Lclet9SUHiXHxWsE9fNbFWYqU+ZCfmGRJ0IROG6t88V8wszZLUDjAzLxbsZHiUq9
# dFTaD1OijtFc9IbKOVK0s0S0UeUimP+ED7o/Y1N2+8S0DmKd97pAA/1EvTK7bTCC
# BfUwggPdoAMCAQICEB2iSDBvmyYY0ILgln0z02owDQYJKoZIhvcNAQEMBQAwgYgx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJz
# ZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQD
# EyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE4MTEw
# MjAwMDAwMFoXDTMwMTIzMTIzNTk1OVowfDELMAkGA1UEBhMCR0IxGzAZBgNVBAgT
# EkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMP
# U2VjdGlnbyBMaW1pdGVkMSQwIgYDVQQDExtTZWN0aWdvIFJTQSBDb2RlIFNpZ25p
# bmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCGIo0yhXoYn0nw
# li9jCB4t3HyfFM/jJrYlZilAhlRGdDFixRDtsocnppnLlTDAVvWkdcapDlBipVGR
# EGrgS2Ku/fD4GKyn/+4uMyD6DBmJqGx7rQDDYaHcaWVtH24nlteXUYam9CflfGqL
# lR5bYNV+1xaSnAAvaPeX7Wpyvjg7Y96Pv25MQV0SIAhZ6DnNj9LWzwa0VwW2TqE+
# V2sfmLzEYtYbC43HZhtKn52BxHJAteJf7wtF/6POF6YtVbC3sLxUap28jVZTxvC6
# eVBJLPcDuf4vZTXyIuosB69G2flGHNyMfHEo8/6nxhTdVZFuihEN3wYklX0Pp6F8
# OtqGNWHTAgMBAAGjggFkMIIBYDAfBgNVHSMEGDAWgBRTeb9aqitKz1SA4dibwJ3y
# sgNmyzAdBgNVHQ4EFgQUDuE6qFM6MdWKvsG7rWcaA4WtNA4wDgYDVR0PAQH/BAQD
# AgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0lBBYwFAYIKwYBBQUHAwMGCCsG
# AQUFBwMIMBEGA1UdIAQKMAgwBgYEVR0gADBQBgNVHR8ESTBHMEWgQ6BBhj9odHRw
# Oi8vY3JsLnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNBQ2VydGlmaWNhdGlvbkF1
# dGhvcml0eS5jcmwwdgYIKwYBBQUHAQEEajBoMD8GCCsGAQUFBzAChjNodHRwOi8v
# Y3J0LnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNBQWRkVHJ1c3RDQS5jcnQwJQYI
# KwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEM
# BQADggIBAE1jUO1HNEphpNveaiqMm/EAAB4dYns61zLC9rPgY7P7YQCImhttEAcE
# T7646ol4IusPRuzzRl5ARokS9At3WpwqQTr81vTr5/cVlTPDoYMot94v5JT3hTOD
# LUpASL+awk9KsY8k9LOBN9O3ZLCmI2pZaFJCX/8E6+F0ZXkI9amT3mtxQJmWunjx
# ucjiwwgWsatjWsgVgG10Xkp1fqW4w2y1z99KeYdcx0BNYzX2MNPPtQoOCwR/oEuu
# u6Ol0IQAkz5TXTSlADVpbL6fICUQDRn7UJBhvjmPeo5N9p8OHv4HURJmgyYZSJXO
# SsnBf/M6BZv5b9+If8AjntIeQ3pFMcGcTanwWbJZGehqjSkEAnd8S0vNcL46slVa
# eD68u28DECV3FTSK+TbMQ5Lkuk/xYpMoJVcp+1EZx6ElQGqEV8aynbG8HArafGd+
# fS7pKEwYfsR7MUFxmksp7As9V1DSyt39ngVR5UR43QHesXWYDVQk/fBO4+L4g71y
# uss9Ou7wXheSaG3IYfmm8SoKC6W59J7umDIFhZ7r+YMp08Ysfb06dy6LN0KgaoLt
# O0qqlBCk4Q34F8W2WnkzGJLjtXX4oemOCiUe5B7xn1qHI/+fpFGe+zmAEc3btcSn
# qIBv5VPU4OOiwtJbGvoyJi1qV3AcPKRYLqPzW0sH3DJZ84enGm1YMYIZwTCCGb0C
# AQEwgZEwfDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3Rl
# cjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSQw
# IgYDVQQDExtTZWN0aWdvIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEQDRnbGlQv/T2ZuD
# II/p6A/jMA0GCWCGSAFlAwQCAQUAoIHAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEi
# BCCmGDxsyD/SZ3eohuFY/b39aNFUlJiw8zXujBlq4uEiUjBUBgorBgEEAYI3AgEM
# MUYwRKBCgEAAWgBPAEgATwAgAEMAbwByAHAAbwByAGEAdABpAG8AbgAgAFAAcgBp
# AHYAYQB0AGUAIABMAGkAbQBpAHQAZQBkMA0GCSqGSIb3DQEBAQUABIIBAAt3KyQd
# /9j4ueW1Ygttr9AnXjuDNd8HyVdncSVozjPrLA4mMg3ktr6fBFnQ4PBO+q773AJ6
# JrGdiIo/d1kNCVtlrjYi1Wsvheg1pouNZVqCpyZeyF2+w+6woVYA08DkJZfrxNZU
# Sw09HFGwHQB6NMWMbHg2FZDHSN18rWVrdZjA6i0HZ6IgyNIc9UH6HwwaQOrLAM68
# KhEnWuKMto+aaaEr3f+xNxEAhLZYJoALjZhsSWpAgB1960o5NheLB8cpqjaD3x/W
# tLRxS27hlc4WLgt/VY+kVmuG58Rlf+Hj1gHeLmF7IMb27lrZWD1788S+/PCq5qMJ
# 6uTQqSx9L3q3CKehghc9MIIXOQYKKwYBBAGCNwMDATGCFykwghclBgkqhkiG9w0B
# BwKgghcWMIIXEgIBAzEPMA0GCWCGSAFlAwQCAQUAMHcGCyqGSIb3DQEJEAEEoGgE
# ZjBkAgEBBglghkgBhv1sBwEwMTANBglghkgBZQMEAgEFAAQgICUARlvKKNEO5ufp
# 6pJl/vIHBf0hlO6av+zfdvM5B/4CEDv5WjPLUp+qhoKMpsyClgsYDzIwMjMwNzA0
# MDYzOTEyWqCCEwcwggbAMIIEqKADAgECAhAMTWlyS5T6PCpKPSkHgD1aMA0GCSqG
# SIb3DQEBCwUAMGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5j
# LjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBU
# aW1lU3RhbXBpbmcgQ0EwHhcNMjIwOTIxMDAwMDAwWhcNMzMxMTIxMjM1OTU5WjBG
# MQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGlnaUNlcnQxJDAiBgNVBAMTG0RpZ2lD
# ZXJ0IFRpbWVzdGFtcCAyMDIyIC0gMjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
# AgoCggIBAM/spSY6xqnya7uNwQ2a26HoFIV0MxomrNAcVR4eNm28klUMYfSdCXc9
# FZYIL2tkpP0GgxbXkZI4HDEClvtysZc6Va8z7GGK6aYo25BjXL2JU+A6LYyHQq4m
# pOS7eHi5ehbhVsbAumRTuyoW51BIu4hpDIjG8b7gL307scpTjUCDHufLckkoHkyA
# HoVW54Xt8mG8qjoHffarbuVm3eJc9S/tjdRNlYRo44DLannR0hCRRinrPibytIzN
# TLlmyLuqUDgN5YyUXRlav/V7QG5vFqianJVHhoV5PgxeZowaCiS+nKrSnLb3T254
# xCg/oxwPUAY3ugjZNaa1Htp4WB056PhMkRCWfk3h3cKtpX74LRsf7CtGGKMZ9jn3
# 9cFPcS6JAxGiS7uYv/pP5Hs27wZE5FX/NurlfDHn88JSxOYWe1p+pSVz28BqmSEt
# Y+VZ9U0vkB8nt9KrFOU4ZodRCGv7U0M50GT6Vs/g9ArmFG1keLuY/ZTDcyHzL8Iu
# INeBrNPxB9ThvdldS24xlCmL5kGkZZTAWOXlLimQprdhZPrZIGwYUWC6poEPCSVT
# 8b876asHDmoHOWIZydaFfxPZjXnPYsXs4Xu5zGcTB5rBeO3GiMiwbjJ5xwtZg43G
# 7vUsfHuOy2SJ8bHEuOdTXl9V0n0ZKVkDTvpd6kVzHIR+187i1Dp3AgMBAAGjggGL
# MIIBhzAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAK
# BggrBgEFBQcDCDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwHwYD
# VR0jBBgwFoAUuhbZbU2FL3MpdpovdYxqII+eyG8wHQYDVR0OBBYEFGKK3tBh/I8x
# FO2XC809KpQU31KcMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3RhbXBp
# bmdDQS5jcmwwgZAGCCsGAQUFBwEBBIGDMIGAMCQGCCsGAQUFBzABhhhodHRwOi8v
# b2NzcC5kaWdpY2VydC5jb20wWAYIKwYBBQUHMAKGTGh0dHA6Ly9jYWNlcnRzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNFJTQTQwOTZTSEEyNTZUaW1lU3Rh
# bXBpbmdDQS5jcnQwDQYJKoZIhvcNAQELBQADggIBAFWqKhrzRvN4Vzcw/HXjT9aF
# I/H8+ZU5myXm93KKmMN31GT8Ffs2wklRLHiIY1UJRjkA/GnUypsp+6M/wMkAmxMd
# sJiJ3HjyzXyFzVOdr2LiYWajFCpFh0qYQitQ/Bu1nggwCfrkLdcJiXn5CeaIzn0b
# uGqim8FTYAnoo7id160fHLjsmEHw9g6A++T/350Qp+sAul9Kjxo6UrTqvwlJFTU2
# WZoPVNKyG39+XgmtdlSKdG3K0gVnK3br/5iyJpU4GYhEFOUKWaJr5yI+RCHSPxzA
# m+18SLLYkgyRTzxmlK9dAlPrnuKe5NMfhgFknADC6Vp0dQ094XmIvxwBl8kZI4DX
# NlpflhaxYwzGRkA7zl011Fk+Q5oYrsPJy8P7mxNfarXH4PMFw1nfJ2Ir3kHJU7n/
# NBBn9iYymHv+XEKUgZSCnawKi8ZLFUrTmJBFYDOA4CPe+AOk9kVH5c64A0JH6EE2
# cXet/aLol3ROLtoeHYxayB6a1cLwxiKoT5u92ByaUcQvmvZfpyeXupYuhVfAYOd4
# Vn9q78KVmksRAsiCnMkaBXy6cbVOepls9Oie1FqYyJ+/jbsYXEP10Cro4mLueATb
# vdH7WwqocH7wl4R44wgDXUcsY6glOJcB0j862uXl9uab3H4szP8XTE0AotjWAQ64
# i+7m4HJViSwnGWH2dwGMMIIGrjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzAN
# BgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQg
# SW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2Vy
# dCBUcnVzdGVkIFJvb3QgRzQwHhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5
# WjBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNV
# BAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1w
# aW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1y
# SVFVxyUDxPKRN6mXUaHW0oPRnkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50f
# ng8zH1ATCyZzlm34V6gCff1DtITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO
# 6lE98NZW1OcoLevTsbV15x8GZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12s
# y+iEZLRS8nZH92GDGd1ftFQLIWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYN
# XNXmG6jBZHRAp8ByxbpOH7G1WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9O
# dhVVJnCYJn+gGkcgQ+NDY4B7dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7j
# PqJz+ucfWmyU8lKVEStYdEAoq3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/
# 8KI8ykLcGEh/FDTP0kyr75s9/g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixX
# NXkrqPNFYLwjjVj33GHek/45wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtb
# iiKowSYI+RQQEgN9XyO7ZONj4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O
# 6V3IXjASvUaetdN2udIOa5kM0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQI
# MAYBAf8CAQAwHQYDVR0OBBYEFLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQY
# MBaAFOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUE
# DDAKBggrBgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDww
# OjA4oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3Rl
# ZFJvb3RHNC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0G
# CSqGSIb3DQEBCwUAA4ICAQB9WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y
# +8dQXeJLKftwig2qKWn8acHPHQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExi
# HQwIgqgWvalWzxVzjQEiJc6VaT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye
# 4Iqs5f2MvGQmh2ySvZ180HAKfO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj
# +sAngkSumScbqyQeJsG33irr9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFq
# cdnGE4AJxLafzYeHJLtPo0m5d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZ
# Jyw9P2un8WbDQc1PtkCbISFA0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4
# rUyt+8SVe+0KXzM5h0F4ejjpnOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228V
# ex4Ziza4k9Tm8heZWcpw8De/mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrV
# FZgxtGIJDwq9gdkT/r+k0fNX2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZC
# pimHCUcr5n8apIUP/JiW9lVUKx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8
# /DCCBY0wggR1oAMCAQICEA6bGI750C3n79tQ4ghAGFowDQYJKoZIhvcNAQEMBQAw
# ZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
# d3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBS
# b290IENBMB4XDTIyMDgwMTAwMDAwMFoXDTMxMTEwOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0MIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAv+aQc2jeu+RdSjwwIjBpM+zCpyUu
# ySE98orYWcLhKac9WKt2ms2uexuEDcQwH/MbpDgW61bGl20dq7J58soR0uRf1gU8
# Ug9SH8aeFaV+vp+pVxZZVXKvaJNwwrK6dZlqczKU0RBEEC7fgvMHhOZ0O21x4i0M
# G+4g1ckgHWMpLc7sXk7Ik/ghYZs06wXGXuxbGrzryc/NrDRAX7F6Zu53yEioZldX
# n1RYjgwrt0+nMNlW7sp7XeOtyU9e5TXnMcvak17cjo+A2raRmECQecN4x7axxLVq
# GDgDEI3Y1DekLgV9iPWCPhCRcKtVgkEy19sEcypukQF8IUzUvK4bA3VdeGbZOjFE
# mjNAvwjXWkmkwuapoGfdpCe8oU85tRFYF/ckXEaPZPfBaYh2mHY9WV1CdoeJl2l6
# SPDgohIbZpp0yt5LHucOY67m1O+SkjqePdwA5EUlibaaRBkrfsCUtNJhbesz2cXf
# SwQAzH0clcOP9yGyshG3u3/y1YxwLEFgqrFjGESVGnZifvaAsPvoZKYz0YkH4b23
# 5kOkGLimdwHhD5QMIR2yVCkliWzlDlJRR3S+Jqy2QXXeeqxfjT/JvNNBERJb5RBQ
# 6zHFynIWIgnffEx1P2PsIV/EIFFrb7GrhotPwtZFX50g/KEexcCPorF+CiaZ9eRp
# L5gdLfXZqbId5RsCAwEAAaOCATowggE2MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0O
# BBYEFOzX44LScV1kTN8uZz/nupiuHA9PMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1R
# i6enIZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjB5BggrBgEFBQcBAQRtMGswJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENB
# LmNydDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMBEGA1UdIAQKMAgwBgYEVR0gADAN
# BgkqhkiG9w0BAQwFAAOCAQEAcKC/Q1xV5zhfoKN0Gz22Ftf3v1cHvZqsoYcs7IVe
# qRq7IviHGmlUIu2kiHdtvRoU9BNKei8ttzjv9P+Aufih9/Jy3iS8UgPITtAq3vot
# Vs/59PesMHqai7Je1M/RQ0SbQyHrlnKhSLSZy51PpwYDE3cnRNTnf+hZqPC/Lwum
# 6fI0POz3A8eHqNJMQBk1RmppVLC4oVaO7KTVPeix3P0c2PR3WlxUjG/voVA9/HYJ
# aISfb8rbII01YBwCA8sgsKxYoA5AY8WYIsGyWfVVa88nq2x2zm8jLfR+cWojayL/
# ErhULSd+2DrZ8LaHlv1b0VysGMNNn3O3AamfV6peKOK5lDGCA3YwggNyAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKCB0TAaBgkqhkiG
# 9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIzMDcwNDA2Mzkx
# MlowKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU84ciTYYzgpI1qZS8vY+W6f4cfHMw
# LwYJKoZIhvcNAQkEMSIEIMi9wKTLWNHxoho0kAyKyrqvRZQQe59bdCq/H47GQHFu
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIMf04b4yKIkgq+ImOr4axPxP5ngcLWTQ
# TIB1V6Ajtbb6MA0GCSqGSIb3DQEBAQUABIICABMByY1mQwSHKd6e5KpIvjzCwmRE
# 4NAD4ClT9Qx3dsyfbpPDBPOauI1Bi7pAdUJSPG/cqLKR8fMvM6RuZ2GT2wez5DiP
# /0aEA2b2wamC3wUNH3Ky9oKg4G3iP95R1EF/7peuw9Vw1Rq+82aoTJHpqvhxbjFR
# xffEQ0ESLT6QtMKj+zKQ243JFFwAkPuof5BcYulWfwJlQSUrUk2UQ81ZaVB+Aspt
# 2eFL2eDhkI4oqz+3QIdCHpLw87ZnAqNP2Cb9Paq0ydRyzJrUrjMNqBVA08ufl1dZ
# X4W9PbVmpyPR9HTY0He1JU3HptRYJOXIENmvQ0sxsKfnD6Rs+cTB+H3uJd1F4kAh
# f+613agCTCvNQEXmHZi45k98PLc2W6kz+NPq/npS+gzT8P+SoVdr+Azgk7VUcZW3
# GiFHsdYZm60xQX3uZe8bFrNAu0a03c7KyA5TItF06Vm3SPAYxlRJcTcCRo7DDJw0
# etcRjKhCbIMb+5RXrEoYktegz4YkHyLtOhCkqKG61Jd4bYfhTriZQchbtuAOsps8
# d0Px5zkAvtysM2FELPpIdQplUqMUwMykFbmvdkocBBcHFxb56Z+uCYcv0lEWIIa6
# GJ9VdIcame9jEWbP4ZlQbnFKHeesUZag67neWxD0QpwIWoDztm+Cw2WDRfJVH7eB
# S4xSK3V1Vm5YTxab
# SIG # End signature block
