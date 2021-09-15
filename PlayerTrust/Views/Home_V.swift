//
//  Home_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/14/21.
//

import SwiftUI

struct Home: View
{
    @State var isWeDoShowing = false
    @State var isWeWorkShowing = false
    @State var isCryptoHoldShowing = false
    @State var isKYPShowing = false
    
    
    var body: some View
    {
        VStack (alignment: .center, spacing: 20)
        {
            Text("What We Do")
                .onTapGesture {
                    self.isWeDoShowing = true
                }
                .sheet(isPresented: $isWeDoShowing)
                {
                    WhatWeDo()
                }
            Divider()
            Text("Casinos We Work With")
                .onTapGesture
                {
                    self.isWeWorkShowing = true
                }
                .sheet(isPresented: $isWeWorkShowing)
                {
                    WeWorkWith()
                }
            Divider()
            Text("Crypto We Hold")
                .onTapGesture
                {
                    self.isCryptoHoldShowing = true
                }
                .sheet(isPresented: $isCryptoHoldShowing)
                {
                    CryptoWeHold()
                }
            Divider()
            Text("PlayerAuth™")
                .onTapGesture
                {
                    self.isKYPShowing = true
                }
                .sheet(isPresented: $isKYPShowing)
                {
                    WhatIsKYP()
                }
            Divider()
        }
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
