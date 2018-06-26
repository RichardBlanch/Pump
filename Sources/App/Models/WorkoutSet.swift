//
//  Set.swift
//  App
//
//  Created by Richard Blanchard on 6/25/18.
//

import FluentMySQL
import Vapor

final class WorkoutSet: Codable {
    var id: UUID?
    var name: String!
    var description: String!
    var bodyPart: String!
    var supersetID: Superset.ID

    var parentSuperSet: Parent<WorkoutSet, Superset> {
        return parent(\.supersetID)
    }
}

extension WorkoutSet: Equatable {
    static func == (lhs: WorkoutSet, rhs: WorkoutSet) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.bodyPart == rhs.bodyPart
    }
}

extension WorkoutSet: MySQLUUIDModel {}
extension WorkoutSet: Migration {}
extension WorkoutSet: Content {}
extension WorkoutSet: Parameter {}

