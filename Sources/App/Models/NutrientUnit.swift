//
//  NutrientUnit.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class NutrientUnit: Model, @unchecked Sendable {
    static let schema = "nutrient_unit"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "nutrient_unit_name")
    var name: String

    @Field(key: "nutrient_unit_description")
    var description: String

    @Children(for: \.$unit)
    var nutrients: [Nutrient]

    init() {}

    init(id: UUID? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}
