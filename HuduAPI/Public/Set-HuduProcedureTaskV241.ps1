function Set-HuduProcedureTaskV241 {
<#
.SYNOPSIS
Update a procedure task (Hudu 2.41.0+ behavior).

.DESCRIPTION
Updates a task belonging to either a procedure template or a run.

Run-only fields (Priority, UserId, AssignedUsers, DueDate) are:
  - Applied only when the task belongs to a run
  - Ignored with a warning when applied to a template task

This implementation favors compatibility and will update all valid fields
while ignoring incompatible ones.
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int]$Id,

        [string]$Name,

        [string]$Description,

        [bool]$Completed,

        [int]$ProcedureId,

        [int]$Position,

        [int]$UserId,

        [datetime]$DueDate,

        [ValidateSet("unsure", "low", "normal", "high", "urgent")]
        [string]$Priority,

        [int[]]$AssignedUsers,

        [switch]$RunTask
    )

    $existingTask = Get-HuduProcedureTasks -Id $Id
    if (-not $existingTask) {
        throw "Could not retrieve procedure task ID $Id."
    }

    $targetProcedureId = if ($PSBoundParameters.ContainsKey('ProcedureId')) {
        $ProcedureId
    }
    else {
        $existingTask.procedure_id
    }

    if (-not $targetProcedureId) {
        throw "Could not determine procedure ID for task ID $Id."
    }

    $procedureContext = Get-HuduProcedureContext -ProcedureId $targetProcedureId
    if (-not $procedureContext) {
        throw "Could not determine procedure context for procedure ID $targetProcedureId."
    }

    $runOnlyFields = @('Priority','UserId','AssignedUsers','DueDate')
    $presentRunFields = @($runOnlyFields.Where({ $PSBoundParameters.ContainsKey($_) }))
    $runParamsPresent = $presentRunFields.Count -gt 0

    $isRun = ($procedureContext.IsRun -eq $true)

    if ($RunTask -and -not $isRun) {
        Write-Warning "Task ID $Id is not associated with a run. Run-only fields will be ignored."
    }

    $task = @{}

    if ($PSBoundParameters.ContainsKey('Name'))         { $task.name         = $Name }
    if ($PSBoundParameters.ContainsKey('Description'))  { $task.description  = $Description }
    if ($PSBoundParameters.ContainsKey('Completed'))    { $task.completed    = $Completed }
    if ($PSBoundParameters.ContainsKey('ProcedureId'))  { $task.procedure_id = $targetProcedureId }
    if ($PSBoundParameters.ContainsKey('Position'))     { $task.position     = $Position }

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

        Write-Warning ("The following fields can only be set on run tasks and were ignored for procedure/template task update: {0}" -f ($presentRunFields -join ', '))
    }

    $payload = @{ procedure_task = $task } | ConvertTo-Json -Depth 10

    try {
        $res = Invoke-HuduRequest -Method PUT -Resource "/api/v1/procedure_tasks/$Id" -Body $payload
        return ($res.procedure_task ?? $res)
    }
    catch {
        Write-Warning "Failed to update procedure task ID $Id- $($_.Exception.Message)"
        return $null
    }
}