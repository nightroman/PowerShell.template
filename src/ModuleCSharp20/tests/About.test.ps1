
Set-StrictMode -Version 3
Import-Module ModuleCSharp

task command_help_has_synopsis_with_period {
	foreach($cmd in Get-Command -Module ModuleCSharp) {
		$r = Get-Help $cmd
		if (!$r.Synopsis.EndsWith('.')) {
			Write-Warning "$($cmd.CommandType) '$cmd': missing synopsis or its period."
		}
	}
}

task exported_commands_exist {
	$exported = @(
		$data = Import-PowerShellDataFile ..\src\Content\ModuleCSharp.psd1
		$data.AliasesToExport
		$data.FunctionsToExport
		$data.CmdletsToExport
	)
	$commands = (Get-Command -Module ModuleCSharp).ForEach('Name')
	foreach($_ in $exported) {
		assert ($_ -in $commands) "Missing exported command: '$_'."
	}
}
