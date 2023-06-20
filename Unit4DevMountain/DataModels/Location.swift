//
//  Location.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/17/23.
//

import Foundation

struct Location: Decodable {
    var city: String
    var state: String
    var displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case state = "state"
        case displayAddress = "display_address"
    }
}
