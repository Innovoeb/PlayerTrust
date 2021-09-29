//
//  DepositAddresses_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/24/21.
//

import SwiftUI

struct DepositAddresses: View
{
    @EnvironmentObject var user: User
    
    var body: some View
    {
        VStack
        {
            TabView
            {
                BitcoinWallet().environmentObject(User())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "bitcoinsign.circle")
                            Text("Bitcoin")
                        }
                    }
                
                EtherWallet().environmentObject(User())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "bitcoinsign.circle")
                            Text("Ether")
                        }
                    }
                
                XRPWallet().environmentObject(User())
                    .tabItem
                    {
                        VStack
                        {
                            Image(systemName: "bitcoinsign.circle")
                            Text("XRP")
                        }
                    }
            }
            Divider()
            
            Spacer()
            HStack (spacing: 65)
            {
                AccountHomeButton()
                PlayerTrustWalletButton()
                LogoutButton()
            }
        }
    }
}

struct DepositAddresses_V_Previews: PreviewProvider {
    static var previews: some View {
        DepositAddresses()
    }
}
