//
//  GoalTypeDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor

struct GoalTypeDTO: Content {
    let id: UUID
    let name: String
    let description: String
    let order: Int
    let categoryName: String
}
