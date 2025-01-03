//
//  GoalUnitDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor

struct GoalUnitDTO: Content {
    let id: UUID
    let name: String
}
