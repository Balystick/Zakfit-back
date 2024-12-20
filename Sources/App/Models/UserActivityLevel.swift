//
//  UserActivityLevel.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class ActivityLevel: Model, Content, @unchecked Sendable {
    static let schema = "user_activity_level"

    @ID(custom: "user_activity_level_id")
    var id: UUID?

    @Field(key: "user_activity_level_name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
    }
}
