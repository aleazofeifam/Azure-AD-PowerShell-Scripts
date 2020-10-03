$ApplicationClientID = "Your App Registration App ID"
$resource = 'https://graph.microsoft.com'
$GrantType = "password"
$ClientSecret = "Your App Reg. Secret"
$username = "Your UPN"
$password = "Your user password"
$tenantID = "Your tenantID"

$tokenEndpoint = "https://login.microsoftonline.com/$tenantID/oauth2/token"

$tokenHeaders = @{
  "Content-Type" = "application/x-www-form-urlencoded";
}

$tokenBody = @{
  "client_id"     = "$ApplicationClientID";
  "resource"      = "$graphUrl";
  "grant_type"    = "$GrantType";
  "client_secret" = "$ClientSecret";
  "username"      = "$username";
  "password"      = "$password";
}

# Post request to get the access token so we can query the Microsoft Graph (valid for 1 hour)
$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Headers $tokenHeaders -Body $tokenBody 

#$response


# Create the headers to send with the access token obtained from the above post
$queryHeaders = @{
  "Content-Type"  = "application/json"
  "Authorization" = "Bearer $($response.access_token)"
}

#Details of your Gallery App that you want to restart
$SaaSAppObjectID = "7c2a8a62-96d5-4ff8-a3a9-8f72c62XXX"
$SaaSAppJobId = "GoogV2OutDelta.ef790d9b80bb43cdad5ed2cdd6510165.9d5c6d5d-cc1e-4f38-bda2-a36db2bXXX"


#Set the request body so you can define the  reset scope
$queryBody2 = '{
 "criteria": {
    "resetScope": "Full"}
    }
 }'

# Create the URL to access all the users and send the query to the URL along with authorization headers
$queryUrl = $graphUrl + "/beta/servicePrincipals/$SaaSAppObjectID/synchronization/jobs/$SaaSAppJobId/restart"

$CallToRestart = Invoke-RestMethod -Method Post -Uri $queryUrl -Headers $queryHeaders -Body $queryBody2