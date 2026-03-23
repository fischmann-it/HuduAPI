function New-HuduProcedure {
    <#
    .SYNOPSIS
    Create a new Hudu process template.

    .DESCRIPTION
    Creates a new process template by calling POST /api/v1/procedures.

    This endpoint creates process templates only. It does not create runs
    (active instances). To create a run from a process, use Start-HuduProcedure.

    Behavior:
    - If CompanyId is omitted, a global template is created.
    - If CompanyId is provided, a company-specific process is created.

    .PARAMETER Name
    Name of the process.

    .PARAMETER Description
    Description text for the process.

    .PARAMETER CompanyId
    Company ID for a company-specific process.
    If omitted, a global template is created.

    .PARAMETER CompanyTemplate
    Legacy/compatibility parameter. Included only when explicitly specified.

    .EXAMPLE
    New-HuduProcedure -Name "Onboarding" -Description "New employee onboarding" -CompanyId 123

    .EXAMPLE
    New-HuduProcedure -Name "Global Onboarding Template" -Description "Template for all companies"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [string]$Description,

        [int]$CompanyId,

        [bool]$CompanyTemplate
    )

    $procedure = @{
        name = $Name
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
        $procedure['description'] = $Description
    }

    if ($PSBoundParameters.ContainsKey('CompanyId')) {
        $procedure['company_id'] = $CompanyId
    }
    else {
        $procedure['company_id'] = $null
    }

    if ($PSBoundParameters.ContainsKey('CompanyTemplate')) {
        $procedure['company_template'] = $CompanyTemplate
    }

    $payload = $procedure | ConvertTo-Json -Depth 10

    try {
        $res = Invoke-HuduRequest -Method POST -Resource "/api/v1/procedures" -Body $payload
        return ($res.procedure ?? $res)
    }
    catch {
        Write-Warning "Failed to create procedure '$Name': $($_.Exception.Message)"
        return $null
    }
}