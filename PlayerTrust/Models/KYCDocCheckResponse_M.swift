//
//  KYCDocCheckResponse_M.swift
//  PlayerTrust
//
//  Created by Beovonni on 9/25/21.
//

import Foundation
import SwiftUI

struct KYCDocCheckResponse: Codable
{
    let data: KYCDocCheckData
}

struct KYCDocCheckData: Codable
{
    let id: String
}
