//
//  UpdateGoalRequestDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor

struct UpdateGoalRequestDTO: Content {
    let goalTypeId: UUID?
    let goalStatusId: UUID?
    let goalUnitId: UUID?
    let relatedActivityTypeId: UUID?
    let relatedNutrientId: UUID?
    let targetValue: Double?
    let minValue: Double?
    let maxValue: Double?
    let frequency: Int?
    let startDate: String?
    let endDate: String?
    let priority: Int?
    let description: String?
}

extension UpdateGoalRequestDTO {
    func toModel(existingGoal: Goal, req: Request) async throws -> Goal {
        let payload = try req.auth.require(Payload.self)
        let userID = payload.userId

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let startDateString = self.startDate,
           let endDateString = self.endDate,
           let startDate = isoFormatter.date(from: startDateString),
           let endDate = isoFormatter.date(from: endDateString),
           startDate > endDate {
            throw Abort(.badRequest, reason: "La date de début doit précéder celle de fin.")
        }

        if let startDateString = self.startDate, let startDate = isoFormatter.date(from: startDateString) {
            existingGoal.startDate = startDate
        }

        if let endDateString = self.endDate, let endDate = isoFormatter.date(from: endDateString) {
            existingGoal.endDate = endDate
        }

        if let goalTypeId = self.goalTypeId {
            existingGoal.$goalType.id = goalTypeId
        }
        
        if let goalStatusId = self.goalStatusId {
            existingGoal.$goalStatus.id = goalStatusId
        }

        if let goalUnitId = self.goalUnitId {
            existingGoal.$goalUnit.id = goalUnitId
        }

        if let relatedActivityTypeId = self.relatedActivityTypeId {
            existingGoal.$relatedActivityType.id = relatedActivityTypeId
        }

        if let relatedNutrientId = self.relatedNutrientId {
            existingGoal.$relatedNutrient.id = relatedNutrientId
        }

        if let targetValue = self.targetValue {
            existingGoal.targetValue = Decimal(targetValue)
        }

        if let minValue = self.minValue {
            existingGoal.minValue = Decimal(minValue)
        }

        if let maxValue = self.maxValue {
            existingGoal.maxValue = Decimal(maxValue)
        }

        if let frequency = self.frequency {
            existingGoal.frequency = frequency
        }

        if let priority = self.priority {
            existingGoal.priority = priority
        }

        if let description = self.description {
            existingGoal.description = description
        }

        guard existingGoal.$user.id == userID else {
            throw Abort(.forbidden, reason: "Vous n'avez pas la permission de modifier cet objectif.")
        }

        return existingGoal
    }
}
