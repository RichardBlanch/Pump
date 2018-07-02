import FluentMySQL
import Vapor
import PumpModels
import Pagination

extension Workout {
    var curator: Parent<Workout, Curator> {
        return parent(\.curatorID)
    }

    var supersets: Siblings<Workout, Superset, WorkoutSupersetPivot> {
        return siblings()
    }
}

extension Workout: MySQLUUIDModel {}
extension Workout: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: connection, closure: { builder in
            try addProperties(to: builder)
            builder.reference(from: \.curatorID, to: \Curator.id)
        })
    }
}
extension Workout: Content {}
extension Workout: Parameter {}
extension Workout: Paginatable {}
