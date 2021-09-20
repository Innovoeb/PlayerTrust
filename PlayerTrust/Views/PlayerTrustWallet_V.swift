//
//  PlayerTrustWallet_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct PlayerTrustWallet: View
{
    var body: some View
    {
        VStack
        {
            Text("This is the PlayerTrust Wallet view")
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
