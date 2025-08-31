using System.Management.Automation;

namespace ModuleCSharp.Commands;

[Cmdlet("Get", "ModuleCSharpData")]
[OutputType(typeof(string))]
public sealed class GetDataCommand : PSCmdlet
{
	[Parameter(Position = 0)]
	public string? Data { get; set; }

	protected override void BeginProcessing()
	{
		WriteObject($"Data: '{Data}'.");
	}
}
