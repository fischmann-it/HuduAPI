function New-HuduProcedureTask {
<#
.SYNOPSIS
Create a new procedure task.

.DESCRIPTION
Creates a new task associated with a procedure or procedure run.

Behavior differs depending on Hudu version:

- Pre-2.41.0:
  Tasks are created using legacy behavior. All provided fields are accepted
  and applied directly to the procedure task.

- 2.41.0 and later:
  Procedures are split into templates (processes) and runs (executions).
  Tasks may belong to either context.

Run-only fields:
  The following parameters only apply to tasks associated with runs:
    - Priority
    - UserId
    - AssignedUsers
    - DueDate

Forgiving behavior:
  - If run-only fields are provided for a non-run procedure, they are ignored
    and a warning is emitted.
  - If -AutoKickoff is specified and the procedure can be run, a run will be
    created automatically and the task will be associated with that run.
  - If -RunTask is specified but the target is not a run, the command will
    continue and create a template task, ignoring run-only fields.

This cmdlet is designed to be forgiving and will attempt to create the task
whenever possible, even if some parameters are not applicable in the current context.

.PARAMETER Name
Name of the task.

.PARAMETER ProcedureId
ID of the procedure or run to attach the task to.

.PARAMETER Description
Optional task description.

.PARAMETER Priority
Run-only. Priority level for the task.

.PARAMETER UserId
Run-only. Single user assignment.

.PARAMETER AssignedUsers
Run-only. Array of user IDs to assign.

.PARAMETER DueDate
Run-only. Due date for the task.

.PARAMETER Position
Optional ordering position.

.PARAMETER RunTask
Indicates intent to create a task on a run.
If the target is not a run, the command will attempt to proceed and may ignore
run-only fields.

.PARAMETER AutoKickoff
If specified and the target is a runnable procedure template, a run will be
created automatically and the task will be associated with that run.

#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Name,
        [Parameter(Mandatory)] [int]$ProcedureId,
        [string]$Description,
        [ValidateSet("unsure", "low", "normal", "high", "urgent")]
        [string]$Priority,
        [int]$UserId,
        [int[]]$AssignedUsers,
        [string]$DueDate,
        [int]$Position,
        # 2.41.0+ only
        [switch]$RunTask,
        [switch]$AutoKickoff
        )

    if (-not $script:HuduVersion) {
        [version]$script:HuduVersion = (Get-HuduAppInfo).version
    }

    if ($script:HuduVersion -lt [version]'2.41.0') {
        return New-HuduProcedureTaskLegacy @PSBoundParameters
    }

    return New-HuduProcedureTaskV241 @PSBoundParameters
}