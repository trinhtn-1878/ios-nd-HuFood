//
//  FoodResponse.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

final class FoodResponse: Mappable {
    var restaurants = [Restaurant]()

    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        restaurants <- map["businesses"]
    }
}
