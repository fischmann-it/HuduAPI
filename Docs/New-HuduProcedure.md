---
external help file: HuduAPI-help.xml
Module Name: HuduAPI
online version:
schema: 2.0.0
---

# New-HuduProcedure

## SYNOPSIS
Create a new Hudu process template.

## SYNTAX

```
New-HuduProcedure [-Name] <String> [[-Description] <String>] [[-CompanyId] <Int32>]
 [[-CompanyTemplate] <Boolean>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a new process template by calling POST /api/v1/procedures.

This endpoint creates process templates only.
It does not create runs
(active instances).
To create a run from a process, use Start-HuduProcedure.

Behavior:
- If CompanyId is omitted, a global template is created.
- If CompanyId is provided, a company-specific process is created.

## EXAMPLES

### EXAMPLE 1
```
New-HuduProcedure -Name "Onboarding" -Description "New employee onboarding" -CompanyId 123
```

### EXAMPLE 2
```
New-HuduProcedure -Name "Global Onboarding Template" -Description "Template for all companies"
```

## PARAMETERS

### -Name
Name of the process.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description text for the process.

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

### -CompanyId
Company ID for a company-specific process.
If omitted, a global template is created.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyTemplate
Legacy/compatibility parameter.
Included only when explicitly specified.

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
