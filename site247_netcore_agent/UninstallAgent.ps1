$w3svcRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC"
$wasRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WAS"
$environmentKey = "Environment"
$global:isDotNetAgentExists = 0;
	
Function RemoveEnvironmentSetting([string]$registryPath, [string]$name)
{
	$exists = 0;
	
	try {
		Get-ItemProperty -Path $registryPath | Select-Object -ExpandProperty $name -ErrorAction Stop | Out-Null	
		$exists = 1;
	}
	catch {
		$exists = 0;
	}
	
	$isDotNetAgentRunning = 0;
	$serviceName = 'apminsightdotnetagent'
	
	if (Get-Service $serviceName -ErrorAction SilentlyContinue)	
	{
		$global:isDotNetAgentExists = 1;
		$objService = Get-Service $serviceName;
		if ($objService.Status -eq 'Running')
		{
			$isDotNetAgentRunning = 1;
		}
	}

	if ($exists -eq 1) {
		try {
			$environmentString = (Get-ItemProperty -Path $registryPath -Name $name).Environment;
			$newEnvironmentValue = @();
			ForEach ($line in $($environmentString -split "`r`n")) {
				if($line.Contains("CORECLR_ENABLE_PROFILING=")) {
					continue; }
				elseif ($line.Contains("CORECLR_PROFILER=")) {
					continue; }
				elseif ($line.Contains("CORECLR_SITE24X7_HOME=")) {
					continue; }
				elseif ($line.Contains("CORECLR_PROFILER_PATH_64=")) {
					continue; }
				elseif ($line.Contains("CORECLR_PROFILER_PATH_32=")) {
					continue; }
							
				elseif ($line.Contains("COR_ENABLE_PROFILING=")) 
				{
					if ($global:isDotNetAgentExists -eq 1)
					{
						if ($isDotNetAgentRunning -eq 1)
						{
						
							$newEnvironmentValue += "COR_ENABLE_PROFILING=1"
						}
						else
						{
							$newEnvironmentValue += "COR_ENABLE_PROFILING=0"
						}
						continue; 
					}
					else
					{
						continue; 
					}
				}
				elseif ($line.Contains("COR_PROFILER=")) 
				{
					if ($global:isDotNetAgentExists -eq 1)
					{
						$newEnvironmentValue += "COR_PROFILER={989D151B-3F31-482E-926F-2E95D274BD36}"
						continue; 
					}
					else
					{
						continue; 
					}
				}
					
				elseif ($line.Contains("COR_PROFILER_PATH_64=")) {
					continue; }
				elseif ($line.Contains("COR_PROFILER_PATH_32=")) {
					continue; }
				elseif ($line.Contains("DOTNET_ADDITIONAL_DEPS=")) {
					continue; }
				elseif ($line.Contains("DOTNET_SHARED_STORE=")) {
					continue; }
				elseif ($line.Contains("S247_LICENSE_KEY=")) {
					continue; }
				else {
					$newEnvironmentValue += $line; }
			}
			
			if($newEnvironmentValue.length -eq 0)
			{
				RemoveRegistryItem $registryPath $name
			}
			else
			{
				CreateNewRegistryItem $registryPath $name $newEnvironmentValue
			}
		}
		catch {
			WRITE-WARNING "Failed modifying environment variable. Please contact support."
		}
	}
}

Function CreateNewRegistryItem([string]$registryPath, [string]$name, [string[]]$newRegistryValue) 
{
	New-ItemProperty -Path $registryPath `
		-Name $name `
		-Value $newRegistryValue `
		-PropertyType MultiString `
		-Force | Out-Null
}

Function RemoveRegistryItem([string]$registryPath, [string]$name) 
{
	Remove-ItemProperty -Path $registryPath -Name $name
}

