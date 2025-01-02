//
//  ErrorMessages.swift
//  ZakFit_back
//
//  Created by Aurélien on 11/12/2024.
//

struct ErrorMessages {
    struct User {
        static let emailAlreadyExists = "Un compte avec cet email existe déjà."
        static let invalidCredentials = "Email ou mot de passe invalide."
        static let notFound = "Aucun compte utilisateur avec cet email."
        static let invalidOldPassword = "L'ancien mot de passe est incorrect."
        static let passwordsDoNotMatch = "Les mots de passe ne correspondent pas."
        static let passwordTooShort = "Le mot de passe doit faire au moins 4 caractères."
        
    }
    
    struct Auth {
        static let authenticationRequired = "Authentification requise."
    }
}
