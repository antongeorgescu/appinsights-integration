param (
    [string]$Destination,
    [ValidateSet('local', 'global')][string]$InstallType,
    [string]$LicenseKey,
	[string]$AppName,
	[switch]$IncludeDotNetFramework,
    [switch]$ResetIIS,
	[switch]$ForceUpdate,
    [switch]$Help,
	[switch]$IgnoreFolderPermission
)

$AgentVersion = "6.2.0"

$w3svcRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\W3SVC"
$wasRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\WAS"
$environmentKey = "Environment"
$profilerId = "{9D363A5F-ED5F-4AAC-B456-75AFFA6AA0C8}"

$SupportedVersions = @('netcoreapp2.0','netcoreapp2.1','netcoreapp2.2','netcoreapp2.2','netcoreapp3.0','netcoreapp3.1','net5.0','net6.0','net7.0')
$Platforms = @('x64','x86')

[bool] $IsUpdateFound = $false

Function InstallAgent()
{
	try
	{
	    $agentPath = (Join-Path $Destination "Site24x7DotNetCoreAgent")		
		$isVersionInfoExists = Test-Path (Join-Path $agentPath "version.info")

		if ($isVersionInfoExists) 
		{
			$installedAgentVersionString = Get-Content (Join-Path $agentPath "version.info")		
		
			$currentVersionNumber = $installedAgentVersionString -replace '\.',''
			$newVersionNumber = $AgentVersion -replace '\.',''
		
			if ($currentVersionNumber -lt $newVersionNumber) 
			{
				$IsUpdateFound = $true
				$userInput = "Y"
				if(-Not($ForceUpdate))
				{
					$agentMessage = "
APM Insight .NET core agent is already installed in the given location. Currently installed agent version is $installedAgentVersionString. Do you want to upgrade to $AgentVersion [Y/N]?"
					$userInput = Read-Host -Prompt $agentMessage
				}
				
				if ($userInput -eq "N" -OR $userInput -eq "n") 
				{
					Print("Setting the agent environment with the existing version $installedAgentVersionString.")
					SetEnvironmentVariables $agentPath 
				}
				elseif ($userInput -eq "Y" -OR $userInput -eq "y") 
				{
					Print("Upgrading the agent to the version $AgentVersion.")
					CopyFiles $agentPath
				}
				else
				{
					Print("Enter valid input.")
				}
				Print("The APM Insight .NET Core agent version $AgentVersion is set up successfully. Reset IIS, if you hosted the applications in IIS.")
			}
			elseif($currentVersionNumber -eq $newVersionNumber) 
			{
				Print("Same version of agent is found. Setting the agent environment for the version $installedAgentVersionString.")
				SetEnvironmentVariables $agentPath 
				Print("The APM Insight .NET Core agent version $AgentVersion is set up successfully. Reset IIS, if you hosted the applications in IIS.")
			}	
			else
			{
				Print("Higher version of agent is found. Upgrade could not be proceeded.")
			}
		}
		else
		{
			Print-Color -message "Setting up the APM Insight .NET Core agent version $AgentVersion." -Color Green	
			CopyFiles $agentPath
			Print-Color -message "The APM Insight .NET Core agent version $AgentVersion is set up successfully." -Color Green
			
			Print-Color -message "Kindly do the below steps to finish the configuration: `n  1. For IIS hosted applications, edit the below config file.  `n`t$agentPath\DotNetAgent\appfilter.config `n  2. For Non IIS hosted applications, edit the below config file. `n`t$agentPath\DotNetAgent\netcore_appfilter.config" -Color Yellow

			Print-Color -message "Reset IIS or Restart .NET Core applications/services to start monitoring." -Color Yellow

			Print-Color -message "For more information, please refer to: https://www.site24x7.com/help/apm/dotnet-agent/configure-appfilters-net-core.html`n" -Color Yellow
		}
	 }
	 catch [Exception]
	 {
		Write-Warning $_.Exception.Message;
	 }
}

