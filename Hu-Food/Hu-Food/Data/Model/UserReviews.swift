//
//  UserReviews.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/31/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct UserReviews {
    var imageUrl: String
    var name: String
}

extension UserReviews {
    init() {
        self.init(
            imageUrl: "",
            name: ""
        )
    }
}

extension UserReviews: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["image_url"]
        name <- map["name"]
    }
}
