//
//  CreateAccountResponse.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/18/21.
//

import SwiftUI

struct CreateAccountResponse: Codable
{
    let data: ResponseData
}

struct ResponseData: Codable
{
    let id: String
    let attributes: ResponseAttributes
    let relationships: Relationships
}

struct ResponseAttributes: Codable
{
    let name: String
    let status: String
}

struct Relationships: Codable
{
    let contacts: Contacts
    
}

struct Contacts: Codable
{
    let data: [ContactsData]
}

struct ContactsData: Codable
{
    let id: String
}
