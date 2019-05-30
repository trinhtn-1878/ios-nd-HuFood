//
//  RepoFood.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

protocol RepoFood {
    func fetchNearFood(longitude: String, latitude: String, offset: Int, term: String, completion: @escaping (FoodResponse) -> Void)
    func fetchInforRestaurant(id: String, completion: @escaping (RestDetail) -> Void)
    func fetchReviews(id: String, completion: @escaping (ReviewResponse) -> Void )
}

final class RepoFoodIplm: RepoFood {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func fetchNearFood(longitude: String, latitude: String, offset: Int, term: String, completion: @escaping (FoodResponse) -> Void) {
        let input = FoodRequest(longitude: longitude, latitude: latitude, offset: offset, term: term)
        api?.request(input: input) { (object: FoodResponse?, error) in
            if let object = object {
                completion(object)
            } else if let error = error {
                self.errorHandleShow(error: error)
            } else {
                self.errorHandleShow(error: nil)
            }
        }
    }
    
    func fetchInforRestaurant(id: String, completion: @escaping (RestDetail) -> Void) {
        let input = InforRestaurantRequest(id: id)
        api?.request(input: input) { (object: RestDetail?, error) in
            if let object = object {
                completion(object)
            } else if let error = error {
                self.errorHandleShow(error: error)
            }
        }
    }
    
    func fetchReviews(id: String, completion: @escaping (ReviewResponse) -> Void) {
        let input = ReviewsRequest(id: id)
        api?.request(input: input) { (object: ReviewResponse?, error) in
            if let object = object {
                completion(object)
            } else if let error = error {
                self.errorHandleShow(error: error)
            }
        }
    }
    
    func errorHandleShow(error: BaseError?) {
        if let window: UIWindow = UIApplication.shared.keyWindow {
            window.rootViewController?.showError(message: error?.errorMessage)
        }
    }
}
