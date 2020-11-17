$tenantID = "<Insert tenantId here"
$ApplicationClientID = "<insert App ClientID here"
$ClientSecret = "<Insert Client secret here"
$graphUrl = 'https://graph.microsoft.com'
$tokenEndpoint = "https://login.microsoftonline.com/$tenantID/oauth2/token"

$tokenHeaders = @{
  "Content-Type" = "application/x-www-form-urlencoded";
}

$tokenBody = @{
  "grant_type"    = "client_credentials";
  "client_id"     = "$ApplicationClientID";
  "client_secret" = "$ClientSecret";
  "resource"      = "$graphUrl";
}

# Post request to get the access token so we can query the Microsoft Graph (valid for 1 hour)
$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Headers $tokenHeaders -Body $tokenBody

# Create the headers to send with the access token obtained from the above post
$queryHeaders = @{
  "Content-Type"  = "application/json"
  "Authorization" = "Bearer $($response.access_token)"
}

# Create the URL to access all the users and send the query to the URL along with authorization headers
$queryUrl = $graphUrl + "/v1.0/auditLogs/signIns"
$signInLogs = Invoke-RestMethod -Method Get -Uri $queryUrl -Headers $queryHeaders

$signInLogEntries = $signInLogs.value

$filteredfailedsignins = $signInLogEntries | where { $_.Status -like "*Invalid username or password or Invalid on-premise username or password.*" }

# Print the results
$filteredfailedsignins
