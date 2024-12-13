//
//  ReportType.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class ReportType: Model, Content, @unchecked Sendable {
    static let schema = "report_type"

    @ID(custom: "report_type_id")
    var id: UUID?

    @Field(key: "report_type_name")
    var name: String

    @Field(key: "report_type_order")
    var order: Int

    @Children(for: \.$reportType)
    var reports: [Report]

    init() {}

    init(id: UUID? = nil, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
}
