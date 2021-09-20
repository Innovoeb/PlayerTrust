//
//  AccountModel_M.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/19/21.
//

import SwiftUI

struct AccountModel: Codable
{
    let accountData: AccountData
    
    enum CodingKeys: String, CodingKey
    {
        case accountData = "data"
    }
}

struct AccountData: Codable
{
    let id: String
    let attributes: AccountAttributes
}

struct AccountAttributes: Codable
{
    let status: String
}
