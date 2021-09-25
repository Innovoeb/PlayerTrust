//
//  ContactModel.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/22/21.
//

import SwiftUI

struct ContactModel: Codable
{
    let data: ContactData
    let included: [IncludedAddress]
}

struct ContactData: Codable
{
    let attributes: ContactAttributes
}

struct ContactAttributes: Codable
{
    let DOB: String
    let name: String
    let SSN: String
    
    enum CodingKeys: String, CodingKey
    {
        case DOB = "date-of-birth"
        case SSN = "tax-id-number"
        
        case name
    }
}

struct IncludedAddress: Codable
{
    let attributes: AddressAttributes
}

struct AddressAttributes: Codable
{
    let city: String
    let postalCode: String
    let region: String
    let street1: String
    let street2: String
    
    enum CodingKeys: String, CodingKey
    {
        case postalCode = "postal-code"
        case street1 = "street-1"
        case street2 = "street-2"
        
        case city
        case region
    }
}
