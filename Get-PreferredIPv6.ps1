#ע�Ᵽ����ļ��ı����ʽΪASCII�������޷�ʶ�������ַ��������磺 ��̫��
# ��ȡ���� IPv6 ��ַ�����Ӧ�Ľӿ�
$ipv6Addresses = Get-NetIPAddress -AddressFamily IPv6 | Where-Object {$_.AddressState -eq "Preferred"} | Select-Object IPAddress, InterfaceAlias

# ��������ҵ��� IPv6 ��ַ����ӿ�
# Write-Output "All IPv6 Addresses:"
# $ipv6Addresses | ForEach-Object { Write-Output "$($_.IPAddress) on $($_.InterfaceAlias)" }

# ����ѡ����� "��̫��" �Ľӿڵĵ�һ�����Ϲ���� IPv6 ��ַ
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.InterfaceAlias -like "*��̫��*" -and $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# ���û���ҵ����������ĵ�ַ����ѡ����� "WLAN" �Ľӿڵĵ�һ�� IPv6 ��ַ
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.InterfaceAlias -like "*WLAN*" -and $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# �����Ȼû���ҵ����������ĵ�ַ��ѡ���һ�����Ϲ���� IPv6 ��ַ
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# ���ѡ��� IPv6 ��ַ
if ($preferredIPv6) {
    Write-Output $preferredIPv6.IPAddress
} else {
    Write-Output "No suitable IPv6 address found."
}