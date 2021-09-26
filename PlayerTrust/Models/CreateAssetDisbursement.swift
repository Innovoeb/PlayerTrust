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
    let included: [IncludedAssetTransfer]
}

struct IncludedAssetTransfer: Codable
{
    let id: String
}
