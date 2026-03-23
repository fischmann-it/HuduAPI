function Get-HuduProcedureContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [int]$ProcedureId
    )

    $proc = Get-HuduProcedures -Id $ProcedureId
    if (-not $proc) {
        throw "Could not retrieve procedure ID $ProcedureId"
    }

    [pscustomobject]@{
        Procedure   = $proc
        IsRun       = ($proc.run -eq $true)
        IsGlobal    = [string]::IsNullOrWhiteSpace([string]$proc.company_id)
        IsCompany   = -not [string]::IsNullOrWhiteSpace([string]$proc.company_id)
        ProcessType = $proc.process_type
        CanKickoff  = (($proc.run -ne $true) -and (-not [string]::IsNullOrWhiteSpace([string]$proc.company_id)))
    }
}