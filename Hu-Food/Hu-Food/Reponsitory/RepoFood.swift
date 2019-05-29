//
//  RepoFood.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Foundation

protocol RepoFood {
    func fetchNearFood(location: String, completion: @escaping (BaseResult<FoodResponse>) -> Void)
    func fetchInforRestaurant(id: String, completion: @escaping (BaseResult<RestDetail>) -> Void)
    func fetchReviews(id: String, completion: @escaping (BaseResult<ReviewResponse>) -> Void )
}

final class RepoFoodIplm: RepoFood {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func fetchNearFood(location: String, completion: @escaping (BaseResult<FoodResponse>) -> Void) {
        let input = FoodRequest(location: location)
        api?.request(input: input) { (object: FoodResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func fetchInforRestaurant(id: String, completion: @escaping (BaseResult<RestDetail>) -> Void) {
        let input = InforRestaurantRequest(id: id)
        api?.request(input: input) { (object: RestDetail?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func fetchReviews(id: String, completion: @escaping (BaseResult<ReviewResponse>) -> Void) {
        let input = ReviewsRequest(id: id)
        api?.request(input: input) { (object: ReviewResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
