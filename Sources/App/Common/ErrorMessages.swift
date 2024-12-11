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
    }
    
    struct Auth {
        static let authenticationRequired = "Authentication required."
    }
}
