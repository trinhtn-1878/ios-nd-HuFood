//
//  FoodRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Foundation

final class FoodRequest: BaseRequest {
    
    required init(longitude: String, latitude: String, offset: Int, term: String) {
        let parameters: [String: Any]  = [
            "latitude": latitude,
            "longitude": longitude,
            "offset": offset,
            "sort_by": "distance",
            "term": term
        ]
        super.init(url: Urls.getRestSearchList, requestType: .get, parameters: parameters)
    }
}
