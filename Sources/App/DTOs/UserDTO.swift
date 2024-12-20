//
//  UserDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 10/12/2024.
//

import Vapor
import Fluent

struct UserDTO: Content {
    var firstName: String
    var lastName: String
    var email: String
    var dateOfBirth: String
    var height: Double
    var sexe: String
    var activityLevel: String
}
    
extension UserDTO {
    func toModel(req: Request, existingUser: User? = nil) async throws -> User {
        let user = existingUser ?? User(
            email: self.email,
            passwordHash: ""
        )
        
        user.firstName = self.firstName == "Non renseigné" ? nil : self.firstName
        user.lastName = self.lastName == "Non renseigné" ? nil : self.lastName
        user.dateOfBirth = self.dateOfBirth == "Non renseigné" ? nil : ISO8601DateFormatter().date(from: self.dateOfBirth)
        user.email = self.email
        user.height = self.height == 0.0 ? nil : Decimal(self.height)
        if self.sexe == "Non renseigné" {
            user.$sexe.id = nil
        } else if let sexe = try await Sexe.query(on: req.db)
            .filter(\.$name == self.sexe)
            .first()
        {
            user.$sexe.id = try sexe.requireID()
        } else {
            throw Abort(.notFound, reason: "Le sexe '\(self.sexe)' est introuvable.")
        }
        if self.activityLevel == "Non renseigné" {
            user.$activityLevel.id = nil
        } else if let activityLevel = try await ActivityLevel.query(on: req.db)
            .filter(\.$name == self.activityLevel)
            .first()
        {
            user.$activityLevel.id = try activityLevel.requireID()
        } else {
            throw Abort(.notFound, reason: "Le niveau d'activité '\(self.activityLevel)' est introuvable.")
        }

        return user
    }
}
