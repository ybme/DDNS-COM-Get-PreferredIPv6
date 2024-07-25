# DDNS-COM-Get-PreferredIPv6

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
```
### 步骤 5：打开DDNS-Go的设置界面，改为通过命令获取，类似以下：
![image](https://github.com/user-attachments/assets/8c24c843-746b-4697-b7b8-b7168ed41583)
