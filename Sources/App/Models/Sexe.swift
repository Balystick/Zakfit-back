//
//  Gender.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Sexe: Model, @unchecked Sendable {
    static let schema = "user_sexe"

    @ID(custom: "user_sexe_id")
    var id: UUID?

    @Field(key: "user_sexe_name")
    var name: String

    @Children(for: \.$sexe)
    var users: [User]

    init() {}

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
