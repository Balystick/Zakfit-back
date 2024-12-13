//
//  DietRule.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Fluent
import Vapor

final class DietRule: Model, Content, @unchecked Sendable {
    static let schema = "diet_rule"

    @ID(custom: "diet_rule_id")
    var id: UUID?

    @Field(key: "diet_rule_name")
    var name: String

    @Field(key: "diet_rule_description")
    var description: String

    @Field(key: "diet_rule_criterion")
    var criterion: String

    @Field(key: "diet_rule_operator")
    var ruleOperator: String

    @Field(key: "diet_rule_value")
    var value: String

    @Field(key: "diet_rule_priority")
    var priority: Int

    @Parent(key: "diet_id")
    var diet: Diet

    init() {}

    init(id: UUID? = nil, name: String, description: String, criterion: String, operator: String, value: String, priority: Int, dietID: UUID) {
        self.id = id
        self.name = name
        self.description = description
        self.criterion = criterion
        self.ruleOperator = ruleOperator
        self.value = value
        self.priority = priority
        self.$diet.id = dietID
    }
}
