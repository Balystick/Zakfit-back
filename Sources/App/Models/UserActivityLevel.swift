//
//  UserActivityLevel.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class UserActivityLevel: Model, Content, @unchecked Sendable {
    static let schema = "user_activity_level"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_activity_level_name")
    var name: String

    @Field(key: "user_activity_level_order")
    var order: Int

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
