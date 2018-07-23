Add-PSSnapin Microsoft.Exchange.Management.Powershell.Admin -erroraction silentlyContinue

##### Email Configuration Section ##### 

$SMTPName = ""
$EmailMessage = new-object Net.Mail.MailMessage
$SMTPServer = new-object Net.Mail.SmtpClient($SMTPName)
$EmailMessage.From = ""
$EmailMessage.To.Add("")

##### Enter Serverr List ##### 
$servername=""

##### Enter the remaining date before certificate is expired ######
$daysremain=30
 
 
$certlist=Invoke-Command -ComputerName $servername {Get-ChildItem Cert:\LocalMachine\My -Recurse |
    Where-Object {$_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] -and $_.NotAfter -gt (Get-Date) -and $_.NotAfter -lt (Get-Date).AddDays($daysremain)}
    }


if ($certlist){
    # Begin creation of the HTML for the email
    $body = "<head>"
    $body = $body + "<style>"
    $body = $body + "BODY{background-color:white;}" 
    $body = $body + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}" 
    $body = $body + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:grey}" 
    $body = $body + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color:white}" 
    $body = $body + "td.green{background-color: green; color: black;}"
    $body = $body + "td.gray{background-color: gray; color: black;}"
    $body = $body + "td.silver{background-color: silver; color: black;}"
    $body = $body + "td.fsdata{background-color: #87AFC7; color: black;}"
    $body = $body + "td.red{background-color: red; color: black;}"
    $body = $body + "H4{background-color: Gold; color: black;}"
    $body = $body + "H5{color: gray;}"
    $body = $body + "</style>"
    $body = $body + "</head>"
    $body = $body + "<body>"
    $body = $body + "<font size=" + '"2"' + " face=" + '"arial black"' + ">"
    $body = $body + "<H3 align=" + '"center"' + ">Warning, SSL Certificate(s) in server $servername needs your attention</H3>"
    $body = $body + "</font>"

    foreach ($certificate in $certlist) {
        $body = $body + "<font align="+ '"left"' +">Certificate Issued To = " +  $certificate.Issuer + "</font><br />"
        $body = $body + "<font align="+ '"left"' +">Expired Date = " +  $certificate.NotAfter + "</font><br /><br />"
    }

    $body = $body + "</body>"


    ##### Send The email with result #####
    $EmailMessage.Subject = "[ATTENTION] There is SSL Certificate(s) that need your attention"
    $EmailMessage.Body = $body
    $EmailMessage.IsBodyHTML = $true 
    $SMTPServer.Send($EmailMessage)
}
