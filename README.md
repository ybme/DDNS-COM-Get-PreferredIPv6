# DDNS-COM-Get-PreferredIPv6
##### 该脚本用于 在 DDNS-Go 中 以 通过命令获取 IPV6 地址
##### 如果你和我一样，遇到了 中文字符无法 识别为条件的问题，请尝试保存脚本文件的编码格式为ASCII

### 步骤 1：打开 PowerShell 以管理员身份运行
右键点击 "开始" 菜单按钮，然后选择 "Windows PowerShell（管理员）"。
如果系统提示用户帐户控制（UAC），点击 "是" 允许 PowerShell 以管理员权限运行。
### 步骤 2：更改执行策略
在管理员 PowerShell 窗口中，运行以下命令以更改执行策略：
Set-ExecutionPolicy RemoteSigned
然后，系统会提示您确认更改，输入 Y 并按回车键确认。

### 步骤 3：先将以下代码取消 #，得到自己电脑的网卡信息
```
# 输出所有找到的 IPv6 地址及其接口，用于调试过程中不同计算机环境，查看网络信息
# Write-Output "All IPv6 Addresses:"
# $ipv6Addresses | ForEach-Object { Write-Output "$($_.IPAddress) on $($_.InterfaceAlias)" }
```
### 步骤 4： 更改脚本中的搜索条件

```
# 设置需要获取的IPv6地址的顺序，第一个一般为全球单播地址，稳定可靠，但是长期暴露有安全风险，第二个地址一般为临时地址，更新频繁，但隐私保护更好
$targetIndex = 2

# 设置接口名称和IPv6前缀， 以太网 与 WLAN 有先后顺序，查找的前缀请根据第3步中得到的信息调整，一般电信为 240e
$interfaceNames = @("以太网", "WLAN")
$ipv6Prefix = "240e*"
```
### 步骤 5：打开DDNS-Go的设置界面，改为通过命令获取，类似以下：
![image](https://github.com/user-attachments/assets/8c24c843-746b-4697-b7b8-b7168ed41583)


### 文件下载与新建说明：
可下载Get-PreferredIPv6.ps1文件放在你电脑中的某个位置，然后按照步骤5设置它
或者将以下全文Copy为文本后，保存为 Get-PreferredIPv6.ps1 文件，或者其他文件名，然后按照步骤5设置
```
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

```

版权声明：除截图外的文章内容，代码，代码注释，注意事项，排故过程，均由ChatGPT生成
