//
//  UserController.swift
//  ZakFit_back
//
//  Created by Aurélien on 10/12/2024.
//

import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("users")
        
        usersRoutes.post("create", use: createUser)
        usersRoutes.post("login", use: login)
    }

    @Sendable
    func createUser(req: Request) async throws -> UserAuthResponse {
        let createUserRequest = try req.content.decode(UserAuthRequest.self)

        let existingUser = try await User.query(on: req.db)
            .filter(\.$email == createUserRequest.email)
            .first()

        guard existingUser == nil else {
            throw Abort(.badRequest, reason: ErrorMessages.User.emailAlreadyExists)
        }

        let passwordHash = try Bcrypt.hash(createUserRequest.password)
        
        let user = User(
            firstName: nil,
            lastName: nil,
            email: createUserRequest.email,
            passwordHash: passwordHash,
            dateOfBirth: nil,
            height: nil,
            weight: nil,
            genderID: nil,
            userActivityLevelID: nil
        )
        
        try await user.save(on: req.db)

        let token = try await req.generateToken(for: user)
        
        let userDTO = user.toDTO()
        
        return UserAuthResponse(user: userDTO, token: token)
    }

    @Sendable
    func login(req: Request) async throws -> UserAuthResponse {
        let loginRequest = try req.content.decode(UserAuthRequest.self)

        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: ErrorMessages.User.invalidCredentials)
        }

        guard try Bcrypt.verify(loginRequest.password, created: user.passwordHash) else {
            throw Abort(.unauthorized, reason: ErrorMessages.User.invalidCredentials)
        }

        let token = try await req.generateToken(for: user)

        let userDTO = user.toDTO()

        return UserAuthResponse(user: userDTO, token: token)
    }
}

extension Request {
    func generateToken(for user: User) async throws -> String {
        let payload = Payload(
//            expiration: .init(value: .distantFuture),
            expiration: .init(value: Date().addingTimeInterval(30)),
            userId: try user.requireID()
        )
        return try await self.jwt.sign(payload)
    }
}
