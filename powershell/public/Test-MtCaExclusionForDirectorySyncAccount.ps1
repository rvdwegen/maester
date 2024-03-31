<#
 .Synopsis
    Checks if all conditional access policies scoped to all cloud apps and all users exclude the directory synchronization accounts

 .Description
    The directory synchronization accounts are used to synchronize the on-premises directory with Entra ID.
    These accounts should be excluded from all conditional access policies scoped to all cloud apps and all users.
    Entra ID connect does not support multifactor authentication.
    Restrict access with these accounts to trusted networks.

 .Example
  Test-MtCaExclusionForDirectorySyncAccount
#>

Function Test-MtCaExclusionForDirectorySyncAccount {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'PolicyIncludesAllUsers is used in the condition.')]
    [CmdletBinding()]
    [OutputType([bool])]
    param ()

    $DirectorySynchronizationAccountRoleTemplateId = "d29b2b05-8046-44ba-8758-1e26182fcf32"
    $DirectorySynchronizationAccountRoleId = Invoke-MtGraphRequest -RelativeUri "directoryRoles(roleTemplateId='$DirectorySynchronizationAccountRoleTemplateId')" -Select id | Select-Object -ExpandProperty id
    $DirectorySynchronizationAccounts = Invoke-MtGraphRequest -RelativeUri "directoryRoles/$DirectorySynchronizationAccountRoleId/members" -Select id | Select-Object -ExpandProperty id

    $policies = Get-MtConditionalAccessPolicy | Where-Object { $_.state -eq "enabled" }

    $testDescription = "It is recommended to exclude directory synchronization accounts from all conditional access policies scoped to all cloud apps."
    $testResult = "The following conditional access policies are scoped to all users but don't exclude the directory synchronization accounts:`n`n"

    $result = $true
    foreach ($policy in ( $policies | Sort-Object -Property displayName ) ) {
        if ( $policy.conditions.applications.includeApplications -ne "All" ) {
            # Skip this policy, because it does not apply to all applications
            $currentresult = $true
            Write-Verbose "Skipping $($policy.displayName) - $currentresult"
            continue
        }

        $PolicyIncludesAllUsers = $false
        $PolicyIncludesRole = $false
        $DirectorySynchronizationAccounts | ForEach-Object {
            if ( $_ -in $policy.conditions.users.includeUsers  ) {
                $PolicyIncludesAllUsers = $true
            }
        }
        if ( $DirectorySynchronizationAccountRoleTemplateId -in $policy.conditions.users.includeRoles ) {
            $PolicyIncludesRole = $true
        }

        if ( $PolicyIncludesAllUsers -or $PolicyIncludesRole ) {
            # Skip this policy, because all directory synchronization accounts are included and therefor must not be excluded
            $currentresult = $true
            Write-Verbose "Skipping $($policy.displayName) - $currentresult"
        } else {
            if ( $DirectorySynchronizationAccountRoleTemplateId -in $policy.conditions.users.excludeRoles ) {
                # Directory synchronization accounts are excluded
                $currentresult = $true
            } else {
                # Directory synchronization accounts are not excluded
                $currentresult = $false
                $result = $false
                $testResult += "  - [$($policy.displayname)](https://entra.microsoft.com/#view/Microsoft_AAD_ConditionalAccess/PolicyBlade/policyId/$($($policy.id))?%23view/Microsoft_AAD_ConditionalAccess/ConditionalAccessBlade/~/Policies?=)`n"
            }
        }

        Write-Verbose "$($policy.displayName) - $currentresult"
    }

    if ( $result ) {
        $testResult = "All conditional access policies scoped to all cloud apps exclude the directory synchronization accounts."
    }
    Add-MtTestResultDetail -Description $testDescription -Result $testResult

    return $result
}