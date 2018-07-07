//
//  WorkoutPayload.swift
//  App
//
//  Created by Richard Blanchard on 6/25/18.
//

import Vapor
import Fluent
import PumpModels

struct WorkoutPayload: Content {
    let id: UUID?
    let name: String
    let curatorID: UUID
    let bodyPart: String
    let imageURL: String
    let sets: [[WorkoutSet]]
}

extension Workout {
    func workoutPayload(for conn: DatabaseConnectable) throws -> Future<WorkoutPayload> {
        return try supersets.query(on: conn).all().flatMap { supersetter in
            let futureSets = try supersetter.compactMap({ try $0.childrenWorkoutSets.query(on: conn).all()} )
            let a = futureSets.flatten(on: conn)
            return a.map(to: WorkoutPayload.self, { sets  in
                return WorkoutPayload(id: self.id, name: self.name, curatorID: self.curatorID, bodyPart: self.bodyPart, imageURL: self.imageURL, sets: sets)
            })
        }
    }
}
