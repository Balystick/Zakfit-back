//
//  Diet.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Diet: Model, Content, @unchecked Sendable {
    static let schema = "diet"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "diet_name")
    var name: String

    @Field(key: "diet_description")
    var description: String

    @Field(key: "is_custom")
    var isCustom: Bool

    @Children(for: \.$diet)
    var rules: [DietRule]

    init() {}

    init(id: UUID? = nil, name: String, description: String, isCustom: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.isCustom = isCustom
    }
}
