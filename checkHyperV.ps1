$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
# Check if Hyper-V is enabled
if($hyperv.State -eq "Enabled") {
    write-host "Hyper V est activé."
    exit 0
} else {
    write-host "Hyper V n'est pas activé."
    exit 1
}