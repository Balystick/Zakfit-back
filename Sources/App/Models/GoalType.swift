//
//  GoalType.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class GoalType: Model, @unchecked Sendable {
    static let schema = "goal_type"

    @ID(custom: "goal_type_id")
    var id: UUID?

    @Field(key: "goal_type_name")
    var name: String

    @Field(key: "goal_type_description")
    var description: String

    @Field(key: "goal_type_order")
    var order: Int

    @Children(for: \.$goalType)
    var goals: [Goal]

    init() {}

    init(id: UUID? = nil, name: String, description: String, order: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.order = order
    }
}
