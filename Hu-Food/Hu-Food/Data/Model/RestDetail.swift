//
//  FoodDetail.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct RestDetail {
    var id: Int
    var name: String
    var transactions: [String]
    var distance: Double
    var price: String
    var rating: Double
    var phone: String
    var location: [String]
    var imageUrl: String
}

extension RestDetail {
    init() {
        self.init(
            id: 0,
            name: "",
            transactions: [],
            distance: 0,
            price: "",
            rating: 0,
            phone: "",
            location: [],
            imageUrl: ""
        )
    }
}

extension RestDetail: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        rating <- map["rating"]
        phone <- map["phone"]
        location <- map["location"]
        transactions <- map["transactions"]
        distance <- map["distance"]
        imageUrl <- map["image_url"]
    }
}
