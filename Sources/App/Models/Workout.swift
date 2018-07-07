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
        return MySQLDatabase.create(self, on: connection) { builder in
            builder.field(for: \Workout.id)
            builder.field(for: \Workout.name)
            builder.field(for: \Workout.curatorID)
            builder.field(for: \Workout.bodyPart)
            builder.field(for: \Workout.imageURL)
            builder.field(for: \Workout.sets)
            builder.reference(from: \.curatorID, to: \Curator.id)
        }
    }
}
extension Workout: Content {}
extension Workout: Parameter {}
extension Workout: Paginatable {}
