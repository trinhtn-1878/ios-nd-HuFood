//
//  ReviewsRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class ReviewsRequest: BaseRequest {
    
    required init(id: String) {
        super.init(url: Urls.getRestDetail + id + "/reviews", requestType: .get)
    }
}
