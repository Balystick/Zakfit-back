//
//  Untitled.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class FoodCategory: Model, @unchecked Sendable {
    static let schema = "food_category"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "food_category_name")
    var name: String

    @Children(for: \.$category)
    var foods: [Food]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
