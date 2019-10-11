//
//  File.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

struct FoodModel: Codable {
    var name: String?
    var description: String?
    var price: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "description"
        case price = "price"
        case image = "image"
    }
}

struct FoodServiceResponseModel: Codable {
    var name: String?
    var description: String?
    var foodItems: [FoodModel]? = []

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Description"
        case foodItems = "food_items"
    }
}


