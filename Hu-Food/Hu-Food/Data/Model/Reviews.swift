//
//  Reviews.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct Reviews {
    var id: Int
    var text: String
    var rating: String
    var user: [String]
}

extension Reviews {
    init() {
        self.init(
            id: 0,
            text: "",
            rating: "",
            user: []
        )
    }
}

extension Reviews: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        text <- map["text"]
        rating <- map["rating"]
        user <- map["user"]
    }
}
