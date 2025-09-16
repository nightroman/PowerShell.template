﻿using System.Management.Automation;

namespace ModuleCSharp.Commands;

public class AbstractCmdlet : PSCmdlet
{
    protected ErrorRecord CreateErrorRecord(Exception ex, object? targetObject = null)
    {
        return new(ex, MyInvocation.MyCommand.Name, ErrorCategory.InvalidOperation, targetObject);
    }

    protected virtual void MyBeginProcessing() { }
    protected sealed override void BeginProcessing()
    {
        try
        {
            MyBeginProcessing();
        }
        catch (Exception ex)
        {
            ThrowTerminatingError(CreateErrorRecord(ex));
        }
    }

    protected virtual void MyEndProcessing() { }
    protected sealed override void EndProcessing()
    {
        try
        {
            MyEndProcessing();
        }
        catch (Exception ex)
        {
            ThrowTerminatingError(CreateErrorRecord(ex));
        }
    }

    protected virtual void MyProcessRecord() { }
    protected sealed override void ProcessRecord()
    {
        try
        {
            MyProcessRecord();
        }
        catch (Exception ex)
        {
            ThrowTerminatingError(CreateErrorRecord(ex));
        }
    }
}
