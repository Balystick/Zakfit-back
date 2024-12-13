//
//  Food.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Food: Model, Content, @unchecked Sendable {
    static let schema = "food"

    @ID(custom: "food_id")
    var id: UUID?

    @Field(key: "food_name")
    var name: String

    @Field(key: "food_serving_size")
    var servingSize: Float

    @Field(key: "food_calories_per_serving")
    var caloriesPerServing: Float

    @Field(key: "food_fats_per_serving")
    var fatsPerServing: Float

    @Field(key: "food_proteins_per_serving")
    var proteinsPerServing: Float

    @Field(key: "food_carbs_per_serving")
    var carbsPerServing: Float

    @Field(key: "food_is_custom")
    var isCustom: Bool

    @Field(key: "food_description")
    var description: String?

    @Parent(key: "food_category_id")
    var category: FoodCategory

    @Parent(key: "food_serving_size_unit_id")
    var servingSizeUnit: FoodServingSizeUnit

    @Children(for: \.$food)
    var nutrients: [FoodNutrient]

    init() {}

    init(id: UUID? = nil, name: String, servingSize: Float, caloriesPerServing: Float, fatsPerServing: Float, proteinsPerServing: Float, carbsPerServing: Float, isCustom: Bool, description: String?, categoryID: UUID, servingSizeUnitID: UUID) {
        self.id = id
        self.name = name
        self.servingSize = servingSize
        self.caloriesPerServing = caloriesPerServing
        self.fatsPerServing = fatsPerServing
        self.proteinsPerServing = proteinsPerServing
        self.carbsPerServing = carbsPerServing
        self.isCustom = isCustom
        self.description = description
        self.$category.id = categoryID
        self.$servingSizeUnit.id = servingSizeUnitID
    }
}
