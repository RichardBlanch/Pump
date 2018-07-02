//
//  User.swift
//  App
//
//  Created by Richard Blanchard on 6/30/18.
//

import Vapor
import PumpModels
import FluentMySQL
import Authentication

extension User {
    struct Public: Codable {
        var id: UUID?
        var name: String
        var username: String
    }

    func convertToPublic() -> User.Public {
        return User.Public(id: id, name: name, username: username)
    }
}

extension EventLoopFuture {
    func convertToPublicUser(from user: Future<User>) -> Future<User.Public> {
        return user.map(to: User.Public.self) { user in
            return user.convertToPublic()
        }
    }
}

// MARK: BasicAuthenticatable

extension User: BasicAuthenticatable {
    public static var usernameKey: WritableKeyPath<User, String> {
        return \User.username
    }

    public static var passwordKey: WritableKeyPath<User, String> {
        return \User.password!
    }
}

extension User.Public: Content {}

extension User: MySQLUUIDModel {}
extension User: Migration {
    public static func prepare(on conn: MySQLConnection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { builder in
            try addProperties(to: builder)
            builder.unique(on: \.username)
        })
    }
}
extension User: Content {}
extension User: Parameter {}

// MARK: - TokenAuthenticatable

extension User: TokenAuthenticatable {
    public typealias TokenType = Token
}
