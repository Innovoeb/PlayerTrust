//
//  ATMResponse_M.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/24/21.
//

import Foundation
import SwiftUI

struct ATMResponse: Codable
{
    let data: ATMData
}

struct ATMData: Codable
{
    let id: String
    let attributes: ATMAttributes
}

struct ATMAttributes: Codable
{
    let walletAddress: String
    
    enum CodingKeys: String, CodingKey
    {
        case walletAddress = "wallet-address"
    }
}
