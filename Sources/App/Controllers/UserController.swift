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
        let userRoutes = routes.grouped("user")
        
        userRoutes.post("create", use: create)
        userRoutes.post("login", use: login)
        userRoutes.post("update", use: update)
        userRoutes.post("update-password", use: updatePassword)
    }

    @Sendable
    func create(req: Request) async throws -> UserAuthResponse {
        let createUserRequest = try req.content.decode(UserAuthRequest.self)

        let existingUser = try await User.query(on: req.db)
            .filter(\.$email == createUserRequest.email)
            .with(\.$activityLevel)
            .with(\.$sexe)
            .first()

        guard existingUser == nil else {
            throw Abort(.badRequest, reason: ErrorMessages.User.emailAlreadyExists)
        }

        let passwordHash = try Bcrypt.hash(createUserRequest.password)
        
        let user = User(
            email: createUserRequest.email,
            passwordHash: passwordHash
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
            .with(\.$activityLevel)
            .with(\.$sexe)
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
    
    @Sendable
    func update(req: Request) async throws -> UserDTO {
        let payload = try req.auth.require(Payload.self)
        let userId = payload.userId

        guard let existingUser = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé")
        }

        let updateUserRequest = try req.content.decode(UserDTO.self)

        let updatedUser = try await updateUserRequest.toModel(req: req, existingUser: existingUser)

        try await updatedUser.update(on: req.db)
        
        try await updatedUser.$activityLevel.load(on: req.db)
        try await updatedUser.$sexe.load(on: req.db)

        return updatedUser.toDTO()
    }
    
    @Sendable
    func updatePassword(req: Request) async throws -> EmptyBody {
        let updatePasswordDTO = try req.content.decode(UpdatePasswordDTO.self)
        
        let payload = try req.auth.require(Payload.self)

        let userId = payload.userId

        guard let user = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound, reason: ErrorMessages.User.notFound)
        }

        guard try Bcrypt.verify(updatePasswordDTO.oldPassword, created: user.passwordHash) else {
            throw Abort(.unauthorized, reason: ErrorMessages.User.invalidOldPassword)
        }

        guard updatePasswordDTO.newPassword == updatePasswordDTO.confirmPassword else {
            throw Abort(.badRequest, reason: ErrorMessages.User.passwordsDoNotMatch)
        }

        guard updatePasswordDTO.newPassword.count >= 4 else {
            throw Abort(.badRequest, reason: ErrorMessages.User.passwordTooShort)
        }

        user.passwordHash = try Bcrypt.hash(updatePasswordDTO.newPassword)
        try await user.save(on: req.db)
        
        return EmptyBody()
    }
}

extension Request {
    func generateToken(for user: User) async throws -> String {
        let payload = Payload(
            expiration: .init(value: .distantFuture),
            userId: try user.requireID()
        )
        return try await self.jwt.sign(payload)
    }
}
