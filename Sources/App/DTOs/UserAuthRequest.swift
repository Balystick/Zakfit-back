//
//  LoginRequest.swift
//  ZakFit_back
//
//  Created by Aurélien on 10/12/2024.
//

import Vapor

struct UserAuthRequest: Content {
    let email: String
    let password: String
}
