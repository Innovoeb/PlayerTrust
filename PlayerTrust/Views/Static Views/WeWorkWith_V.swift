//
//  WeWorkWith_V.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/15/21.
//

import SwiftUI

struct WeWorkWith: View
{
    var body: some View
    {
        VStack (spacing: 15)
        {
            Text("Casinos We Work With")
                .font(.largeTitle)
            Text(Constants.dummyText)
        }
        .padding(.horizontal)
    }
}

struct WeWorkWith_V_Previews: PreviewProvider {
    static var previews: some View {
        WeWorkWith()
    }
}
