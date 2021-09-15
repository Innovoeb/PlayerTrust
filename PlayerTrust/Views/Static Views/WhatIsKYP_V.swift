//
//  WhatIsKYP.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/15/21.
//

import SwiftUI

struct WhatIsKYP: View
{
    var body: some View
    {
        VStack (spacing: 15)
        {
            Text("What is KYP?")
                .font(.largeTitle)
            Text(Constants.dummyText)
        }
        .padding(.horizontal)
    }
}

struct WhatIsKYP_Previews: PreviewProvider {
    static var previews: some View {
        WhatIsKYP()
    }
}
