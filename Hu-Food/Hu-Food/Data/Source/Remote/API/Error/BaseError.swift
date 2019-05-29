//
//  FoodRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    case confirmPasswordInvalid
    case authFailure(error: Error?)
    
    var errorMessage: String? {
        switch self {
        case .confirmPasswordInvalid:
            return "Confirm Password is wrong"
        case .authFailure(let error):
            if let error = error {
                if let errorcode = AuthErrorCode(rawValue: error._code) {
                    return getMessage(errorCode: errorcode)
                }
            }
            return "Error"
        case .networkError:
            return "Network Error"
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return "Error"
        default:
            return "Unexpected Error"
        }
    }
    
    private func getHttpErrorMessage(httpCode: Int) -> String? {
        if httpCode >= 300 && httpCode <= 308 {
            // Redirection
            return "It was transferred to a different URL. I'm sorry for causing you trouble"
        }
        if httpCode >= 400 && httpCode <= 451 {
            // Client error
            return "An error occurred on the application side. Please try again later!"
        }
        if httpCode >= 500 && httpCode <= 511 {
            // Server error
            return "A server error occurred. Please try again later!"
        }
        // Unofficial error
        return "An error occurred. Please try again later!"
    }

    private func getMessage(errorCode: AuthErrorCode) -> String {
        switch errorCode {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again"
        default:
            return "Unknown error occurred"
        }
    }
}
