//
//  GoalController.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

struct GoalsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let goals = routes.grouped("goals")
        goals.post(use: create)
        goals.put(":goalID", use: update)
        goals.delete(":goalID", use: delete)
        goals.get(use: getAll)
        goals.get("types", use: getTypes)
    }
    
    @Sendable
    func getAll(req: Request) throws -> EventLoopFuture<[GoalDTO]> {
        let payload = try req.auth.require(Payload.self)

        return Goal.query(on: req.db)
            .filter(\.$user.$id == payload.userId)
            .with(\.$goalType) { $0.with(\.$category) }
            .with(\.$goalStatus)
            .with(\.$goalUnit)
            .with(\.$relatedActivityType)
            .all()
            .map { goals in
                goals.map { $0.toDTO() }
            }
    }

    @Sendable
    func create(req: Request) async throws -> GoalDTO {
        let createDTO = try req.content.decode(CreateGoalRequestDTO.self)
        
        let goal = try await createDTO.toModel(req: req)
        
        try await goal.save(on: req.db)
        
        try await goal.$goalType.load(on: req.db)
        try await goal.$goalType.value?.$category.load(on: req.db)
        try await goal.$goalStatus.load(on: req.db)
        
        if goal.$goalUnit.id != nil {
            try await goal.$goalUnit.load(on: req.db)
        }
        
        if goal.$relatedActivityType.id != nil {
            try await goal.$relatedActivityType.load(on: req.db)
        }
        
        return goal.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> GoalDTO {
        guard let goalId = req.parameters.get("goalID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Goal ID is required.")
        }
        
        guard let existingGoal = try await Goal.find(goalId, on: req.db) else {
            throw Abort(.notFound, reason: "Goal not found.")
        }
        
        let payload = try req.auth.require(Payload.self)
        guard existingGoal.$user.id == payload.userId else {
            throw Abort(.forbidden, reason: "You do not have permission to modify this goal.")
        }
        
        let updateDTO = try req.content.decode(UpdateGoalRequestDTO.self)
        
        let updatedGoal = try await updateDTO.toModel(existingGoal: existingGoal, req: req)
        
        try await updatedGoal.update(on: req.db)
        
        
        try await updatedGoal.$goalType.load(on: req.db)
        try await updatedGoal.$goalType.value?.$category.load(on: req.db)
        try await updatedGoal.$goalStatus.load(on: req.db)
        if updatedGoal.$goalUnit.id != nil {
            try await updatedGoal.$goalUnit.load(on: req.db)
        }

        if updatedGoal.$relatedActivityType.id != nil {
            try await updatedGoal.$relatedActivityType.load(on: req.db)
        }
        
        return updatedGoal.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let goal = try await Goal.find(req.parameters.get("goalID"), on: req.db) else {
            throw Abort(.notFound, reason: "Objectif non trouvé.")
        }
        try await goal.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func getTypes(req: Request) async throws -> [GoalTypeDTO] {
        let goalTypes = try await GoalType.query(on: req.db)
            .with(\.$category)
            .all()
        return goalTypes.map { $0.toDTO() }
    }
}
