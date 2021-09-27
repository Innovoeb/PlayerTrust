//
//  WithdrawForm_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/25/21.
//

import SwiftUI

struct WithdrawForm: View
{
    @EnvironmentObject var user: User
    
    
    
    
    
    var body: some View
    {
        let window = UIApplication.shared.windows.first
        
        VStack (spacing: 15)
        {
            VStack
            {
                Spacer()
                Menu ("Type of Coin to Withdraw")
                {
                    Button("Bitcoin")
                    {
                        user.cointype = "bitcoin"
                    }
                    Button("Ether")
                    {
                        user.cointype = "ethereum"
                    }
                    Button("XRP")
                    {
                        user.cointype = "xrp"
                    }
                }
                Divider()
                Spacer()
            }
            
            if (user.cointype == "bitcoin")
            {
                Text("BTC")
                    .font(.title)
            }
            if (user.cointype == "ethereum")
            {
                Text("Ether")
                    .font(.title)
            }
            if (user.cointype == "xrp")
            {
                Text("XRP")
                    .font(.title)
            }
            
            Form
            {
                TextField("Amount", text: $user.amount)
                TextField("Wallet Address", text: $user.outgoingWallet)
            }
            Divider()
            Button("Submit")
            {
                user.coinWithdraw()
                
                window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
                    window?.makeKeyAndVisible()
            }
            
            Spacer()
            AccountHomeButton()
        }
        .navigationTitle("Withdraw Coins")
        
        
        
        
        
        
//        NavigationView
//        {
//            VStack
//            {
//               Text("Foobar")
//                    .toolbar {
//                        ToolbarItem(placement: ToolbarItemPlacement.automatic) {
//
//                            Menu {
//                               Button("Bitcoin")
//                                {
//
//                                }
//                                Button("Ether")
//                                 {
//
//                                 }
//                                Button("XRP")
//                                 {
//
//                                 }
//                            } label: {
//                                Label(
//                                    title: { Text("Currency Type") },
//                                    icon: { Image(systemName: "plus") }
//                                )
//                            }
//
//                        }
//                    }
//            }
//
//        }
    }
}

struct WithdrawForm_V_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawForm()
    }
}
