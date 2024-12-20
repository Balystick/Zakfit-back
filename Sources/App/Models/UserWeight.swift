//
//  UserWeight.swift
//  ZakFit_back
//
//  Created by Aurélien on 12/12/2024.
//

import Vapor
import Fluent

final class UserWeight: Model, Content, @unchecked Sendable {
    static let schema = "user_weight"

    @ID(custom: "user_weight_id")
    var id: UUID?

    @Field(key: "user_weight_date_time")
    var dateTime: Date

    @Field(key: "user_weight_value")
    var weightValue: Decimal

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(id: UUID? = nil, dateTime: Date, weightValue: Decimal, userID: UUID) {
        self.id = id
        self.dateTime = dateTime
        self.weightValue = weightValue
        self.$user.id = userID
    }
}

extension UserWeight {
    func toDTO() -> UserWeightDTO {
        let isoFormatter = ISO8601DateFormatter()
        let dateTimeString = isoFormatter.string(from: self.dateTime)

        let weightValueDouble = NSDecimalNumber(decimal: self.weightValue).doubleValue

        return UserWeightDTO(
            id: self.id!,
            dateTime: dateTimeString,
            weightValue: weightValueDouble
        )
    }
}
