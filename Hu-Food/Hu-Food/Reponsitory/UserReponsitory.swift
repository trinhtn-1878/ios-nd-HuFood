//
//  UserReponsitory.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/27/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase
import IHProgressHUD

protocol UserRepositoryType {
    func signIn(email: String, password: String, completion: @escaping(AuthDataResult) -> Void)
    func register(email: String, password: String, name: String, completion: @escaping(AuthDataResult) -> Void)
    func signOut(completion: @escaping(FirebaseResult) -> Void)
    func getCurrentUserName(completion: @escaping(String) -> Void)
    func getCurrentUser() -> User?
}

final class UserRepository: UserRepositoryType {
    static let shared = UserRepository()
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult) -> Void) {
        IHProgressHUD.show()
        DispatchQueue.global(qos: .default).async {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard let result = result else {
                    self.errorHandleShow(error: BaseError.authFailure(error: error))
                    IHProgressHUD.dismiss()
                    return
                }
                completion(result)
                IHProgressHUD.dismiss()
            }
        }
    }
    
    func register(email: String, password: String, name: String, completion: @escaping (AuthDataResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.errorHandleShow(error: BaseError.authFailure(error: error))
                return
            }
            guard let uid = result?.user.uid else {
                return
            }
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, _) in
                guard let result = result else {
                    self.errorHandleShow(error: BaseError.authFailure(error: err))
                    return
                }
                completion(result)
            })
        }
    }
    
    func signOut(completion: @escaping (FirebaseResult) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success)
        } catch {
            completion(.failure(error: BaseError.authFailure(error: error)))
            IHProgressHUD.dismiss()
        }
    }
    
    func getCurrentUserName(completion: @escaping (String) -> Void) {
        let ref = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            completion(name)
        }
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject], completion: @escaping(Error?) -> Void) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, _) in
            if let err = err {
                self.errorHandleShow(error: BaseError.authFailure(error: err))
                return
            }
        })
    }
    
    func errorHandleShow(error: BaseError) {
        if let window: UIWindow = UIApplication.shared.keyWindow {
            window.rootViewController?.showError(message: error.errorMessage)
        }
    }
}

