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
    var workoutSets: [WorkoutSet]?

    var workouts: Siblings<Superset, Workout, WorkoutSupersetPivot> {
        return siblings()
    }

    init(identifier: String) {
        self.identifier = identifier
    }
}

extension Superset: Equatable {
    static func == (lhs: Superset, rhs: Superset) -> Bool {
        return lhs.id == rhs.id && lhs.identifier == rhs.identifier
    }
}

extension Superset {
    var childrenWorkoutSets: Children<Superset, WorkoutSet> {
        return children(\.supersetID)
    }
}





extension Superset: MySQLUUIDModel {}
extension Superset: Migration {}
extension Superset: Content { }
extension Superset: Parameter { }

