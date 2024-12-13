//
//  Untitled.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class MealType: Model, @unchecked Sendable {
    static let schema = "meal_type"

    @ID(custom: "meal_type_id")
    var id: UUID?

    @Field(key: "meal_type_name")
    var name: String

    @Field(key: "meal_type_order")
    var order: Int

    @Children(for: \.$mealType)
    var meals: [Meal]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
