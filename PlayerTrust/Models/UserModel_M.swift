//
//  UserModel_M.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/16/21.
//

import SwiftUI

struct UserModel: Codable
{
    let userID: String?
    let userEmail: String?
    let userUsername: String?
    
    enum CodingKeys: String, CodingKey
    {
        case userID
        case userEmail = "email"
        case userUsername = "username"
    }
}
