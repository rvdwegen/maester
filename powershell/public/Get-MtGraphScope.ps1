﻿<#
 .Synopsis
    Returns the list of Graph scopes required to run Maester.

 .Description
    Use this cmdlet to connect to Microsoft Graph using Connect-MgGraph.

 .Example
    Connect-MgGraph -Scopes (Get-MtGraphScope)

    Connects to Microsoft Graph with the required scopes to run Maester.

 .Example
    Connect-MgGraph -Scopes (Get-MtGraphScope -SendMail)

    Connects to Microsoft Graph with the required scopes to run Maester and send email.
#>

Function Get-MtGraphScope {

    [CmdletBinding()]
    param(
        # If specified, the cmdlet will include the scope to send email (Mail.Send).
        [Parameter(Mandatory = $false)]
        [switch] $SendMail
    )

    # Any changes made to these permission scopes should be reflected in the documentation.
    # /maester/website/docs/sections/permissions.md
    #
    # NOTE: We should only include read-only permissions in the default scopes.
    # Other permissions should be opted-in by the user with switches like -SendMail.


    # Default read-only scopes required for Maester.
    $scopes = [System.Collections.Generic.List[string]]@(
        #IMPORTANT: Read note above before adding any new scopes.
        'Directory.Read.All'
        'Policy.Read.All'
        'Reports.Read.All'
        'DirectoryRecommendations.Read.All'
    )

    if ($SendMail) {
        Write-Verbose -Message "Adding SendMail scope."
        $scopes.Add("Mail.Send")
    }

    return $scopes
}
