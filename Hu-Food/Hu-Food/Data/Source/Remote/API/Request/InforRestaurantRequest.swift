//
//  InforRestaurantRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Foundation

final class InforRestaurantRequest: BaseRequest {
    
    required init(id: String) {
        super.init(url: Urls.getRestDetail + id, requestType: .get)
    }
}
