//
//  UpdatePasswordDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 21/12/2024.
//

import Vapor

struct UpdatePasswordDTO: Content {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String
}
