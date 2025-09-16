<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	[ValidateScript({'cs20::src\ModuleCSharp20\1.build.ps1', 'cs80::src\ModuleCSharp80\1.build.ps1'})]
	$Extends
)

Set-StrictMode -Version 3

$PackageName = 'FarNet.PowerShell.template'

task clean cs20::clean, cs80::clean, {
	remove z, *.nupkg
}

task sync {
	Set-Location src
	exec { robocopy ModuleCSharp20 ModuleCSharp80 /MIR /XF template.json *.props *.build.ps1 *.csproj /XD bin obj } (0..3)
}

task package sync, {
	remove z
	exec { robocopy src z\content /S /XF *.props /XD bin obj } 1

	Copy-Item -Destination z @(
		'README.md'
		'Package.nuspec'
	)
}

task nuget package, {
	exec { NuGet.exe pack z\Package.nuspec -NoPackageAnalysis -NoDefaultExcludes }
}

task install {
	[string]$path = Resolve-Path "$PackageName.*.nupkg"
	requires -Path $path
	exec { dotnet new install $path }
}

task uninstall {
	dotnet new uninstall $PackageName
}

task . uninstall, nuget, install, clean
