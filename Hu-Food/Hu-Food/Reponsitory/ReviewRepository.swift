//
//  ReviewRepository.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 6/4/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase

protocol ReviewRepositoryType {
    func pushUsersReview(restId: String,
                         text: String,
                         rate: Double,
                         date: String,
                         name: String,
                         completion: @escaping(FirebaseResult) -> Void)
    func getUserReview(restId: String,
                       limit: UInt,
                       completion: @escaping([Reviews]) -> Void)
}

final class ReviewRepository: ReviewRepositoryType {
    static let shared = ReviewRepository()
    
    func pushUsersReview(restId: String,
                         text: String,
                         rate: Double,
                         date: String,
                         name: String,
                         completion: @escaping (FirebaseResult) -> Void) {
        if text.isEmpty { completion(.failure(error: BaseError.reviewTextEmpty)) }
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child("Restaurants").child(restId).child(date)
        let values = ["text": text, "rate": rate, "date": date, "name": name] as [String: Any]
        usersReference.updateChildValues(values) { (error, _) in
            if let error = error {
                completion(.failure(error: BaseError.authFailure(error: error)))
            }
        }
        completion(.success)
    }
    
    func getUserReview(restId: String, limit: UInt, completion: @escaping ([Reviews]) -> Void) {
        let ref = Database.database().reference()
        ref.child("users")
            .child("Restaurants")
            .child(restId)
            .queryLimited(toFirst: limit)
            .observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let keyValues = Array(value?.allValues ?? Array())
            var allReview: [Reviews] = []
            for values in keyValues {
                var review = Reviews()
                review.text = (values as? [String: Any])?["text"] as? String ?? ""
                review.user.name = (values as? [String: Any])?["name"] as? String ?? ""
                review.rating = (values as? [String: Any])?["rate"] as? Double ?? 0
                review.timeCreated = (values as? [String: Any])?["date"] as? String ?? ""
                allReview.append(review)
            }
            completion(allReview.sorted(by: { $0.timeCreated < $1.timeCreated }))
        }
    }
}
