//
//  FoodRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//
import Foundation

final class FoodRequest: BaseRequest {
    
    required init(location: String) {
        let parameters: [String: Any]  = [
            "location": location
        ]
        super.init(url: Urls.getRestSearchList, requestType: .get, parameters: parameters)
    }
}
