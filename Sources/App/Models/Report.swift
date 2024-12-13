//
//  Report.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class Report: Model, Content, @unchecked Sendable {
    static let schema = "report"

    @ID(custom: "report_id")
    var id: UUID?

    @Field(key: "report_start_date")
    var startDate: Date

    @Field(key: "report_end_date")
    var endDate: Date

    @Field(key: "report_total_calories_consumed")
    var totalCaloriesConsumed: Float

    @Field(key: "report_total_calories_burned")
    var totalCaloriesBurned: Float

    @Field(key: "report_total_proteins")
    var totalProteins: Float

    @Field(key: "report_total_carbs")
    var totalCarbs: Float

    @Field(key: "report_total_fats")
    var totalFats: Float

    @Field(key: "report_activity_duration")
    var activityDuration: Int

    @Parent(key: "report_type_id")
    var reportType: ReportType

    init() {}

    init(id: UUID? = nil, startDate: Date, endDate: Date, totalCaloriesConsumed: Float, totalCaloriesBurned: Float, totalProteins: Float, totalCarbs: Float, totalFats: Float, activityDuration: Int, reportTypeID: UUID) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.totalCaloriesConsumed = totalCaloriesConsumed
        self.totalCaloriesBurned = totalCaloriesBurned
        self.totalProteins = totalProteins
        self.totalCarbs = totalCarbs
        self.totalFats = totalFats
        self.activityDuration = activityDuration
        self.$reportType.id = reportTypeID
    }
}
