//
//  GoalStatus.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

final class GoalStatus: Model, @unchecked Sendable {
    static let schema = "goal_status"

    @ID(custom: "goal_status_id")
    var id: UUID?

    @Field(key: "goal_status_name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
