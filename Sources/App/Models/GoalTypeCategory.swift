//
//  GoalTypeCategory.swift
//  ZakFit_back
//
//  Created by Aurélien on 04/01/2025.
//

import Fluent
import Vapor

final class GoalTypeCategory: Model, @unchecked Sendable {
    static let schema = "goal_type_category"

    @ID(custom: "goal_type_category_id")
    var id: UUID?

    @Field(key: "goal_type_category_name")
    var name: String
    
    @Children(for: \.$category)
    var goalTypes: [GoalType]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
