function Set-HuduProcedureTask {
<#
.SYNOPSIS
Update a procedure task.

.DESCRIPTION
Updates an existing procedure task associated with either a procedure template
or a procedure run.

Behavior differs depending on Hudu version:

- Pre-2.41.0:
  Tasks are updated using legacy behavior. All provided fields are accepted.

- 2.41.0 and later:
  Tasks may belong to either a procedure template or a run.

Run-only fields:
  The following parameters only apply to tasks associated with runs:
    - Priority
    - UserId
    - AssignedUsers
    - DueDate

Forgiving behavior:
  - If run-only fields are provided for a non-run task, they are ignored and a warning is emitted.
  - The command will still update all compatible fields.
  - Unlike creation, updates will not automatically create or switch to a run context.

Notes:
  - Changing ProcedureId will update the task's associated procedure if supported by the API.
  - -RunTask indicates intent but does not force run behavior.

.PARAMETER Id
ID of the procedure task to update.

.PARAMETER Name
New task name.

.PARAMETER Description
New task description.

.PARAMETER Completed
Mark the task as completed or not.

.PARAMETER ProcedureId
Reassign the task to a different procedure or run.

.PARAMETER Position
Update task ordering position.

.PARAMETER UserId
Run-only. Single user assignment.

.PARAMETER AssignedUsers
Run-only. Array of user IDs.

.PARAMETER DueDate
Run-only. Due date.

.PARAMETER Priority
Run-only. Task priority.

.PARAMETER RunTask
Indicates intent to operate on a run task. If the target is not a run,
run-only fields will be ignored.

.PARAMETER AutoKickoff
(Not typically used for updates.) Included for compatibility; does not
automatically convert a template task into a run task.

#>    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [int]$Id,
        [string]$Name,
        [string]$Description,
        [bool]$Completed,
        [int]$ProcedureId,
        [int]$Position,
        [int]$UserId,
        [string]$DueDate,
        [ValidateSet("unsure", "low", "normal", "high", "urgent")]
        [string]$Priority,
        [int[]]$AssignedUsers,

        # 2.41.0+ only
        [switch]$RunTask,
        [switch]$AutoKickoff
    )

    if (-not $script:HuduVersion) {
        [version]$script:HuduVersion = (Get-HuduAppInfo).version
    }

    if ($script:HuduVersion -lt [version]'2.41.0') {
        if ($PSBoundParameters.ContainsKey('RunTask') -or $PSBoundParameters.ContainsKey('AutoKickoff')) {
            Write-Verbose "RunTask/AutoKickoff are not used on Hudu versions earlier than 2.41.0."
        }

        $legacyParams = @{}
        foreach ($kv in $PSBoundParameters.GetEnumerator()) {
            $legacyParams[$kv.Key] = $kv.Value
        }

        [void]$legacyParams.Remove('RunTask')

        return Set-HuduProcedureTaskLegacy @legacyParams
    }

    return Set-HuduProcedureTaskV241 @PSBoundParameters
}