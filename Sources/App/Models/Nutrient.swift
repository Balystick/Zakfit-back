//
//  Nutrient.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Nutrient: Model, Content, @unchecked Sendable {
    static let schema = "nutrient"

    @ID(custom: "nutrient_id")
    var id: UUID?

    @Field(key: "nutrient_name")
    var name: String

    @Field(key: "nutrient_description")
    var description: String

    @Field(key: "nutrient_recommended_daily_value")
    var recommendedDailyValue: String?

    @Parent(key: "nutrient_unit_id")
    var unit: NutrientUnit

    @Children(for: \.$nutrient)
    var foodNutrients: [FoodNutrient]

    init() {}

    init(id: UUID? = nil, name: String, description: String, recommendedDailyValue: String?, unitID: UUID) {
        self.id = id
        self.name = name
        self.description = description
        self.recommendedDailyValue = recommendedDailyValue
        self.$unit.id = unitID
    }
}
