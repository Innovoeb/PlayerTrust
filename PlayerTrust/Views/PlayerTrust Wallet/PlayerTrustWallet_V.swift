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
        Logo()
        VStack (spacing: 30)
        {
            Spacer()
            VStack (spacing: 5)
            {
                if (user.walletsCreated == true)
                {
                    Text("\(user.bitcoinTotal) BTC")
                    Text("\(user.etherTotal) ETH")
                    Text("\(user.xrpTotal) XRP")
                }
                else
                {
                    Text("Press the Deposit button to add tokens into your PlayerTrust wallet")
                }
            }
            .onAppear()
            {
                user.getCurrentUserDocument()
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false)
                { timer in
                    
                    user.getAssetBalance()
                }
            }
            .border(Color.black, width: 200.0)
            Divider()
            HStack (spacing: 65)
            {
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
                .foregroundColor(Color.black)
                Button("Withdraw")
                {
                    window?.rootViewController = UIHostingController(rootView: WithdrawForm().environmentObject(User()))
                    window?.makeKeyAndVisible()
                }
                .foregroundColor(Color.black)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear()
        {
            //user.getCurrentUserDocument()
        }
        
        Spacer()
        HStack (spacing: 65)
        {
            AccountHomeButton()
            LogoutButton()
        }
    }
}
