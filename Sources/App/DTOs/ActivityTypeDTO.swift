//
//  ActivityTypeDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor

struct ActivityTypeDTO: Content {
    let id: UUID
    let name: String
    let description: String?
    let caloriesPerMinute: Double
    let isCustom: Bool
}
