//
//  CryptoWeHold.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/15/21.
//

import SwiftUI

struct CryptoWeHold: View
{
    var body: some View
    {
        VStack (spacing: 15)
        {
            Text("Crypto We Hold")
                .font(.largeTitle)
            Text(Constants.dummyText)
        }
        .padding(.horizontal)
        
    }
}

struct CryptoWeHold_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWeHold()
    }
}
