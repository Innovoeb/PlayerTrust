//
//  WhatWeDo.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/15/21.
//

import SwiftUI

struct WhatWeDo: View
{
    var body: some View
    {
        VStack (spacing: 15)
        {
            Text("What We Do")
                .font(.largeTitle)
            Text(Constants.dummyText)
        }
        .padding(.horizontal)
    }
}

struct WhatWeDo_Previews: PreviewProvider {
    static var previews: some View {
        WhatWeDo()
    }
}
