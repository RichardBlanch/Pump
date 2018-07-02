//
//  Set.swift
//  App
//
//  Created by Richard Blanchard on 6/25/18.
//

import FluentMySQL
import Vapor
import PumpModels

extension WorkoutSet: MySQLUUIDModel {}
extension WorkoutSet: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection, closure: { builder in
            try addProperties(to: builder)
            builder.reference(from: \.superSetIdentification, to: \Superset.id)
        })
    }
}
extension WorkoutSet: Content {}
extension WorkoutSet: Parameter {}

extension WorkoutSet: Equatable {
    var superSet: Parent<WorkoutSet, Superset>? {
        return parent(\.superSetIdentification)
    }

    public static func == (lhs: WorkoutSet, rhs: WorkoutSet) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.bodyPart == rhs.bodyPart
    }
}