Function IsAdmin() 
{
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

Function CheckAdminRights() {
    If (-Not(IsAdmin) -And ($installType -eq "global")) {
        Write-Host "You must have administrator rights to uninstall the agent. Please run this script from an elevated shell."
        exit
    }
}

Write-Host "
Uninstalling .NET Core Agent..."

CheckAdminRights

if ((Test-Path -Path $w3svcRegistryPath) -and (Test-Path -Path $wasRegistryPath)) 
{
	RemoveEnvironmentSetting $w3svcRegistryPath $environmentKey
	RemoveEnvironmentSetting $wasRegistryPath $environmentKey
}

[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING", $null)
[Environment]::SetEnvironmentVariable("COR_PROFILER", $null)

if ($global:isDotNetAgentExists -eq 0)
{
	[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING",$null,"Machine")
	[Environment]::SetEnvironmentVariable("COR_PROFILER",$null,"Machine")
}
[Environment]::SetEnvironmentVariable("CORECLR_ENABLE_PROFILING", $null)
[Environment]::SetEnvironmentVariable("CORECLR_ENABLE_PROFILING", $null, "Machine")
[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_64",$null,"Machine")
[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_32",$null,"Machine")
[Environment]::SetEnvironmentVariable("CORECLR_PROFILER",$null,"Machine")
[Environment]::SetEnvironmentVariable("CORECLR_SITE24X7_HOME",$null,"Machine")
[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_64",$null,"Machine")
[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_32",$null,"Machine")
[Environment]::SetEnvironmentVariable("DOTNET_ADDITIONAL_DEPS",$null,"Machine")
[Environment]::SetEnvironmentVariable("DOTNET_SHARED_STORE",$null,"Machine")
[Environment]::SetEnvironmentVariable("S247_LICENSE_KEY",$null,"Machine")

Write-Host "
The APM Insight .NET Core agent is removed successfully. Restart .NET Core applications to take effect. Reset IIS if the applications are hosted in IIS.
"
# SIG # Begin signature block
# MIIl6QYJKoZIhvcNAQcCoIIl2jCCJdYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDjGEaukLC3Y/MO
# jvXn7OjLA1QbpG2k+3EzdAZ/2kMJcaCCC30wggWAMIIEaKADAgECAhEA0Z2xpUL/
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
# qIBv5VPU4OOiwtJbGvoyJi1qV3AcPKRYLqPzW0sH3DJZ84enGm1YMYIZwjCCGb4C
# AQEwgZEwfDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3Rl
# cjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSQw
# IgYDVQQDExtTZWN0aWdvIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEQDRnbGlQv/T2ZuD
# II/p6A/jMA0GCWCGSAFlAwQCAQUAoIHAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqGSIb3DQEJBDEi
# BCBw/e1HwehdS36kvxms8ede03BH2/cs46DPPh90CGRPYDBUBgorBgEEAYI3AgEM
# MUYwRKBCgEAAWgBPAEgATwAgAEMAbwByAHAAbwByAGEAdABpAG8AbgAgAFAAcgBp
# AHYAYQB0AGUAIABMAGkAbQBpAHQAZQBkMA0GCSqGSIb3DQEBAQUABIIBACra6vOr
# F5sogOJbUZEO0fR6pZ02nvuo1Jb9UhjcUtnH7ToHmcad4gPHzfCZStPaiIsLLALF
# PIEyh88U58pIY82V8QNMh5tiUg4RY654nKTh8qxtuvtzoL8oT3KbAIGiDwGGcgAT
# ttRqDWjTiL40cV1bw5Yx3nLxqUPUpfubHjbu2FW17P+NDjUoJUPlUTBPhpy7jTFZ
# hplKL+nmaweWqnV8NDS41woqXxGAY2kpj8uhqG+RC2I460u0aHuwuJD4TfPYXMJA
# s908klU6PH5VVrp0mqUZ105IZPLCYUGQQzppaX+FAiZyiFv2NIdYZl0WpUW7QrtC
# zlRisVGdjRCkWEihghc+MIIXOgYKKwYBBAGCNwMDATGCFyowghcmBgkqhkiG9w0B
# BwKgghcXMIIXEwIBAzEPMA0GCWCGSAFlAwQCAQUAMHgGCyqGSIb3DQEJEAEEoGkE
# ZzBlAgEBBglghkgBhv1sBwEwMTANBglghkgBZQMEAgEFAAQgvEz/84FkvknbDBGI
# WackBv0za8wKLjDhKof9cWwSz0wCEQCx4QXOeTWqESs/o0JoxcF+GA8yMDIzMDcw
# NDA2MzkxMVqgghMHMIIGwDCCBKigAwIBAgIQDE1pckuU+jwqSj0pB4A9WjANBgkq
# hkiG9w0BAQsFADBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIElu
# Yy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYg
# VGltZVN0YW1waW5nIENBMB4XDTIyMDkyMTAwMDAwMFoXDTMzMTEyMTIzNTk1OVow
# RjELMAkGA1UEBhMCVVMxETAPBgNVBAoTCERpZ2lDZXJ0MSQwIgYDVQQDExtEaWdp
# Q2VydCBUaW1lc3RhbXAgMjAyMiAtIDIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQDP7KUmOsap8mu7jcENmtuh6BSFdDMaJqzQHFUeHjZtvJJVDGH0nQl3
# PRWWCC9rZKT9BoMW15GSOBwxApb7crGXOlWvM+xhiummKNuQY1y9iVPgOi2Mh0Ku
# JqTku3h4uXoW4VbGwLpkU7sqFudQSLuIaQyIxvG+4C99O7HKU41Agx7ny3JJKB5M
# gB6FVueF7fJhvKo6B332q27lZt3iXPUv7Y3UTZWEaOOAy2p50dIQkUYp6z4m8rSM
# zUy5Zsi7qlA4DeWMlF0ZWr/1e0BubxaompyVR4aFeT4MXmaMGgokvpyq0py2909u
# eMQoP6McD1AGN7oI2TWmtR7aeFgdOej4TJEQln5N4d3CraV++C0bH+wrRhijGfY5
# 9/XBT3EuiQMRoku7mL/6T+R7Nu8GRORV/zbq5Xwx5/PCUsTmFntafqUlc9vAapkh
# LWPlWfVNL5AfJ7fSqxTlOGaHUQhr+1NDOdBk+lbP4PQK5hRtZHi7mP2Uw3Mh8y/C
# LiDXgazT8QfU4b3ZXUtuMZQpi+ZBpGWUwFjl5S4pkKa3YWT62SBsGFFguqaBDwkl
# U/G/O+mrBw5qBzliGcnWhX8T2Y15z2LF7OF7ucxnEweawXjtxojIsG4yeccLWYON
# xu71LHx7jstkifGxxLjnU15fVdJ9GSlZA076XepFcxyEftfO4tQ6dwIDAQABo4IB
# izCCAYcwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAww
# CgYIKwYBBQUHAwgwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8G
# A1UdIwQYMBaAFLoW2W1NhS9zKXaaL3WMaiCPnshvMB0GA1UdDgQWBBRiit7QYfyP
# MRTtlwvNPSqUFN9SnDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1w
# aW5nQ0EuY3JsMIGQBggrBgEFBQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDov
# L29jc3AuZGlnaWNlcnQuY29tMFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0
# YW1waW5nQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQBVqioa80bzeFc3MPx140/W
# hSPx/PmVOZsl5vdyipjDd9Rk/BX7NsJJUSx4iGNVCUY5APxp1MqbKfujP8DJAJsT
# HbCYidx48s18hc1Tna9i4mFmoxQqRYdKmEIrUPwbtZ4IMAn65C3XCYl5+QnmiM59
# G7hqopvBU2AJ6KO4ndetHxy47JhB8PYOgPvk/9+dEKfrALpfSo8aOlK06r8JSRU1
# NlmaD1TSsht/fl4JrXZUinRtytIFZyt26/+YsiaVOBmIRBTlClmia+ciPkQh0j8c
# wJvtfEiy2JIMkU88ZpSvXQJT657inuTTH4YBZJwAwuladHUNPeF5iL8cAZfJGSOA
# 1zZaX5YWsWMMxkZAO85dNdRZPkOaGK7DycvD+5sTX2q1x+DzBcNZ3ydiK95ByVO5
# /zQQZ/YmMph7/lxClIGUgp2sCovGSxVK05iQRWAzgOAj3vgDpPZFR+XOuANCR+hB
# NnF3rf2i6Jd0Ti7aHh2MWsgemtXC8MYiqE+bvdgcmlHEL5r2X6cnl7qWLoVXwGDn
# eFZ/au/ClZpLEQLIgpzJGgV8unG1TnqZbPTontRamMifv427GFxD9dAq6OJi7ngE
# 273R+1sKqHB+8JeEeOMIA11HLGOoJTiXAdI/Otrl5fbmm9x+LMz/F0xNAKLY1gEO
# uIvu5uByVYksJxlh9ncBjDCCBq4wggSWoAMCAQICEAc2N7ckVHzYR6z9KGYqXlsw
# DQYJKoZIhvcNAQELBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNl
# cnQgVHJ1c3RlZCBSb290IEc0MB4XDTIyMDMyMzAwMDAwMFoXDTM3MDMyMjIzNTk1
# OVowYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYD
# VQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFt
# cGluZyBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMaGNQZJs8E9
# cklRVcclA8TykTepl1Gh1tKD0Z5Mom2gsMyD+Vr2EaFEFUJfpIjzaPp985yJC3+d
# H54PMx9QEwsmc5Zt+FeoAn39Q7SE2hHxc7Gz7iuAhIoiGN/r2j3EF3+rGSs+Qtxn
# jupRPfDWVtTnKC3r07G1decfBmWNlCnT2exp39mQh0YAe9tEQYncfGpXevA3eZ9d
# rMvohGS0UvJ2R/dhgxndX7RUCyFobjchu0CsX7LeSn3O9TkSZ+8OpWNs5KbFHc02
# DVzV5huowWR0QKfAcsW6Th+xtVhNef7Xj3OTrCw54qVI1vCwMROpVymWJy71h6aP
# TnYVVSZwmCZ/oBpHIEPjQ2OAe3VuJyWQmDo4EbP29p7mO1vsgd4iFNmCKseSv6De
# 4z6ic/rnH1pslPJSlRErWHRAKKtzQ87fSqEcazjFKfPKqpZzQmiftkaznTqj1QPg
# v/CiPMpC3BhIfxQ0z9JMq++bPf4OuGQq+nUoJEHtQr8FnGZJUlD0UfM2SU2LINIs
# VzV5K6jzRWC8I41Y99xh3pP+OcD5sjClTNfpmEpYPtMDiP6zj9NeS3YSUZPJjAw7
# W4oiqMEmCPkUEBIDfV8ju2TjY+Cm4T72wnSyPx4JduyrXUZ14mCjWAkBKAAOhFTu
# zuldyF4wEr1GnrXTdrnSDmuZDNIztM2xAgMBAAGjggFdMIIBWTASBgNVHRMBAf8E
# CDAGAQH/AgEAMB0GA1UdDgQWBBS6FtltTYUvcyl2mi91jGogj57IbzAfBgNVHSME
# GDAWgBTs1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwgwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8
# MDowOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0
# ZWRSb290RzQuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAN
# BgkqhkiG9w0BAQsFAAOCAgEAfVmOwJO2b5ipRCIBfmbW2CFC4bAYLhBNE88wU86/
# GPvHUF3iSyn7cIoNqilp/GnBzx0H6T5gyNgL5Vxb122H+oQgJTQxZ822EpZvxFBM
# Yh0MCIKoFr2pVs8Vc40BIiXOlWk/R3f7cnQU1/+rT4osequFzUNf7WC2qk+RZp4s
# nuCKrOX9jLxkJodskr2dfNBwCnzvqLx1T7pa96kQsl3p/yhUifDVinF2ZdrM8HKj
# I/rAJ4JErpknG6skHibBt94q6/aesXmZgaNWhqsKRcnfxI2g55j7+6adcq/Ex8HB
# anHZxhOACcS2n82HhyS7T6NJuXdmkfFynOlLAlKnN36TU6w7HQhJD5TNOXrd/yVj
# mScsPT9rp/Fmw0HNT7ZAmyEhQNC3EyTN3B14OuSereU0cZLXJmvkOHOrpgFPvT87
# eK1MrfvElXvtCl8zOYdBeHo46Zzh3SP9HSjTx/no8Zhf+yvYfvJGnXUsHicsJttv
# FXseGYs2uJPU5vIXmVnKcPA3v5gA3yAWTyf7YGcWoWa63VXAOimGsJigK+2VQbc6
# 1RWYMbRiCQ8KvYHZE/6/pNHzV9m8BPqC3jLfBInwAM1dwvnQI38AC+R2AibZ8GV2
# QqYphwlHK+Z/GqSFD/yYlvZVVCsfgPrA8g4r5db7qS9EFUrnEw4d2zc4GqEr9u3W
# fPwwggWNMIIEdaADAgECAhAOmxiO+dAt5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUA
# MGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsT
# EHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQg
# Um9vdCBDQTAeFw0yMjA4MDEwMDAwMDBaFw0zMTExMDkyMzU5NTlaMGIxCzAJBgNV
# BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
# Y2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL/mkHNo3rvkXUo8MCIwaTPswqcl
# LskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4FutWxpdtHauyefLKEdLkX9YF
# PFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZanMylNEQRBAu34LzB4TmdDttceIt
# DBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0QF+xembud8hIqGZX
# V59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1
# ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1XXhm2Tox
# RJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3JFxGj2T3wWmIdph2PVldQnaHiZdp
# ekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF
# 30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhElRp2Yn72gLD76GSmM9GJB+G9
# t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0viastkF13nqsX40/ybzTQRESW+UQ
# UOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyhHsXAj6KxfgommfXk
# aS+YHS312amyHeUbAgMBAAGjggE6MIIBNjAPBgNVHRMBAf8EBTADAQH/MB0GA1Ud
# DgQWBBTs1+OC0nFdZEzfLmc/57qYrhwPTzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEt
# UYunpyGd823IDzAOBgNVHQ8BAf8EBAMCAYYweQYIKwYBBQUHAQEEbTBrMCQGCCsG
# AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0
# dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
# QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29t
# L0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAw
# DQYJKoZIhvcNAQEMBQADggEBAHCgv0NcVec4X6CjdBs9thbX979XB72arKGHLOyF
# XqkauyL4hxppVCLtpIh3bb0aFPQTSnovLbc47/T/gLn4offyct4kvFIDyE7QKt76
# LVbP+fT3rDB6mouyXtTP0UNEm0Mh65ZyoUi0mcudT6cGAxN3J0TU53/oWajwvy8L
# punyNDzs9wPHh6jSTEAZNUZqaVSwuKFWjuyk1T3osdz9HNj0d1pcVIxv76FQPfx2
# CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPFmCLBsln1VWvPJ6tsds5vIy30fnFqI2si
# /xK4VC0nftg62fC2h5b9W9FcrBjDTZ9ztwGpn1eqXijiuZQxggN2MIIDcgIBATB3
# MGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UE
# AxMyRGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBp
# bmcgQ0ECEAxNaXJLlPo8Kko9KQeAPVowDQYJYIZIAWUDBAIBBQCggdEwGgYJKoZI
# hvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0yMzA3MDQwNjM5
# MTFaMCsGCyqGSIb3DQEJEAIMMRwwGjAYMBYEFPOHIk2GM4KSNamUvL2Plun+HHxz
# MC8GCSqGSIb3DQEJBDEiBCDHMt8HRA1JPxXjbT5NvodehQDJWJdGEvI4ztGRWm7T
# zjA3BgsqhkiG9w0BCRACLzEoMCYwJDAiBCDH9OG+MiiJIKviJjq+GsT8T+Z4HC1k
# 0EyAdVegI7W2+jANBgkqhkiG9w0BAQEFAASCAgBdF514s06uujGn3fqAWS9NOPEn
# i0O0bbCSMlCBg7Rm4GJCWkOV8NV1ljZ5FY9U+BZ9e4R0Bb5wBZKVBuKzks6wEutu
# Z5zY0vikOY37tHTT3RWldNXEoUOYcfnZf7dbdm3mLCg0QabdiSlTGQaiCSiClpaZ
# Lu+uEaUd8PfjdONpehXj/S7gYz/E8N7n9gmLz6ol5GVtAbLmk2z+4x5mbpAQNla+
# K1N50JOvd7woUi3ClcP7Fg/cQjEi7BO/X2s09tHCdLCZeJQ67Z0liYFqMHZ0RdkD
# slVIfVrQhuReMl6GC4pNxTdidZ0nlrr7BptffkacNCHsIiN3Vx4JxTHcdoTrJM2B
# V+ayLqaQzLDH7MKyzYaZiZVKXXJjMKyVMr6/Ww1Xmta3Hlyzrk4gtWmntIquN+iq
# Ypf6C15ALwTFyOgZIqy+OlL0tSs0ysFlPp8+JJ1rw5Wmod//h1S2IioXNZ0zWobm
# TwPj/qvqWTOlch56JYxUJnUrzxbOsJubw+G5vosV18F5+QN42dHWncUtg/gjmYME
# ucfwARo7ZFlgVcF44sJnhVQqk3Ho3K/Li84QiOhP2P9SQLNZWMt98VZWKyIKfv52
# BHPzeRAAtJLU01+oaYISC/H9TmHUX2UWDKWm4WoeH5mp9Ap+XVzHEe0nTBUW4Ubz
# JcKHeVw1KUXHAeux0A==
# SIG # End signature block
