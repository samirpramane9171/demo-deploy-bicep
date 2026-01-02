param location string = 'westeurope'

@secure()
param adminPassword string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: 'samir-demo'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes:[
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' = {
  parent: virtualNetwork
  name: 'vmSubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: 'vm001-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource virtualNetworkInterface 'Microsoft.Network/networkInterfaces@2024-03-01' = {
  name: 'vm001-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm001'
  location: location
  properties: {
    osProfile: {
      computerName: 'vm001'
      adminUsername: 'samirpramane9270'
      adminPassword: adminPassword
    }
    hardwareProfile: {
      vmSize: 'Standard_D2_v5'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: virtualNetworkInterface.id
        }
      ]
    }
  }
}
