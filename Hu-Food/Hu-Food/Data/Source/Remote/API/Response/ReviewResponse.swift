//
//  ReviewResponse.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

final class ReviewResponse: Mappable {
    
    var reviews = [Reviews]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        reviews <- map["reviews"]
    }
}
