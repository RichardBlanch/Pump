//
//  WorkoutSupersetPivot.swift
//  App
//
//  Created by Richard Blanchard on 5/15/18.
//

import Foundation
import Vapor
import FluentMySQL

final class WorkoutSupersetPivot: MySQLUUIDPivot {
    static let leftIDKey: WritableKeyPath<WorkoutSupersetPivot, UUID> = \.workoutID
    static let rightIDKey: WritableKeyPath<WorkoutSupersetPivot, UUID> = \.supersetID

    typealias Left = Workout
    typealias Right = Superset

    var id: UUID?
    var workoutID: Workout.ID
    var supersetID: Superset.ID

    init(_ workoutID: Workout.ID, _ supersetID: Superset.ID) {
        self.workoutID = workoutID
        self.supersetID = supersetID
    }
}

extension WorkoutSupersetPivot: Migration {
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection, closure: { builder in
            try addProperties(to: builder)

            try builder.addReference(from: \.workoutID, to: \Workout.id)
            try builder.addReference(from: \.supersetID, to: \Superset.id)

        })
    }
}
