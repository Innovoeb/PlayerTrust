//
//  CreateAssetDisbursement.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/25/21.
//

import Foundation
import SwiftUI

struct CreateAssetDisbursement: Codable
{
    let data: CreateDisbursementData
    let included: [IncludedAssetTransfer]
}

struct CreateDisbursementData: Codable
{
    let relationships: CreateDisbursementRelationships
}

struct CreateDisbursementRelationships: Codable
{
    let disbursementAuthorization: DisbursementAuthorization
    
    enum CodingKeys: String, CodingKey
    {
        case disbursementAuthorization = "disbursement-authorization"
    }
}

struct DisbursementAuthorization: Codable
{
    let links: Links
}

struct Links: Codable
{
    let related: String
}

struct IncludedAssetTransfer: Codable
{
    let id: String
}
