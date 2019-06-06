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
    var rating: Double
    var timeCreated: String
    var url: String?
    var user: UserReviews
}

extension Reviews {
    init() {
        self.init(
            id: 0,
            text: "",
            rating: 0,
            timeCreated: "",
            url: "",
            user: UserReviews()
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
        timeCreated <- map["time_created"]
        url <- map["url"]
        user <- map["user"]
    }
}
