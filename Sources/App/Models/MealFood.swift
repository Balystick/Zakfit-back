//
//  MealFood.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class MealFood: Model, Content, @unchecked Sendable {
    static let schema = "meal_food"

    @ID(custom: "meal_food_id")
    var id: UUID?

    @Field(key: "meal_food_quantity")
    var quantity: Decimal

    @Field(key: "meal_food_calories")
    var calories: Decimal

    @Field(key: "meal_food_proteins")
    var proteins: Decimal

    @Field(key: "meal_food_carbs")
    var carbs: Decimal

    @Field(key: "meal_food_fats")
    var fats: Decimal

    @Parent(key: "meal_id")
    var meal: Meal

    @Parent(key: "food_id")
    var food: Food

    init() {}

    init(id: UUID? = nil, quantity: Decimal, calories: Decimal, proteins: Decimal, carbs: Decimal, fats: Decimal, mealID: UUID, foodID: UUID) {
        self.id = id
        self.quantity = quantity
        self.calories = calories
        self.proteins = proteins
        self.carbs = carbs
        self.fats = fats
        self.$meal.id = mealID
        self.$food.id = foodID
    }
}
