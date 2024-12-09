//
//  Meal.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meal"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "meal_date_time")
    var dateTime: Date

    @Field(key: "meal_total_calories")
    var totalCalories: Float

    @Field(key: "meal_total_fats")
    var totalFats: Float

    @Field(key: "meal_total_proteins")
    var totalProteins: Float

    @Field(key: "meal_total_carbs")
    var totalCarbs: Float

    @Parent(key: "meal_type_id")
    var mealType: MealType

    @Children(for: \.$meal)
    var foods: [MealFood]

    init() {}

    init(id: UUID? = nil, dateTime: Date, totalCalories: Float, totalFats: Float, totalProteins: Float, totalCarbs: Float, mealTypeID: UUID) {
        self.id = id
        self.dateTime = dateTime
        self.totalCalories = totalCalories
        self.totalFats = totalFats
        self.totalProteins = totalProteins
        self.totalCarbs = totalCarbs
        self.$mealType.id = mealTypeID
    }
}
