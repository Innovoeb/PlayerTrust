//
//  CreateAccountResponse.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI

class CreateAccountResponse: Codable, ObservableObject
{
    let data: ResponseData
    //let included: [Included]
}

struct ResponseData: Codable
{
    let attributes: ResponseAttributes
}

struct ResponseAttributes: Codable
{
    let name: String
    let status: String
}

//struct Included: Codable
//{
//    let type: String
//    let id: String
//    let attributes: ContactResponseAttributes
//}
//
//struct ContactResponseAttributes: Codable
//{
//    let amlCleared: String
//    let cipCleared: String
//
//    enum CodingKeys: String, CodingKey
//    {
//        case amlCleared = "aml-cleared"
//        case cipCleared = "cip-cleared"
//    }
//}
