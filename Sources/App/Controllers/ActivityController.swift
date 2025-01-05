//
//  ActivityController.swift
//  ZakFit_back
//
//  Created by Aurélien on 04/01/2025.
//

import Vapor
import Fluent

struct ActivityController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let activities = routes.grouped("activities")
        activities.get("types", use: getTypes)
    }
    
    @Sendable
    func getTypes(req: Request) async throws -> [ActivityTypeDTO] {
        let activityTypes = try await ActivityType.query(on: req.db).all()
        return activityTypes.map { $0.toDTO() }
    }
}
