//
//  UserDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 10/12/2024.
//

import Vapor

struct UserDTO: Content {
    var firstName: String?
    var lastName: String?
    var email: String
    var dateOfBirth: Date?
    var height: Float?
    var weight: Float?
    var genderID: UUID?
    var userActivityLevelID: UUID?
}

