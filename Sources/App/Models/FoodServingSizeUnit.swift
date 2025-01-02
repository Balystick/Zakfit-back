//
//  FoodServingSizeUnit.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class FoodServingSizeUnit: Model, @unchecked Sendable {
    static let schema = "food_serving_size_unit"

    @ID(custom: "food_serving_size_unit_id")
    var id: UUID?

    @Field(key: "food_serving_size_unit_name")
    var name: String

    @Children(for: \.$servingSizeUnit)
    var foods: [Food]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
