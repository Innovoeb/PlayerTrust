//
//  PlayerTrustWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct PlayerTrustWallet: View
{
    @EnvironmentObject var user: User
    let window = UIApplication.shared.windows.first
    
    
    var body: some View
    {
        VStack
        {
            Spacer()
            VStack (spacing: 25)
            {
                if (user.walletsCreated == true)
                {
                    // show PlayerTrust Wallet Balance
                    
                }
                else
                {
                    Text("Press the Deposit button to add tokens into your PlayerTrust wallet")
                }
                
                // static buttons; always showing whether the end user has made a deposit before or not
                Button("Deposit")
                {
                    if (user.walletsCreated == false)
                    {
                        // run a method that sends a POST to create asset transfer methods for all 3 tokens
                        user.createATM()
                        
                        // navigate to Deposit Address tab view
                        window?.rootViewController = UIHostingController(rootView: DepositAddresses().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                    else
                    {
                        // just navigate to the deposit address tab view
                        window?.rootViewController = UIHostingController(rootView: DepositAddresses().environmentObject(User()))
                        window?.makeKeyAndVisible()
                    }
                }
                Button("Withdraw")
                {
                    // send to withdraw crypto form view
                }
            }
            Spacer()
        }
        .onAppear()
        {
            //user.getCurrentUserDocument()
        }
        Spacer()
        AccountHomeButton()
    }
}

struct PlayerTrustWallet_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTrustWallet()
    }
}
