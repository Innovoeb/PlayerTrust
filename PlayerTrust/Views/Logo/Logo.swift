//
//  Logo.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/27/21.
//

import SwiftUI

struct Logo: View
{
    var body: some View
    {
        VStack
        {
            Image("rsz_logo_white_background")
                .frame(height: 200.0)
                .scaledToFit()
            ExDivider()
        }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
