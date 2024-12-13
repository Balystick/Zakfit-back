//
//  Goal.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Goal: Model, Content, @unchecked Sendable {
    static let schema = "goal"

    @ID(custom: "goal_id")
    var id: UUID?

    @Field(key: "goal_target_value")
    var targetValue: Float

    @Field(key: "goal_start_date")
    var startDate: Date

    @Field(key: "goal_end_date")
    var endDate: Date?

    @Field(key: "goal_priority")
    var priority: Int

    @Field(key: "goal_description")
    var description: String

    @Parent(key: "goal_type_id")
    var goalType: GoalType

    @Parent(key: "goal_status_id")
    var goalStatus: GoalStatus

    init() {}

    init(id: UUID? = nil, targetValue: Float, startDate: Date, endDate: Date?, priority: Int, description: String, goalTypeID: UUID, goalStatusID: UUID) {
        self.id = id
        self.targetValue = targetValue
        self.startDate = startDate
        self.endDate = endDate
        self.priority = priority
        self.description = description
        self.$goalType.id = goalTypeID
        self.$goalStatus.id = goalStatusID
    }
}
