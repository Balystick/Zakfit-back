//
//  FoodNutrient.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class FoodNutrient: Model, Content, @unchecked Sendable {
    static let schema = "food_nutrient"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "food_nutrient_quantity")
    var quantity: Float

    @Parent(key: "food_id")
    var food: Food

    @Parent(key: "nutrient_id")
    var nutrient: Nutrient

    init() {}

    init(id: UUID? = nil, quantity: Float, foodID: UUID, nutrientID: UUID) {
        self.id = id
        self.quantity = quantity
        self.$food.id = foodID
        self.$nutrient.id = nutrientID
    }
}
