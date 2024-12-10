//
//  AuthResponse.swift
//  ZakFit_back
//
//  Created by Aurélien on 10/12/2024.
//

import Vapor

struct UserAuthResponse: Content {
    let user: UserDTO
    let token: String
}
