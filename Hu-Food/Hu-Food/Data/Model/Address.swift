//
//  Address.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

struct Address {
    var address1: String
    var address2: String
}

extension Address {
    init() {
        self.init(
            address1: "",
            address2: ""
        )
    }
}
extension Address: Mappable {
    init?(map: Map) {
        self.init()
    }
    mutating func mapping(map: Map) {
        address1 <- map["address1"]
        address2 <- map["address2"]
    }
}
