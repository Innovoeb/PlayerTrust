//
//  AssetBalance.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/26/21.
//

import Foundation
import SwiftUI

struct AssetTotals: Codable
{
    
}


struct AssetBalance: Codable
{
    var data: [AssetBalanceData]
}

struct AssetBalanceData: Codable
{
    let attributes: AssetBalanceAttributes
}

struct AssetBalanceAttributes: Codable
{
    let name: String
    let disbursable: Double
}
