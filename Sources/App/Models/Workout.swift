import FluentMySQL
import Vapor

final class Workout: Codable {
    var id: UUID?
    var name: String!
    var bodyPart: String!
    var curatorID: Curator.ID

    var supersets: Siblings<Workout, Superset, WorkoutSupersetPivot> {
        return siblings()
    }

    init(name: String, bodyPart: String, curatorID: Curator.ID) {
        self.name = name
        self.bodyPart = bodyPart
        self.curatorID = curatorID
    }
}

extension Workout {
    var curator: Parent<Workout, Curator> {
        return parent(\.curatorID)
    }
}

extension Workout: MySQLUUIDModel {}
extension Workout: Migration {
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection, closure: { builder in
            try addProperties(to: builder)
            try builder.addReference(from: \.curatorID, to: \Curator.id)
        })
    }
}
extension Workout: Content { }
extension Workout: Parameter { }
