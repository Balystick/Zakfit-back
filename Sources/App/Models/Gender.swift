//
//  Gender.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Gender: Model, @unchecked Sendable {
    static let schema = "gender"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "gender_name")
    var name: String

    @Field(key: "gender_order")
    var order: Int

    @Children(for: \.$gender)
    var users: [User]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
