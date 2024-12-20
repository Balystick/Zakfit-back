//
//  UserWeightDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 16/12/2024.
//

import Vapor

struct UserWeightDTO: Content {
    let id: UUID
    let dateTime: String
    let weightValue: Double
}
