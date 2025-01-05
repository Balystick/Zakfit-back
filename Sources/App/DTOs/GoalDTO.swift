//
//  GoalDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

struct GoalDTO: Content {
    let id: UUID
    let goalType: GoalTypeDTO
    let goalStatus: String
    let goalUnit: String?
    let relatedActivityType: ActivityTypeDTO?
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

extension GoalDTO {
    func toModel(req: Request) async throws -> Goal {
        let payload = try req.auth.require(Payload.self)
        let userID = payload.userId

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let startDate = dateFormatter.date(from: self.startDate) else {
            throw Abort(.badRequest, reason: "Invalid start date format.")
        }
        let endDate = self.endDate.flatMap { dateFormatter.date(from: $0) }

        let targetValueDecimal = Decimal(self.targetValue)
        let minValueDecimal = self.minValue.map { Decimal($0) }
        let maxValueDecimal = self.maxValue.map { Decimal($0) }

        guard let goalStatus = try await GoalStatus.query(on: req.db)
            .filter("goal_status_name", .equal, self.goalStatus)
            .first()
        else {
            throw Abort(.badRequest, reason: "Invalid goal status: \(self.goalStatus)")
        }
        
        let goalUnitID = try await getGoalUnitId(req: req, unitName: self.goalUnit)


        let goal = Goal(
            userID: userID,
            goalTypeID: self.goalType.id,
            goalStatusID: try goalStatus.requireID(),
            goalUnitID: goalUnitID,
            relatedActivityTypeID: self.relatedActivityType?.id,
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
