//
//  Superset.swift
//  App
//
//  Created by Richard Blanchard on 5/15/18.
//

import FluentMySQL
import Vapor

final class Superset: Codable {
    var id: UUID?
    var identifier: String!

    var workouts: Siblings<Superset, Workout, WorkoutSupersetPivot> {
        return siblings()
    }

    init(identifier: String) {
        self.identifier = identifier
    }
}

extension Superset: MySQLUUIDModel {}
extension Superset: Migration {}
extension Superset: Content { }
extension Superset: Parameter { }

