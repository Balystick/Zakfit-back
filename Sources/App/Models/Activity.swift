//
//  Activity.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Activity: Model, Content, @unchecked Sendable {
    static let schema = "activity"

    @ID(custom: "activity_id")
    var id: UUID?

    @Field(key: "activity_date_time")
    var dateTime: Date

    @Field(key: "activity_duration")
    var duration: Int

    @Field(key: "activity_calories_burned")
    var caloriesBurned: Float

    @Field(key: "activity_notes")
    var notes: String?

    @Parent(key: "activity_intensity_id")
    var intensity: ActivityIntensity

    init() {}

    init(id: UUID? = nil, dateTime: Date, duration: Int, caloriesBurned: Float, notes: String?, intensityID: UUID) {
        self.id = id
        self.dateTime = dateTime
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.notes = notes
        self.$intensity.id = intensityID
    }
}
