//
//  Businesses.swift
//  Unit4DevMountain
//
//  Created by Colby Mehmen on 6/17/23.
//

import Foundation

struct Business: Decodable {
    var name: String
    var rating: Double
    var price: String?
    var phone: String
    var displayPhone: String
    var location: Location?
    var url: String
    var imageURL: String?
    var reviewCount: Int
    var categories: [Categories]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rating = "rating"
        case price = "price"
        case phone = "phone"
        case displayPhone = "display_phone"
        case location = "location"
        case url = "url"
        case imageURL = "image_url"
        case reviewCount = "review_count"
        case categories = "categories"
    }
}