Function Print([string]$message)
{
	Write-Host "
$message"
}

Function Print-Color([string]$message, [ConsoleColor[]]$Color)
{
	Write-Host "
$message" -ForeGround $Color
}

Function CopyFiles([string]$agentPath)
{
	$isFolderExists = Test-Path $agentPath
	if (-Not $isFolderExists) {
		New-Item $agentPath -type Directory | Out-Null
	}
	
	if(-Not($IsUpdateFound) -AND -Not($IgnoreFolderPermission))	{
		SetFolderPermissions $agentPath
	}
	$resolvedPath = (Resolve-Path -Path $agentPath).Path
	
	try
	{
		Get-ChildItem -Path $resolvedPath\NETFramework -Filter "*.dll" -Recurse | Rename-Item -NewName {$_.name -replace '.dll', '_old.dll' }
		Get-ChildItem -Path $resolvedPath\store -Filter "*.dll" -Recurse | Rename-Item -NewName {$_.name -replace '.dll', '_old.dll' }
		Get-ChildItem -Path $resolvedPath\x64 -Filter "*.dll" -Recurse | Rename-Item -NewName {$_.name -replace '.dll', '_old.dll' }
		Get-ChildItem -Path $resolvedPath\x86 -Filter "*.dll" -Recurse | Rename-Item -NewName {$_.name -replace '.dll', '_old.dll' }
	}
	catch [Exception]
	{
		Write-Warning $_.Exception.Message;
	}
		
	CopyAgentFiles $resolvedPath

	if(-Not($IsUpdateFound))
	{
		SetEnvironmentVariables $resolvedPath 
	 
		ModifyConfiguration $resolvedPath	
	}
		
	[string]$agentFile = $resolvedPath + "\store\";
	Get-ChildItem -Path $agentFile -Recurse | Unblock-File
		
	CreateVersionInfoFile $resolvedPath
}

Function CopyAgentFiles([string]$resolvedPath)
{	
	try
	{
		$additionalDepsPath = (Join-Path $resolvedPath "additionalDeps")	
		$isAdditionalDepsExists = Test-Path $additionalDepsPath
		if ($isAdditionalDepsExists)
		{
			Remove-Item $additionalDepsPath -Recurse
		}
	}
	catch [Exception]
	{
		Write-Warning $_.Exception.Message;
	}
	
	Copy-Item "$PSScriptRoot\Agent\Deps\additionalDeps" $resolvedPath -Recurse -Force
	Copy-Item "$PSScriptRoot\Agent\AgentDiagnostics" $resolvedPath -Recurse -Force
	if(-Not($IsUpdateFound))
	{
		Copy-Item "$PSScriptRoot\Agent\DotNetAgent" $resolvedPath -Recurse -Force
	}
	Copy-Item "$PSScriptRoot\Agent\packages\NETFramework" $resolvedPath -Recurse -Force
	Copy-Item "$PSScriptRoot\Agent\packages\x64" $resolvedPath -Recurse -Force
	Copy-Item "$PSScriptRoot\Agent\packages\x86" $resolvedPath -Recurse -Force
	
	foreach ($platform in $Platforms) {
		foreach ($folderName in $SupportedVersions) {	
			if (!(Test-Path $resolvedPath\store\$platform\$folderName\dotnetagent\1.0.0\lib\netcoreapp2.0)) {
				New-Item $resolvedPath\store\$platform\$folderName\dotnetagent\1.0.0\lib\netcoreapp2.0 -type Directory | Out-Null
			}
			Copy-Item "$PSScriptRoot\Agent\packages\AnyCPU\DotNetAgent.dll" $resolvedPath\store\$platform\$folderName\dotnetagent\1.0.0\lib\netcoreapp2.0 -Force
			
			if (!(Test-Path $resolvedPath\store\$platform\$folderName\dotnetagent.util\1.0.0\lib\netcoreapp2.0)) {
				New-Item $resolvedPath\store\$platform\$folderName\dotnetagent.util\1.0.0\lib\netcoreapp2.0 -type Directory | Out-Null
			}
			Copy-Item "$PSScriptRoot\Agent\packages\AnyCPU\DotNetAgent.Util.dll" $resolvedPath\store\$platform\$folderName\dotnetagent.util\1.0.0\lib\netcoreapp2.0 -Force
			
			if (!(Test-Path $resolvedPath\store\$platform\$folderName\site24x7.agent.api\1.0.0\lib\netcoreapp2.0)) {
				New-Item $resolvedPath\store\$platform\$folderName\site24x7.agent.api\1.0.0\lib\netcoreapp2.0 -type Directory | Out-Null
			}
			Copy-Item "$PSScriptRoot\Agent\packages\AnyCPU\Site24x7.Agent.Api.dll" $resolvedPath\store\$platform\$folderName\site24x7.agent.api\1.0.0\lib\netcoreapp2.0 -Force
			
			if (!(Test-Path $resolvedPath\store\$platform\$folderName\autoupdate\1.0.0\lib\netcoreapp2.0)) {
				New-Item $resolvedPath\store\$platform\$folderName\autoupdate\1.0.0\lib\netcoreapp2.0 -type Directory | Out-Null
			}
			Copy-Item "$PSScriptRoot\Agent\packages\AnyCPU\AutoUpdate.dll" $resolvedPath\store\$platform\$folderName\autoupdate\1.0.0\lib\netcoreapp2.0 -Force
		}
	}
}

