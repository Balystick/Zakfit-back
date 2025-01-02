//
//  MealDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 30/12/2024.
//

import Vapor

struct MealDTO: Content {
    let id: UUID
    let dateTime: String
    let totalCalories: Double
    let totalFats: Double
    let totalProteins: Double
    let totalCarbs: Double
    let mealTypeName: String
}

