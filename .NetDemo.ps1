$result = $selectedServers | Invoke-Parallel {
    if (Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue) {
            Write-Host -ForegroundColor Cyan "Servername: $_ [$count/$($selectedServers.count)]"
            $ips = [System.Net.Dns]::GetHostAddresses($_)
            $ips.IPAddressToString
        }
    $count++
}

$result | Out-File -Encoding ascii -FilePath USIPs.txt
 #| Export-Csv -NoTypeInformation -Append DavidB-SplunkInfectedSpQry-AFTER.csv

get-content .\USIPS-Test.txt | foreach {
[System.Net.Dns]::gethostentry($_)
#Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue
}

$US2003= get-qadcomputer -OSName "Windows Server 2003*" -SizeLimit -1 | select -ExpandProperty Name 
$US2008= get-qadcomputer -OSName "Windows Server 2008*" -SizeLimit -1 | select -ExpandProperty Name 
$US2012= get-qadcomputer -OSName "Windows Server 2012*" -SizeLimit -1 | select -ExpandProperty Name 

$US2008 | foreach {[System.Net.Dns]::GetHostAddresses($_).IPAddressToString} | Out-File -Encoding ascii -FilePath USIPs-2008.txt
$US2012 | foreach {[System.Net.Dns]::GetHostAddresses($_).IPAddressToString} | Out-File -Encoding ascii -FilePath USIPs-2012.txt

get-content .\USIPs-2008.txt | foreach {
[System.Net.Dns]::gethostentry($_)
#Test-Connection -ComputerName $_ -Count 1 -ErrorAction SilentlyContinue
}

$USTest= get-qadcomputer "phlnm" | select -ExpandProperty Name 
$USTest| foreach {[System.Net.Dns]::GetHostAddresses($_).IPAddressToString} | Out-File -Encoding ascii -FilePath USIPs-2008Test.txt