Function ModifyConfiguration([string]$agentPath)
{
    [string]$filePath = $agentPath + "\DotNetAgent\apminsight.conf";
	if (Test-Path -Path $filePath) {
		(Get-Content $filePath ).Replace('license.key=','license.key='+$LicenseKey) | Out-File $filePath
	}
}

Function SetEnvironmentVariables([string]$installPath) {
	if ($InstallType -eq "global") {
		SetLocalEnvironment($installPath);
		SetGlobalEnvironment($installPath);
	}
	else {
		SetLocalEnvironment($installPath);
			
		if ((Test-Path -Path $w3svcRegistryPath) -and (Test-Path -Path $wasRegistryPath)) {
			#Setting Profiler Environment in registry for IIS starts.
			$environmentValue = GetEnvironmentSettingValue($installPath);
			SetRegistryEnvironment $w3svcRegistryPath $environmentKey $environmentValue $installPath
			SetRegistryEnvironment $wasRegistryPath $environmentKey $environmentValue $installPath
			#Setting Profiler Environment in registry for IIS ends.
		}
	}
}

Function SetLocalEnvironment([string]$installPath)
{
	if($IncludeDotNetFramework)
	{
		[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING", "1")
		[Environment]::SetEnvironmentVariable("COR_PROFILER", $profilerId)
		[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_64", (Join-Path $installPath "NETFramework\x64\ClrProfilerAgent.dll"))
		[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_32", (Join-Path $installPath "NETFramework\x86\ClrProfilerAgent.dll"))	
	}
	[Environment]::SetEnvironmentVariable("CORECLR_ENABLE_PROFILING", "1")
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER", $profilerId)
	[Environment]::SetEnvironmentVariable("CORECLR_SITE24X7_HOME", $installPath)
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_64", (Join-Path $installPath "x64\ClrProfilerAgent.dll"))
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_32", (Join-Path $installPath "x86\ClrProfilerAgent.dll"))
	[Environment]::SetEnvironmentVariable("DOTNET_ADDITIONAL_DEPS", (Join-Path $installPath "additionalDeps;"))
	[Environment]::SetEnvironmentVariable("DOTNET_SHARED_STORE", (Join-Path $installPath "store;"))
	[Environment]::SetEnvironmentVariable("S247_LICENSE_KEY", $LicenseKey)
}

Function SetGlobalEnvironment([string]$installPath)
{
	if($IncludeDotNetFramework)
	{
		[Environment]::SetEnvironmentVariable("COR_ENABLE_PROFILING", "1", "Machine")
		[Environment]::SetEnvironmentVariable("COR_PROFILER", $profilerId, "Machine")
		[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_64", (Join-Path $installPath "NETFramework\x64\ClrProfilerAgent.dll"), "Machine")
		[Environment]::SetEnvironmentVariable("COR_PROFILER_PATH_32", (Join-Path $installPath "NETFramework\x86\ClrProfilerAgent.dll"), "Machine")
	}
	[Environment]::SetEnvironmentVariable("CORECLR_ENABLE_PROFILING", "1", "Machine")
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER", $profilerId, "Machine")
	[Environment]::SetEnvironmentVariable("CORECLR_SITE24X7_HOME", $installPath, "Machine")		
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_64", (Join-Path $installPath "x64\ClrProfilerAgent.dll"), "Machine")
	[Environment]::SetEnvironmentVariable("CORECLR_PROFILER_PATH_32", (Join-Path $installPath "x86\ClrProfilerAgent.dll"), "Machine")
	[Environment]::SetEnvironmentVariable("DOTNET_ADDITIONAL_DEPS", (Join-Path $installPath "additionalDeps;"), "Machine")
	[Environment]::SetEnvironmentVariable("DOTNET_SHARED_STORE", (Join-Path $installPath "store;"), "Machine")
	[Environment]::SetEnvironmentVariable("S247_LICENSE_KEY", $LicenseKey, "Machine")
}

Function SetRegistryEnvironment([string]$registryPath, [string]$name, [string[]]$value, [string]$installPath)
{
	$exists = 0;
	
	try {
		Get-ItemProperty -Path $registryPath | Select-Object -ExpandProperty $name -ErrorAction Stop | Out-Null	
		$exists = 1;
	}
	catch {
		$exists = 0;
	}

	if ($exists -eq 0) {
		CreateNewRegistryItem $registryPath $name $value
	}
	else {
		try {
			$environmentString = (Get-ItemProperty -Path $registryPath -Name $name).Environment;
			$newEnvironmentValue = @();
			ForEach ($line in $($environmentString -split "`r`n")) {
				if($line.Contains("CORECLR_ENABLE_PROFILING=") -Or $line.Contains("CORECLR_PROFILER=") -Or $line.Contains("CORECLR_SITE24X7_HOME=") -Or $line.Contains("CORECLR_PROFILER_PATH_64=") -Or $line.Contains("CORECLR_PROFILER_PATH_32=") -Or $line.Contains("DOTNET_ADDITIONAL_DEPS=") -Or $line.Contains("DOTNET_SHARED_STORE=") -Or $line.Contains("S247_LICENSE_KEY=") -Or 
				($IncludeDotNetFramework -And ($line.Contains("COR_ENABLE_PROFILING=") -Or $line.Contains("COR_PROFILER=") -Or $line.Contains("COR_PROFILER_PATH_64=") -Or $line.Contains("COR_PROFILER_PATH_32=")))) {
				}
				else {
					$newEnvironmentValue += $line; 
				}
			}
			
			$newEnvironmentValue += $value;
			
			CreateNewRegistryItem $registryPath $name $newEnvironmentValue
		}
		catch {
			WRITE-WARNING "Failed modifying environment variable. Please contact support."
		}
	}
}

Function GetEnvironmentSettingValue([string]$installPath) 
{
	$environmentVal = @();
	if($IncludeDotNetFramework)
	{
		$environmentVal += "COR_ENABLE_PROFILING=1";
		$environmentVal += ("COR_PROFILER=" + $profilerId);
		$environmentVal += ("COR_PROFILER_PATH_64=" + (Join-Path $installPath "NETFramework\x64\ClrProfilerAgent.dll"));
		$environmentVal += ("COR_PROFILER_PATH_32=" + (Join-Path $installPath "NETFramework\x86\ClrProfilerAgent.dll"));
	}
	$environmentVal += "CORECLR_ENABLE_PROFILING=1";
	$environmentVal += ("CORECLR_PROFILER=" + $profilerId); 
	$environmentVal += ("CORECLR_SITE24X7_HOME=" + $installPath);
	$environmentVal += ("CORECLR_PROFILER_PATH_64=" + (Join-Path $installPath "x64\ClrProfilerAgent.dll")); 
	$environmentVal += ("CORECLR_PROFILER_PATH_32=" + (Join-Path $installPath "x86\ClrProfilerAgent.dll")); 
	$environmentVal += ("DOTNET_ADDITIONAL_DEPS=" + (Join-Path $installPath "additionalDeps;")); 
	$environmentVal += ("DOTNET_SHARED_STORE=" + (Join-Path $installPath "store;"));
	$environmentVal += ("S247_LICENSE_KEY=" + $LicenseKey);
	return $environmentVal;
}

Function CreateNewRegistryItem([string]$registryPath, [string]$name, [string[]]$newRegistryValue) 
{
	New-ItemProperty -Path $registryPath `
		-Name $name `
		-Value $newRegistryValue `
		-PropertyType MultiString `
		-Force | Out-Null
}

Function IsAdmin() 
{
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

Function ValidateParameters() 
{
    if ($InstallType) { $InstallType = $InstallType.ToLower().Trim()}
    if ($Destination) { $Destination = $Destination.Trim()}
    if ($LicenseKey) { $LicenseKey = $LicenseKey.Trim()}
    if ($AppName) { $AppName = $AppName.Trim() }

    If (-Not($Destination)) {
        Write-Host "
		Please provide -Destination parameter.
		"
        exit
    }
    
    If (-Not($InstallType)) {
        Write-Host "
		Please provide -InstallType parameter as global or local.
		"
        exit
    }
    
    If (-Not($LicenseKey)) {
        Write-Host "
		Please provide -LicenseKey parameter.
		"
        exit
    }
}

If ($Help) {
    Get-Content "InstallAgentHelp.txt"
    exit
}

Function CreateVersionInfoFile([string]$agentPath)
{
	$AgentVersion | Set-Content (Join-Path $agentPath "version.info")
}

Function CheckAdminRights() {
    If (-Not(IsAdmin) -And ($installType -eq "global")) {
        Write-Host "You must have administrator rights to install the agent globally. Please run this script from an elevated shell."
        exit
    }
    
    If (-Not(IsAdmin) -And $ResetIIS) {
        Write-Host "You must have administrator rights to perform an IISReset. Please run this script from an elevated shell."
        exit
    }
}

Function SetFolderPermissions($directory) {
	try
	{
		$acl = (Get-Item $directory).GetAccessControl('Access')
		$rule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
		$acl.AddAccessRule($rule1)
		$rule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
		$acl.AddAccessRule($rule2)
		$rule3 = New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.WindowsIdentity]::GetCurrent().Name, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
		$acl.AddAccessRule($rule3)
		$acl.SetAccessRuleProtection($True,$False)
		Set-Acl $directory $acl
	}
	catch {
		WRITE-WARNING "Failed setting folder permission. Kindly ignore."
	}
}

ValidateParameters
CheckAdminRights
InstallAgent

# SIG # Begin signature block
# MIIl6AYJKoZIhvcNAQcCoIIl2TCCJdUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCeVy1Hqxfm/VEw
# X56Q6GJAImFGrXZikYbuAPOShNMm1aCCC30wggWAMIIEaKADAgECAhEA0Z2xpUL/
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
# BCDEplkeptTaK9gVSQ/1YfAHQS1vgz3hgeKsl4MMGeT9pzBUBgorBgEEAYI3AgEM
# MUYwRKBCgEAAWgBPAEgATwAgAEMAbwByAHAAbwByAGEAdABpAG8AbgAgAFAAcgBp
# AHYAYQB0AGUAIABMAGkAbQBpAHQAZQBkMA0GCSqGSIb3DQEBAQUABIIBAKtyrPJc
# XA/Feq/n33PDsjbXMGTo01bGNVRUn70W7xm5/xBixoVLYxJRWkP05SCAsDxJMfj7
# JfTwKEvqKvT/EOEOiJSMIoXILQmg1ujbfP0g3PZv+EwYc6oGnDuRYgJv9IAe10Bb
# +kCZx2tgRuXf85VJLSQKe760qmqFM3i3QErKeIBr95LRoJjWIc0QLIlPC96ky58j
# Sv94Evmkw30HKxuqz2FaUa6ZDkRD1nO3eifkhMZdX2xsFM6yVGy84DOeipDvOsFU
# tkBf13M3ZFs89mEdLunNcyQXecnA3tfYX5J/JOP45nG5tO2P38FPWFxzS2CEal7z
# uXcaY9NMTFQvAuahghc9MIIXOQYKKwYBBAGCNwMDATGCFykwghclBgkqhkiG9w0B
# BwKgghcWMIIXEgIBAzEPMA0GCWCGSAFlAwQCAQUAMHcGCyqGSIb3DQEJEAEEoGgE
# ZjBkAgEBBglghkgBhv1sBwEwMTANBglghkgBZQMEAgEFAAQgBpQK/s5r6qhSiAFJ
# rmNTl56LVIhJp1pbABIis8b5cJACEFdox0vomHwKT/TBrf8Mt4wYDzIwMjMwNzA0
# MDYzOTA4WqCCEwcwggbAMIIEqKADAgECAhAMTWlyS5T6PCpKPSkHgD1aMA0GCSqG
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
# 9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIzMDcwNDA2Mzkw
# OFowKwYLKoZIhvcNAQkQAgwxHDAaMBgwFgQU84ciTYYzgpI1qZS8vY+W6f4cfHMw
# LwYJKoZIhvcNAQkEMSIEIC7DiPcjWTqAmAL2QVlFbiBWnfLrBDcT0ZZmldlrhFJZ
# MDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIEIMf04b4yKIkgq+ImOr4axPxP5ngcLWTQ
# TIB1V6Ajtbb6MA0GCSqGSIb3DQEBAQUABIICAHuDbsYabEAJH10XSQ2mE+onHPKv
# vS3ZlUutVWikalVauio1wRzptPnzFy+f/QR38yhT9Hrb9HzT8zRUN+E9ICq72UqG
# oCC8qQBKnjAhGiTWazuGWvBmKZCQfIgJCX6C6vo7DnXUoWE665PzWYYi+zyUxJOn
# Wqif7QFpaigt9XbMZyCfaSsqEqNmArxTI20MXQqhaPAV5QUm6/MYNLVOXmMCIgpA
# /eRuwkOR5blP+7TUUBPo+zgxoHJyHQJKD3VbabC8lkFCtvSZK2rRYNgZNdF5rBjX
# 03L5SJuILS8IU7xLGC1bM1XdwCTVhrnVXlo8GGrQNk2lnxqxmAyD3ybmAaw/L0Ww
# M4uWAwz65HglD/jeWZFuoihViVlxqozKeuqn5PkRQCKUOdxCIi55SMyyBClMBJoV
# GRTZtM/Gdqpqy/iHNr6ok7OqzOOW33CL/9rbamWDxjQyFhvmx3f8MdVsyPSc1sG+
# QBFxN6qL2knCuaeeDjK189/bFYZ/pi8Sg75Jo+tJBAzL9kbdeB6abCH/9KW4W9Bq
# slZcg5jbwbV+qupA/SNp20VKh4fyh0OwhsNLVS5RzL2NQazKmcjIWbctKFPFUXym
# Wae6JqeL1IKwjKdZtkuo6BlSqkrp2V9onEh0OICNBkNUGsUQEBc6gRH554XRg3Ca
# JL2r6R3i/EOFHWzm
# SIG # End signature block
