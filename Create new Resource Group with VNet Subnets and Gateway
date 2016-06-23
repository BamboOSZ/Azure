## Connect to Azure Subscription
Login-AzureRmAccount
clear
#Parameters
########################################
$RGName = 'CAF-Resource-Group'
$Location = 'West Europe'

$VNET = 'CAF-Virtual-Network'
$VnetAddressPrefix = "10.20.0.0/16"
$Prefix = "10.20.0.0/24"
$Subnet = 'CAF-Subnet'

$GWPrefix = '10.20.1.0/24'
$VNETGWIP = 'CAF-Virtual-Network-Gateway-IP'
$GWSubnet = 'GatewaySubnet'

$ClassicVNET = 'ConduceVNet'
$ClassicPrefix = '10.10.0.0/16'
$ClassicGWIP = 'X.X.X.X'
$SharedKey = 'XXXXXXXXXXXXXXXXXXXXXXXXXXX'
#########################################

#Create new Resource Group
New-AzureRMResourceGroup -Name $RGName -Location $Location

#Create ARM gateway public IP
$GWIP = New-AzureRmPublicIpAddress -Name $VNETGWIP -ResourceGroupName $RGName -Location $Location -AllocationMethod Dynamic

#Create subnets
$Sub = New-AzureRmVirtualNetworkSubnetConfig -Name $Subnet -AddressPrefix $Prefix
$GWSub = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnet -AddressPrefix $GWPrefix

#create Vnet with subnets
$vnetObj = New-AzureRmVirtualNetwork -Name $VNET `
                -ResourceGroupName $RGName `
                -Location $Location `
                -AddressPrefix $VnetAddressPrefix `
                -Subnet $Sub, $GWSub

$SubnetConfig = (Get-AzurermVirtualNetworkSubnetConfig -VirtualNetwork $vnetObj -Name $GWSubnet).Id

#Create Classic local network gateway
$ClassicGW = New-AzureRmLocalNetworkGateway -Name ($ClassicVNET + "-LocalNetwork") -ResourceGroupName $RGName -Location $Location -AddressPrefix $ClassicPrefix -GatewayIpAddress $ClassicGWIP
$GWConfig = New-AzurermVirtualNetworkGatewayIpConfig -Name ($VNET + "-2-" + $ClassicVNET + “-Gateway-Config”) -SubnetId $SubnetConfig -PublicIpAddressId $GWIP.Id

#Create ARM network gateway (Can take long time - around 20 min)
$GW = New-AzurermVirtualNetworkGateway -Name ($VNET + "-2-" + $ClassicVNET+ “-Gateway”) -ResourceGroupName $RGName -Location $Location -IpConfigurations $GWConfig -GatewayType VPN -VpnType RouteBased

#Create gateway connection
New-AzurermVirtualNetworkGatewayConnection -Name ($VNET + "-2-" + $ClassicVNET+ “-Connection”) -ResourceGroupName $RGName -Location $Location -VirtualNetworkGateway1 $GW -LocalNetworkGateway2 $ClassicGW -ConnectionType IPsec -SharedKey $SharedKey
