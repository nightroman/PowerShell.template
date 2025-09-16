using System.Management.Automation;

namespace ModuleCSharp.Commands;

[Cmdlet("Get", "ModuleCSharpData")]
[OutputType(typeof(string))]
public sealed class GetDataCommand : AbstractCmdlet
{
	[Parameter(Position = 0)]
	public string? Data { get; set; }

	protected override void MyBeginProcessing()
	{
		WriteObject($"Data: '{Data}'.");
	}
}
