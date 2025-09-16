<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	[string]$Configuration = (property Configuration Release)
	,
	[string]$TargetFramework = (property TargetFramework net8.0)
)

$ProgressPreference = 0
Set-StrictMode -Version 3
$ModuleName = 'ModuleCSharp'
$ModuleRoot = "$env:ProgramFiles\PowerShell\Modules\$ModuleName"

$Description = 'TODO-description'
$ProjectUrl = "https://github.com/nightroman/$ModuleName"
$Copyright = 'Copyright (c) 2025 Roman Kuzmin'

task clean {
	remove README.html, *.nupkg, z, src\*\bin, src\*\obj
}

task build meta, {
	exec { dotnet build src\$ModuleName -c $Configuration -f $TargetFramework }
}

task publish {
	exec { dotnet publish src\$ModuleName -c $Configuration -f $TargetFramework -o $ModuleRoot --no-build }
	remove $ModuleRoot\$ModuleName.deps.json, $ModuleRoot\System.Management.Automation.dll
}

task content -After publish {
	Copy-Item src\Content\* $ModuleRoot -Recurse
}

task uninstall {
	Get-ChildItem $ModuleRoot\.. -Filter $ModuleName | Remove-Item -Force -Recurse -Confirm
}

task version {
	($Script:Version = Get-BuildVersion Release-Notes.md '##\s+v(\d+\.\d+\.\d+)')
}

# https://github.com/nightroman/Helps
task help -Inputs {Get-Item Help.ps1, src\$ModuleName\Commands\*} -Outputs {"$ModuleRoot\$ModuleName.dll-Help.xml"} -Jobs {
	. Helps.ps1
	Convert-Helps Help.ps1 $Outputs
}

task markdown {
	requires -Path $env:MarkdownCss
	exec { pandoc.exe @(
		'README.md'
		'--output=README.html'
		'--from=gfm'
		'--embed-resources'
		'--standalone'
		"--css=$env:MarkdownCss"
		"--metadata=pagetitle=$ModuleName"
	)}
}

task meta -Inputs 1.build.ps1, Release-Notes.md -Outputs src\Directory.Build.props -Jobs version, {
	Set-Content src\Directory.Build.props @"
<Project>
  <PropertyGroup>
    <Company>$ProjectUrl</Company>
    <Copyright>$Copyright</Copyright>
    <Description>$Description</Description>
    <Product>$ModuleName</Product>
    <Version>$Version</Version>
    <IncludeSourceRevisionInInformationalVersion>False</IncludeSourceRevisionInInformationalVersion>
  </PropertyGroup>
</Project>
"@
}

task package help, markdown, version, {
	equals $Version (Get-Item $ModuleRoot\$ModuleName.dll).VersionInfo.ProductVersion

	remove z
	$null = mkdir z\$ModuleName

	Copy-Item -Recurse -Destination z\$ModuleName @(
		'LICENSE'
		'README.html'
		"$ModuleRoot\*"
	)

	$text1 = Get-Content z\$ModuleName\$ModuleName.psd1 -Raw
	$text2 = $text1.Replace("'0.0.0'", "'$Version'")
	assert ($text1 -ne $text2)
	Set-Content z\$ModuleName\$ModuleName.psd1 $text2 -NoNewline

	Assert-SameFile.ps1 -Result (Get-ChildItem z\$ModuleName -Recurse -File -Name) -Text -View $env:MERGE @'
about_ModuleCSharp.help.txt
LICENSE
ModuleCSharp.dll
ModuleCSharp.dll-Help.xml
ModuleCSharp.pdb
ModuleCSharp.psd1
README.html
'@
}

task pushPSGallery package, {
	$NuGetApiKey = Read-Host NuGetApiKey
	Publish-Module -Path z\$ModuleName -NuGetApiKey $NuGetApiKey
}, clean

task test {
	Invoke-Build ** tests
}

task . build, help, clean
