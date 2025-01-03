//
//  GoalUnit.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

final class GoalUnit: Model, @unchecked Sendable {
    static let schema = "goal_unit"

    @ID(custom: "goal_unit_id")
    var id: UUID?

    @Field(key: "goal_unit_name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension GoalUnit {
    func toDTO() -> GoalUnitDTO {
        GoalUnitDTO(
            id: self.id!,
            name: self.name
        )
    }
}
