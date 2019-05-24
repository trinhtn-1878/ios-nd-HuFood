//
//  FoodRequest.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    
    var errorMessage: String? {
        switch self {
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
}
