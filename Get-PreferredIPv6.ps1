#注意保存该文件的编码格式为ASCII，否则在某些系统中无法识别中文字符串，比如： 以太网

# 设置需要获取的IPv6地址的顺序，第一个一般为全球单播地址，稳定可靠，但是长期暴露有安全风险，第二个地址一般为临时地址，更新频繁，但隐私保护更好
$targetIndex = 2

# 设置接口名称和IPv6前缀， 以太网 与 WLAN 有先后顺序
$interfaceNames = @("以太网", "WLAN")
$ipv6Prefix = "240e*"

# 获取所有 IPv6 地址及其对应的接口
$ipv6Addresses = Get-NetIPAddress -AddressFamily IPv6 | Where-Object {$_.AddressState -eq "Preferred"} | Select-Object IPAddress, InterfaceAlias

# 输出所有找到的 IPv6 地址及其接口，用于调试过程中不同计算机环境下查看网络信息
# Write-Output "All IPv6 Addresses:"
# $ipv6Addresses | ForEach-Object { Write-Output "$($_.IPAddress) on $($_.InterfaceAlias)" }

# 定义一个函数来获取符合条件的第 N 个 IPv6 地址
function Get-PreferredIPv6Address {
    param (
        [array]$ipv6Addresses,
        [string]$interfacePattern,
        [string]$ipv6Prefix,
        [int]$index
    )

    return $ipv6Addresses | Where-Object { $_.InterfaceAlias -like $interfacePattern -and $_.IPAddress -like $ipv6Prefix } | Select-Object -Skip ($index - 1) -First 1
}

# 尝试从指定的接口和前缀中获取第 N 个 IPv6 地址
$preferredIPv6 = $null
foreach ($interfaceName in $interfaceNames) {
    if (-not $preferredIPv6) {
        $preferredIPv6 = Get-PreferredIPv6Address -ipv6Addresses $ipv6Addresses -interfacePattern "*$interfaceName*" -ipv6Prefix $ipv6Prefix -index $targetIndex
    }
}

# 如果没有找到符合条件的地址，选择第 N 个符合前缀的 IPv6 地址
if (-not $preferredIPv6) {
    $preferredIPv6 = $ipv6Addresses | Where-Object { $_.IPAddress -like $ipv6Prefix } | Select-Object -Skip ($targetIndex - 1) -First 1
}

# 输出选择的 IPv6 地址
if ($preferredIPv6) {
    Write-Output $preferredIPv6.IPAddress
} else {
    Write-Output "No suitable IPv6 address found."
}
