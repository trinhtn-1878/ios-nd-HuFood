//
//  FoodRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
