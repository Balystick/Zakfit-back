//
//  User.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "user"
    
    @ID(custom: "user_id")
    var id: UUID?
    
    @Field(key: "user_first_name")
    var firstName: String?
    
    @Field(key: "user_last_name")
    var lastName: String?
    
    @Field(key: "user_email")
    var email: String
    
    @Field(key: "user_password_hash")
    var passwordHash: String
    
    @Field(key: "user_date_of_birth")
    var dateOfBirth: Date?
    
    @Field(key: "user_height")
    var height: Decimal?
    
    @OptionalParent(key: "user_sexe_id")
    var sexe: Sexe?
    
    @OptionalParent(key: "user_activity_level_id")
    var activityLevel: ActivityLevel?
    
    @Children(for: \.$user)
    var weights: [UserWeight]
    
    init() {}
    
    init(
        id: UUID? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String,
        passwordHash: String,
        dateOfBirth: Date? = nil,
        height: Decimal? = nil,
        sexeId: UUID? = nil,
        activityLevelId: UUID? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.$sexe.id = sexeId
        self.$activityLevel.id = activityLevelId
    }
}

extension User {
    convenience init(email: String, passwordHash: String) {
        self.init()
        self.email = email
        self.passwordHash = passwordHash
    }
    
    func toDTO() -> UserDTO {
        let isoFormatter = ISO8601DateFormatter()
        let birthDateString = self.dateOfBirth.map { isoFormatter.string(from: $0) } ?? ""
        
        return UserDTO(
            firstName: self.firstName ?? "",
            lastName: self.lastName ?? "",
            email: self.email,
            dateOfBirth: birthDateString,
            height: self.height.map { NSDecimalNumber(decimal: $0).doubleValue } ?? 0.0,
            sexe: self.sexe?.name ?? "",
            activityLevel: self.activityLevel?.name ?? ""
        )
    }
}
