//
//  ErrorMessages.swift
//  ZakFit_back
//
//  Created by Aurélien on 11/12/2024.
//

struct ErrorMessages {
    struct User {
        static let emailAlreadyExists = "An account with this email already exists."
        static let invalidCredentials = "Invalid email or password."
        static let notFound = "User not found."
        static let invalidOldPassword = "Old password is incorrect."
        static let passwordsDoNotMatch = "Passwords do not match."
        static let passwordTooShort = "Password must be at least 4 characters long."
        
    }
    
    struct Auth {
        static let authenticationRequired = "Authentication required."
    }
}
