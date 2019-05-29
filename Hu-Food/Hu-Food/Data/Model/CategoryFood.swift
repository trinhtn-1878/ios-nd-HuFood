//
//  Categories.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct CategoryFood {
    var alias: String
    var title: String
}

extension CategoryFood {
    init() {
        self.init(
            alias: "",
            title: ""
        )
    }
}

extension CategoryFood: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        alias <- map["alias"]
        title <- map["title"]
    }
}
