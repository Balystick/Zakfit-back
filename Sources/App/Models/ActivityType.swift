//
//  ActivityType.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class ActivityType: Model, Content, @unchecked Sendable {
    static let schema = "activity_type"

    @ID(custom: "activity_type_id")
    var id: UUID?

    @Field(key: "activity_type_name")
    var name: String

    @Field(key: "activity_type_description")
    var description: String

    @Field(key: "activity_type_calories_per_minute")
    var caloriesPerMinute: Float

    init() {}

    init(id: UUID? = nil, name: String, description: String, caloriesPerMinute: Float) {
        self.id = id
        self.name = name
        self.description = description
        self.caloriesPerMinute = caloriesPerMinute
    }
}
