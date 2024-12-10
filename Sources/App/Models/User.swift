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
    var height: Float?
    
    @Field(key: "user_weight")
    var weight: Float?
    
    @OptionalParent(key: "gender_id")
    var gender: Gender?
    
    @OptionalParent(key: "user_activity_level_id")
    var userActivityLevel: UserActivityLevel?
    
    init() {}
    
    init(
        id: UUID? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        email: String,
        passwordHash: String,
        dateOfBirth: Date? = nil,
        height: Float? = nil,
        weight: Float? = nil,
        genderID: UUID? = nil,
        userActivityLevelID: UUID? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.$gender.id = genderID
        self.$userActivityLevel.id = userActivityLevelID
    }
}

extension User {
    convenience init(email: String, passwordHash: String) {
        self.init()
        self.email = email
        self.passwordHash = passwordHash
    }
    
    func toDTO() -> UserDTO {
        return UserDTO(
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            dateOfBirth: self.dateOfBirth,
            height: self.height,
            weight: self.weight,
            genderID: self.$gender.id,
            userActivityLevelID: self.$userActivityLevel.id
        )
    }
}
