//
//  GoalType.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

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

    @Parent(key: "goal_type_category_id")
    var category: GoalTypeCategory

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        description: String,
        order: Int,
        categoryID: UUID
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.order = order
        self.$category.id = categoryID
    }
}

extension GoalType {
    func toDTO() -> GoalTypeDTO {
        guard let category = self.$category.value else {
            fatalError("La catégorie n'est pas chargée pour le GoalType")
        }
        
        return GoalTypeDTO(
            id: self.id!,
            name: self.name,
            description: self.description,
            order: self.order,
            categoryName: category.name
        )
    }
}
