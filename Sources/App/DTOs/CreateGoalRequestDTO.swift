//
//  CreateGoalRequestDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor

struct CreateGoalRequestDTO: Content {
    let goalTypeId: UUID
    let goalStatusId: UUID
    let goalUnitId: UUID?
    let relatedActivityTypeId: UUID?
    let relatedNutrientId: UUID?
    let targetValue: Double
    let minValue: Double?
    let maxValue: Double?
    let frequency: Int?
    let startDate: Date
    let endDate: Date?
    let priority: Int
    let description: String?
}

extension CreateGoalRequestDTO {
    func toModel(req: Request) async throws -> Goal {
        let payload = try req.auth.require(Payload.self)
        let userID = payload.userId

        let targetValueDecimal = Decimal(self.targetValue)
        let minValueDecimal = self.minValue.map { Decimal($0) }
        let maxValueDecimal = self.maxValue.map { Decimal($0) }

        guard self.startDate <= (self.endDate ?? Date.distantFuture) else {
            throw Abort(.badRequest, reason: "Start date must be earlier than end date.")
        }

        let goal = Goal(
            userID: userID,
            goalTypeID: self.goalTypeId,
            goalStatusID: self.goalStatusId,
            goalUnitID: self.goalUnitId,
            relatedActivityTypeID: self.relatedActivityTypeId,
            relatedNutrientID: self.relatedNutrientId,
            targetValue: targetValueDecimal,
            minValue: minValueDecimal,
            maxValue: maxValueDecimal,
            frequency: self.frequency,
            startDate: self.startDate,
            endDate: self.endDate,
            priority: self.priority,
            description: self.description
        )

        return goal
    }
}
