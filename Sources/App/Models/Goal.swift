//
//  Goal.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

final class Goal: Model, @unchecked Sendable {
    static let schema = "goal"
    
    @ID(custom: "goal_id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "goal_type_id")
    var goalType: GoalType
    
    @Parent(key: "goal_status_id")
    var goalStatus: GoalStatus
    
    @OptionalParent(key: "goal_unit_id")
    var goalUnit: GoalUnit?
    
    @OptionalParent(key: "goal_related_activity_type_id")
    var relatedActivityType: ActivityType?
    
    @OptionalParent(key: "goal_related_nutrient_id")
    var relatedNutrient: Nutrient?
    
    @Field(key: "goal_target_value")
    var targetValue: Decimal
    
    @OptionalField(key: "goal_min_value")
    var minValue: Decimal?
    
    @OptionalField(key: "goal_max_value")
    var maxValue: Decimal?
    
    @OptionalField(key: "goal_frequency")
    var frequency: Int?
    
    @Field(key: "goal_start_date")
    var startDate: Date
    
    @OptionalField(key: "goal_end_date")
    var endDate: Date?
    
    @Field(key: "goal_priority")
    var priority: Int
    
    @OptionalField(key: "goal_description")
    var description: String?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        goalTypeID: UUID,
        goalStatusID: UUID,
        goalUnitID: UUID? = nil,
        relatedActivityTypeID: UUID? = nil,
        relatedNutrientID: UUID? = nil,
        targetValue: Decimal,
        minValue: Decimal? = nil,
        maxValue: Decimal? = nil,
        frequency: Int? = nil,
        startDate: Date,
        endDate: Date? = nil,
        priority: Int,
        description: String? = nil
    ) {
        self.id = id
        self.$user.id = userID
        self.$goalType.id = goalTypeID
        self.$goalStatus.id = goalStatusID
        self.$goalUnit.id = goalUnitID
        self.$relatedActivityType.id = relatedActivityTypeID
        self.$relatedNutrient.id = relatedNutrientID
        self.targetValue = targetValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
        self.description = description
    }
}

extension Goal {
    func toDTO() -> GoalDTO {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let startDateString = dateFormatter.string(from: self.startDate)
        let endDateString = self.endDate.map { dateFormatter.string(from: $0) }
        
        let targetVal = NSDecimalNumber(decimal: self.targetValue).doubleValue
        let minVal = self.minValue.map { NSDecimalNumber(decimal: $0).doubleValue }
        let maxVal = self.maxValue.map { NSDecimalNumber(decimal: $0).doubleValue }

        let typeDTO = self.goalType.toDTO()

        let unitDTO = self.goalUnit?.toDTO()

        let activityTypeDTO = self.relatedActivityType?.toDTO()

        return GoalDTO(
            id: self.id ?? UUID(),
            goalType: typeDTO,
            goalStatus: self.goalStatus.name,
            goalUnit: unitDTO,
            relatedActivityType: activityTypeDTO,
            relatedNutrientId: self.$relatedNutrient.id,
            targetValue: targetVal,
            minValue: minVal,
            maxValue: maxVal,
            frequency: self.frequency,
            startDate: startDateString,
            endDate: endDateString,
            priority: self.priority,
            description: self.description
        )
    }
}
