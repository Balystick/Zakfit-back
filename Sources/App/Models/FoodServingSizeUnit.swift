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

    @ID(key: .id)
    var id: UUID?

    @Field(key: "food_serving_size_unit_name")
    var name: String

    @Field(key: "food_serving_size_unit_order")
    var order: Int

    @Children(for: \.$servingSizeUnit)
    var foods: [Food]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
