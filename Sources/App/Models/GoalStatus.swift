//
//  GoalStatus.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class GoalStatus: Model, @unchecked Sendable {
    static let schema = "goal_status"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "goal_status_name")
    var name: String

    @Field(key: "goal_status_order")
    var order: Int

    @Children(for: \.$goalStatus)
    var goals: [Goal]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
