<#
.Synopsis
	Common tests about commands.
#>

Set-StrictMode -Version 3
Import-Module ModuleCSharp

task exported_command_exists {
	$commands = (Get-Command -Module ModuleCSharp).ForEach('Name')
	$exported = @(
		$data = Import-PowerShellDataFile ..\src\Content\ModuleCSharp.psd1
		$data.AliasesToExport
		$data.CmdletsToExport
		$data.FunctionsToExport
	)
	foreach($_ in $exported) {
		assert ($_ -in $commands) "Missing exported command: '$_'."
	}
}

task command_help_synopsis {
	$commands = Get-Command -Module ModuleCSharp
	foreach($_ in $commands) {
		if (!(Get-Help $_).Synopsis.EndsWith('.')) {
			Write-Warning "$($_.CommandType) '$_': Missing synopsis or its period."
		}
	}
}
