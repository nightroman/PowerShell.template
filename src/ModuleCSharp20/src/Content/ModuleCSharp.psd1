@{
	Author = 'Roman Kuzmin'
	ModuleVersion = '0.0.0'
	Description = 'TODO-description'
	CompanyName = 'https://github.com/nightroman'
	Copyright = 'Copyright (c) 2025 Roman Kuzmin'

	RootModule = 'ModuleCSharp.dll'
	RequiredAssemblies = 'ModuleCSharp.dll'

	PowerShellVersion = '5.1'
	GUID = 'c5ba4ed8-11b9-4ff9-bdd7-f140c80e14b3'

	AliasesToExport = @()
	VariablesToExport = @()
	FunctionsToExport = @()
	CmdletsToExport = @(
		'Get-ModuleCSharpData'
	)

	PrivateData = @{
		PSData = @{
			Tags = 'ModuleCSharp'
			ProjectUri = 'https://github.com/nightroman/ModuleCSharp'
			LicenseUri = 'https://github.com/nightroman/ModuleCSharp/blob/main/LICENSE'
			ReleaseNotes = 'https://github.com/nightroman/ModuleCSharp/blob/main/Release-Notes.md'
		}
	}
}
