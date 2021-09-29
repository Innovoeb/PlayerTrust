//
//  PlayerTrustWalletButton_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/28/21.
//

import SwiftUI

struct PlayerTrustWalletButton: View
{
    let window = UIApplication.shared.windows.first
    
    
    var body: some View
    {
        VStack
        {
            Image(systemName: "bag.circle.fill")
            Text("PlayerTrust Wallet™")
        }
        .onTapGesture
        {
            window?.rootViewController = UIHostingController(rootView: PlayerTrustWallet().environmentObject(User()))
            window?.makeKeyAndVisible()
        }
    }
}

struct PlayerTrustWalletButton_V_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTrustWalletButton()
    }
}
