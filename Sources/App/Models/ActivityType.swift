//
//  ActivityType.swift
//  ZakFit_back
//
//  Created by Aurélien on 02/01/2025.
//

import Vapor
import Fluent

final class ActivityType: Model, @unchecked Sendable {
    static let schema = "activity_type"

    @ID(custom: "activity_type_id")
    var id: UUID?

    @Field(key: "activity_type_name")
    var name: String

    @OptionalField(key: "activity_type_description")
    var description: String?

    @Field(key: "activity_type_calories_per_minute")
    var caloriesPerMinute: Decimal

    @Field(key: "activity_type_is_custom")
    var isCustom: Bool

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        description: String? = nil,
        caloriesPerMinute: Decimal,
        isCustom: Bool
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.caloriesPerMinute = caloriesPerMinute
        self.isCustom = isCustom
    }
}

extension ActivityType {
    func toDTO() -> ActivityTypeDTO {
        ActivityTypeDTO(
            id: self.id!,
            name: self.name,
            description: self.description,
            caloriesPerMinute: NSDecimalNumber(decimal: self.caloriesPerMinute).doubleValue,
            isCustom: self.isCustom
        )
    }
}
