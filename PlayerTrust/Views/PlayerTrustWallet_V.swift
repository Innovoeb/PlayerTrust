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
    
    
    var body: some View
    {
        VStack
        {
            if (user.accountIsOpen == true)
            {
                Text("This is the PlayerTrust Wallet view")
            }
        }
        .onAppear()
        {
            user.getCurrentUserDocument()
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
