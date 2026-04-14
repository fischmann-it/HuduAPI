---
external help file: HuduAPI-help.xml
Module Name: HuduAPI
online version:
schema: 2.0.0
---

# Set-HuduProcedureTask

## SYNOPSIS
Update a procedure task.

## SYNTAX

```
Set-HuduProcedureTask [-Id] <Int32> [[-Name] <String>] [[-Description] <String>] [[-Completed] <Boolean>]
 [[-ProcedureId] <Int32>] [[-Position] <Int32>] [[-UserId] <Int32>] [[-DueDate] <String>]
 [[-Priority] <String>] [[-AssignedUsers] <Int32[]>] [-RunTask] [-AutoKickoff]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Updates an existing procedure task associated with either a procedure template
or a procedure run.

Behavior differs depending on Hudu version:

- Pre-2.41.0:
  Tasks are updated using legacy behavior.
All provided fields are accepted.

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

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Id
ID of the procedure task to update.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
New task name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
New task description.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Completed
Mark the task as completed or not.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcedureId
Reassign the task to a different procedure or run.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position
Update task ordering position.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserId
Run-only.
Single user assignment.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DueDate
Run-only.
Due date.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Run-only.
Task priority.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignedUsers
Run-only.
Array of user IDs.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunTask
Indicates intent to operate on a run task.
If the target is not a run,
run-only fields will be ignored.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoKickoff
(Not typically used for updates.) Included for compatibility; does not
automatically convert a template task into a run task.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
