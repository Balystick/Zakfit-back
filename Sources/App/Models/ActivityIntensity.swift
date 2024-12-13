//
//  ActivityIntensity.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class ActivityIntensity: Model, @unchecked Sendable {
    static let schema = "activity_intensity"

    @ID(custom: "activity_intensity_id")
    var id: UUID?

    @Field(key: "activity_intensity_name")
    var name: String

    @Field(key: "activity_intensity_order")
    var order: Int

    @Children(for: \.$intensity)
    var activities: [Activity]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
