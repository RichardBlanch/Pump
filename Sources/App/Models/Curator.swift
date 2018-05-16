import Foundation
import Vapor
import FluentMySQL

final class Curator: Codable {
    var id: UUID?
    var name: String!
    var image: String!

    init(name: String, image: String) {
        self.name = name
        self.image = image
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
