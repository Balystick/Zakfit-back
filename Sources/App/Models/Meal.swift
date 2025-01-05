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

    @ID(custom: "meal_id")
    var id: UUID?

    @Field(key: "meal_date_time")
    var dateTime: Date

    @Field(key: "meal_total_calories")
    var totalCalories: Decimal

    @Field(key: "meal_total_fats")
    var totalFats: Decimal

    @Field(key: "meal_total_proteins")
    var totalProteins: Decimal

    @Field(key: "meal_total_carbs")
    var totalCarbs: Decimal

    @Parent(key: "meal_type_id")
    var mealType: MealType
    
    @Parent(key: "user_id")
    var user: User

    @Children(for: \.$meal)
    var foods: [MealFood]

    init() {}

    init(id: UUID? = nil, dateTime: Date, totalCalories: Decimal, totalFats: Decimal, totalProteins: Decimal, totalCarbs: Decimal, mealTypeID: UUID) {
        self.id = id
        self.dateTime = dateTime
        self.totalCalories = totalCalories
        self.totalFats = totalFats
        self.totalProteins = totalProteins
        self.totalCarbs = totalCarbs
        self.$mealType.id = mealTypeID
    }
}
