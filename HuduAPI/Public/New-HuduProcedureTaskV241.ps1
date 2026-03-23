function New-HuduProcedureTaskV241 {
<#
.SYNOPSIS
Create a procedure task (Hudu 2.41.0+ behavior).

.DESCRIPTION
Creates a task for either a procedure template or a run.

Run-only fields (Priority, UserId, AssignedUsers, DueDate) are only applied
when the target is a run.

If run-only fields are provided for a template:
  - They are ignored
  - A warning is emitted

If -AutoKickoff is specified and the procedure is runnable:
  - A run is created automatically
  - The task is created on the run instead

This implementation is intentionally forgiving and will proceed whenever possible.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [int]$ProcedureId,

        [string]$Description,

        [int]$Position,

        [ValidateSet("unsure", "low", "normal", "high", "urgent")]
        [string]$Priority,

        [int]$UserId,

        [int[]]$AssignedUsers,

        [datetime]$DueDate,

        [switch]$RunTask,

        [switch]$AutoKickoff
    )

    $procedureContext = Get-HuduProcedureContext -ProcedureId $ProcedureId
    if (-not $procedureContext) {
        throw "Could not determine procedure context for procedure ID $ProcedureId."
    }

    $runOnlyFields = @('Priority','UserId','AssignedUsers','DueDate')
    $presentRunFields = @($runOnlyFields.Where({ $PSBoundParameters.ContainsKey($_) }))
    $runParamsPresent = $presentRunFields.Count -gt 0

    $isRun = ($procedureContext.IsRun -eq $true)

    if (-not $isRun -and $AutoKickoff -and $procedureContext.CanKickoff) {
        Write-Verbose "Procedure ID $ProcedureId is not a run. Attempting to kick off a run first."
        $run = Start-HuduProcedure -ProcedureId $ProcedureId; $run = $run.procedure ?? $run;

        if ($run -and $run.id) {
            $ProcedureId = [int]$run.id
            $isRun = $true
            Write-Verbose "Created run ID $ProcedureId for task creation."
        }
        else {
            Write-Warning "Failed to kick off a run for procedure ID $ProcedureId. Continuing without run-only fields."
        }
    }
    elseif (-not $isRun -and $RunTask) {
        Write-Warning "Procedure ID $ProcedureId is not a run. Creating a template/process task instead and ignoring run-only fields."
    }

    $task = @{
        name         = $Name
        procedure_id = $ProcedureId
    }

    if ($PSBoundParameters.ContainsKey('Description')) { $task.description = $Description }
    if ($PSBoundParameters.ContainsKey('Position'))    { $task.position    = $Position }

    if ($isRun) {
        if ($PSBoundParameters.ContainsKey('Priority'))      { $task.priority       = $Priority }
        if ($PSBoundParameters.ContainsKey('UserId'))        { $task.user_id        = $UserId }
        if ($PSBoundParameters.ContainsKey('AssignedUsers')) { $task.assigned_users = $AssignedUsers }
        if ($PSBoundParameters.ContainsKey('DueDate'))       { $task.due_date       = $DueDate.ToString('yyyy-MM-dd') }
    } elseif ($runParamsPresent) {
        [void]$task.Remove('priority')
        [void]$task.Remove('user_id')
        [void]$task.Remove('assigned_users')
        [void]$task.Remove('due_date')
        Write-Warning ("The following fields can only be set on run tasks and were ignored for procedure/template task creation: {0}" -f ($presentRunFields -join ', '))
    }

    $payload = @{ procedure_task = $task } | ConvertTo-Json -Depth 10

    try {
        $res = Invoke-HuduRequest -Method POST -Resource "/api/v1/procedure_tasks" -Body $payload
        return ($res.procedure_task ?? $res)
    }
    catch {
        Write-Warning "Failed to create procedure task '$Name': $($_.Exception.Message)"
        return $null
    }
}