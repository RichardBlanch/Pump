//
//  Superset.swift
//  App
//
//  Created by Richard Blanchard on 5/15/18.
//

import FluentMySQL
import Vapor
import PumpModels

extension Superset: MySQLUUIDModel {}
extension Superset: Migration {}
extension Superset: Content {}
extension Superset: Parameter {}

extension Superset {
    var workouts: Siblings<Superset, Workout, WorkoutSupersetPivot> {
        return siblings()
    }

    var childrenWorkoutSets: Children<Superset, WorkoutSet> {
        return children(\.superSetIdentification)
    }
}
