//
//  UserWeight.swift
//  ZakFit_back
//
//  Created by Aurélien on 12/12/2024.
//

import Fluent
import Vapor

final class UserWeight: Model, Content, @unchecked Sendable {
    static let schema = "user_weight"
    
    @ID(custom: "user_weight_id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "weight_date")
    var date: Date
    
    @Field(key: "weight_value")
    var value: Float

    init() {}

    init(id: UUID? = nil, userID: UUID, date: Date, value: Float) {
        self.id = id
        self.$user.id = userID
        self.date = date
        self.value = value
    }
}
