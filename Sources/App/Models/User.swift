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

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_first_name")
    var firstName: String

    @Field(key: "user_last_name")
    var lastName: String

    @Field(key: "user_email")
    var email: String

    @Field(key: "user_password_hash")
    var passwordHash: String

    @Field(key: "user_date_of_birth")
    var dateOfBirth: Date

    @Field(key: "user_height")
    var height: Float

    @Field(key: "user_weight")
    var weight: Float

    @Parent(key: "gender_id")
    var gender: Gender

    init() {}

    init(id: UUID? = nil, firstName: String, lastName: String, email: String, passwordHash: String, dateOfBirth: Date, height: Float, weight: Float, genderID: UUID) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.dateOfBirth = dateOfBirth
        self.height = height
        self.weight = weight
        self.$gender.id = genderID
    }
}
