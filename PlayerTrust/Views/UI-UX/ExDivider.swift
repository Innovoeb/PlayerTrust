//
//  ExDivider.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/27/21.
//

import SwiftUI

struct ExDivider: View
{
    let playertrustGreen = Color(red: 57 / 255, green: 102 / 255, blue: 85 / 255)
    //let width: CGFloat = 2
    
    var body: some View
    {
        Rectangle()
            .fill(playertrustGreen)
            .frame(height: 5.0)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct ExDivider_Previews: PreviewProvider {
    static var previews: some View {
        ExDivider()
    }
}
