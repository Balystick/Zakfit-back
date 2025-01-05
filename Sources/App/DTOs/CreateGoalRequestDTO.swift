//
//  CreateGoalRequestDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

struct CreateGoalRequestDTO: Content {
    let goalTypeId: UUID
    let goalStatus: String
    let goalUnit: String?
    let relatedActivityTypeId: UUID?
    let relatedNutrientId: UUID?
    let targetValue: Double
    let minValue: Double?
    let maxValue: Double?
    let frequency: Int?
    let startDate: String
    let endDate: String?
    let priority: Int
    let description: String?
}

extension CreateGoalRequestDTO {
    func toModel(req: Request) async throws -> Goal {
        let payload = try req.auth.require(Payload.self)
        let userID = payload.userId

        let isoFormatter = ISO8601DateFormatter()
        guard let startDate = isoFormatter.date(from: self.startDate) else {
            throw Abort(.badRequest, reason: "Invalid start date format: \(self.startDate)")
        }
        let endDate = self.endDate.flatMap { isoFormatter.date(from: $0) }

        guard endDate == nil || startDate <= endDate! else {
            throw Abort(.badRequest, reason: "Start date must be earlier than end date.")
        }

        let targetValueDecimal = Decimal(self.targetValue)
        let minValueDecimal = self.minValue.map { Decimal($0) }
        let maxValueDecimal = self.maxValue.map { Decimal($0) }

        let goalStatusID = try await getGoalStatusId(req: req, status: self.goalStatus)

        let goalUnitID = try await getGoalUnitId(req: req, unitName: self.goalUnit)

        let goal = Goal(
            userID: userID,
            goalTypeID: self.goalTypeId,
            goalStatusID: goalStatusID,
            goalUnitID: goalUnitID,
            relatedActivityTypeID: self.relatedActivityTypeId,
            relatedNutrientID: self.relatedNutrientId,
            targetValue: targetValueDecimal,
            minValue: minValueDecimal,
            maxValue: maxValueDecimal,
            frequency: self.frequency,
            startDate: startDate,
            endDate: endDate,
            priority: self.priority,
            description: self.description
        )

        return goal
    }

    private func getGoalStatusId(req: Request, status: String) async throws -> UUID {
        guard let goalStatus = try await GoalStatus.query(on: req.db)
            .filter(\.$name == status)
            .first()
        else {
            throw Abort(.badRequest, reason: "Invalid goal status: \(status)")
        }
        return try goalStatus.requireID()
    }
    
    private func getGoalUnitId(req: Request, unitName: String?) async throws -> UUID? {
        guard let unitName = unitName else {
            return nil
        }

        guard let goalUnit = try await GoalUnit.query(on: req.db)
            .filter(\.$name == unitName)
            .first()
        else {
            throw Abort(.badRequest, reason: "Invalid goal unit: \(unitName)")
        }
        return try goalUnit.requireID()
    }
}
