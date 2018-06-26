//
//  WorkoutPayload.swift
//  App
//
//  Created by Richard Blanchard on 6/25/18.
//

import Vapor
import Fluent

struct WorkoutPayload: Content {
    let workout: Workout
    let sets: [[WorkoutSet]]

    init(workout: Workout, sets: [[WorkoutSet]]) {
        self.workout = workout
        self.sets = sets
    }
}

extension Workout {
    func workoutPayload(for conn: DatabaseConnectable) throws -> Future<WorkoutPayload> {
        return try supersets.query(on: conn).all().flatMap { supersetter in
            let futureSets = try supersetter.compactMap({ try $0.childrenWorkoutSets.query(on: conn).all()} )
            let a = futureSets.flatten(on: conn)
            return a.map(to: WorkoutPayload.self, { sets  in
                return WorkoutPayload(workout: self, sets: sets)
            })
        }
    }
}
