//
//  UserDataResult.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/27/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase

enum FirebaseResult<T> {
    case success(T?)
    case failure(error: BaseError?)
}
