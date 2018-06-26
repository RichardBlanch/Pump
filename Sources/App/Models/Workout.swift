import FluentMySQL
import Vapor

final class Workout: Codable {
    var id: UUID?
    var name: String!
    var bodyPart: String!
    var curatorID: Curator.ID
    var superset: [Superset]?
    var sets: [[WorkoutSet]]?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        bodyPart = try values.decode(String.self, forKey: .bodyPart)
        curatorID = try values.decode(UUID.self, forKey: .curatorID)
    }

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
extension Workout: RequestDecodable {
    static func decode(from req: Request) throws -> Future<Workout> {
        abort()
    }
}
extension Workout: Content {}
extension Workout: Parameter { }
