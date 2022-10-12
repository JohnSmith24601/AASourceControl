Param(    
    [Parameter(Mandatory = $false)] 
    [String] $ResourceGroupName
)

Connect-AzAccount -Identity

if ($ResourceGroupName) { 
    Write-Output "Resource Group specified: $($ResourceGroupName)"
    $VMs = Get-AzVM -ResourceGroupName $ResourceGroupName
}
else { 
    Write-Output "No Resource Group specified"
    $VMs = Get-AzVM
}


foreach ($VM in $VMs)
{
	$StopRtn = $VM | Stop-AzVM -Force -ErrorAction Continue

	if ($StopRtn.Status -ne 'Succeeded')
	{
		# The VM failed to stop, so send notice
        Write-Output ($VM.Name + " failed to stop")
        Write-Error ($VM.Name + " failed to stop. Error was:") -ErrorAction Continue
		Write-Error (ConvertTo-Json $StopRtn.Error) -ErrorAction Continue
	}
	else
	{
		# The VM stopped, so send notice
		Write-Output ($VM.Name + " has been stopped")
	}
}
