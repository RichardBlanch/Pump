import Foundation
import Vapor
import FluentMySQL
import PumpModels

extension Curator: MySQLUUIDModel {}
extension Curator: Migration {}
extension Curator: Content { }
extension Curator: Parameter { }

extension Curator {
     var workouts: Children<Curator, Workout> {
        return self.children(\.curatorID)
    }
}
