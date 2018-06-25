import Foundation
import Vapor
import FluentMySQL

final class Curator: Codable {
    var id: UUID?
    var name: String!
    var image: String!
    var workoutsArray: [Workout]?

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    static func setWorkouts(for curator: Curator, with conn: MySQLConnection) throws -> Future<Curator> {
        return try curator.workouts.query(on: conn).all().map(to: Curator.self) { workouts in
            curator.workoutsArray = workouts
            return curator
        }
    }
}

extension Curator {
    var workouts: Children<Curator, Workout> {
        return children(\.curatorID)
    }
}

extension Curator: MySQLUUIDModel {}
extension Curator: Migration {}
extension Curator: Content { }
extension Curator: Parameter { }
