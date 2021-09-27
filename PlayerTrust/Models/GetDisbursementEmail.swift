//
//  GetDisbursementEmail.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/26/21.
//

import Foundation
import SwiftUI

struct GetDisbursementEmail: Codable
{
    let data: DisbursementEmailData
}

struct DisbursementEmailData: Codable
{
    let id: String
}
