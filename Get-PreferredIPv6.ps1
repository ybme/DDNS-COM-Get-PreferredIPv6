#注意保存该文件的编码格式为ASCII，否则无法识别中文字符串，比如： 以太网
# 获取所有 IPv6 地址及其对应的接口
$ipv6Addresses = Get-NetIPAddress -AddressFamily IPv6 | Where-Object {$_.AddressState -eq "Preferred"} | Select-Object IPAddress, InterfaceAlias

# 输出所有找到的 IPv6 地址及其接口，用于调试过程中不同计算机环境，查看网络信息
# Write-Output "All IPv6 Addresses:"
# $ipv6Addresses | ForEach-Object { Write-Output "$($_.IPAddress) on $($_.InterfaceAlias)" }

# 优先选择包含 "以太网" 的接口的第一个符合规则的 IPv6 地址，以及宽带网络的IPV6 前缀，比如电信是 240e，并选择第一个
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.InterfaceAlias -like "*以太网*" -and $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# 如果没有找到符合条件的地址，则选择包含 "WLAN" 的接口的第一个 IPv6 地址，以及宽带网络的IPV6 前缀，比如电信是 240e，并选择第一个

if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.InterfaceAlias -like "*WLAN*" -and $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# 如果仍然没有找到符合条件的地址，选择第一个符合前缀的 IPv6 地址
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.IPAddress -like "240e*" } | Select-Object -First 1
}

# 输出选择的 IPv6 地址
if ($preferredIPv6) {
    Write-Output $preferredIPv6.IPAddress
} else {
    Write-Output "No suitable IPv6 address found."
}
