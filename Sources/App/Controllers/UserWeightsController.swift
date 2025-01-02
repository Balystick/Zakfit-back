//
//  UserWeightController.swift
//  ZakFit_back
//
//  Created by Aurélien on 16/12/2024.
//

import Vapor
import Fluent

struct UserWeightsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userWeightsRoutes = routes.grouped("user-weights")
        userWeightsRoutes.get(use: getAll)
        userWeightsRoutes.get("last", use: getLast)
        userWeightsRoutes.get("period", use: getByPeriod)
        userWeightsRoutes.post(use: create)
        userWeightsRoutes.group(":userWeightID") { weight in
            weight.put(use: update)
            weight.delete(use: delete)
        }
    }
    
    @Sendable
    func getAll(req: Request) throws -> EventLoopFuture<[UserWeightDTO]> {
        let payload = try req.auth.require(Payload.self)

        return UserWeight.query(on: req.db)
            .filter(\.$user.$id == payload.userId)
            .all()
            .map { weights in
                weights.map { $0.toDTO() }
            }
    }
    
    @Sendable
    func getLast(req: Request) throws -> EventLoopFuture<UserWeightDTO> {
        let payload = try req.auth.require(Payload.self)
        
        return UserWeight.query(on: req.db)
            .filter(\.$user.$id == payload.userId)
            .sort(\.$dateTime, .descending)
            .first()
            .unwrap(or: Abort(.notFound, reason: "Aucun poids trouvé pour cet utilisateur"))
            .map { userWeight in
                return userWeight.toDTO()
            }
    }
    
    @Sendable
    func getByPeriod(req: Request) throws -> EventLoopFuture<[UserWeightDTO]> {
        let payload = try req.auth.require(Payload.self)
        
        guard let startDateString = req.query[String.self, at: "startDate"],
              let endDateString = req.query[String.self, at: "endDate"],
              let startDate = ISO8601DateFormatter().date(from: startDateString),
              let endDate = ISO8601DateFormatter().date(from: endDateString)
        else {
            throw Abort(.badRequest, reason: "Les paramètres 'startDate' et 'endDate' sont requis au format ISO8601.")
        }
        
        return UserWeight.query(on: req.db)
            .filter(\.$user.$id == payload.userId)
            .filter(\.$dateTime >= startDate)
            .filter(\.$dateTime <= endDate)
            .sort(\.$dateTime, .ascending)
            .all()
            .map { weights in
                return weights.map { $0.toDTO() }
            }
    }
    
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<UserWeightDTO> {
        let userID = try req.auth.require(Payload.self).userId
        let newWeightDTO = try req.content.decode(UserWeightRequestDTO.self)
        let weightValue = Decimal(newWeightDTO.weightValue)
        guard newWeightDTO.weightValue > 0 else {
            throw Abort(.badRequest, reason: "Le poids doit être supérieur à zéro.")
        }
        let isoFormatter = ISO8601DateFormatter()
        guard let dateTime = isoFormatter.date(from: newWeightDTO.dateTime) else {
            throw Abort(.badRequest, reason: "La date fournie n'est pas valide.")
        }
        
        let userWeight = UserWeight(
            dateTime: dateTime,
            weightValue: weightValue,
            userID: userID
        )
        
        return userWeight.create(on: req.db).map { userWeight.toDTO() }
    }
    
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<UserWeightDTO> {
        let updatedWeightDTO = try req.content.decode(UserWeightRequestDTO.self)
        
        guard let weightID = req.parameters.get("userWeightID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide.")
        }

        let isoFormatter = ISO8601DateFormatter()
        guard let dateTime = isoFormatter.date(from: updatedWeightDTO.dateTime) else {
            throw Abort(.badRequest, reason: "La date fournie n'est pas valide.")
        }
        
        guard updatedWeightDTO.weightValue > 0 else {
            throw Abort(.badRequest, reason: "Le poids doit être supérieur à zéro.")
        }
        guard dateTime <= Date() else {
            throw Abort(.badRequest, reason: "La date ne peut pas être dans le futur.")
        }

        return UserWeight.find(weightID, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "Poids non trouvé."))
            .flatMap { existingWeight in
                existingWeight.dateTime = dateTime
                existingWeight.weightValue = Decimal(updatedWeightDTO.weightValue)
                
                return existingWeight.update(on: req.db).map {
                    existingWeight.toDTO()
                }
            }
    }
    
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let weightID = req.parameters.get("userWeightID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "ID invalide.")
        }
        
        return UserWeight.find(weightID, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "Poids non trouvé."))
            .flatMap { existingWeight in
                return existingWeight.delete(on: req.db)
            }
            .transform(to: .noContent)
    }
}
