//
//  UserWeightRequestDTO.swift
//  ZakFit_back
//
//  Created by Aurélien on 16/12/2024.
//

import Vapor

struct UserWeightRequestDTO: Content {
    let dateTime: String
    let weightValue: Double
}
