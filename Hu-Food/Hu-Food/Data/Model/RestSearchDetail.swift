//
//  FoodSearch.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct Restaurant {
    var id: Int
    var name: String
    var transactions: [String]
    var distance: Double
    var categoryFood: [CategoryFood]
    var address: Address?
    var rating: Double
    var imageUrl: String
}

extension Restaurant {
    init() {
        self.init(
            id: 0,
            name: "",
            transactions: [],
            distance: 0,
            categoryFood: [],
            address: Address(),
            rating: 0,
            imageUrl: ""
        )
    }
}

extension Restaurant: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        transactions <- map["transactions"]
        rating <- map["rating"]
        distance <- map["distance"]
        imageUrl <- map["image_url"]
        categoryFood <- map["categories"]
        address <- map["location"]
    }
}
