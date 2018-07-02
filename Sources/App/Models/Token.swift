//
//  Token.swift
//  App
//
//  Created by Richard Blanchard on 6/30/18.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication
import PumpModels

public final class Token: Codable {
    public var id: UUID?
    var token: String
    var userID: User.ID

    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token: MySQLUUIDModel {}
extension Token: Migration {}
extension Token: Content {}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = try CryptoRandom().generateData(count: 16)

        return try Token(token: random.base64EncodedString(), userID: user.requireID())
    }
}

// MARK: - Authentication.Token

extension Token: Authentication.Token {
    public static let userIDKey: UserIDKey = \Token.userID
    public typealias UserType = User
}

// MARK: - BearerAuthenticatable

extension Token: BearerAuthenticatable {
    public static let tokenKey: TokenKey = \Token.token
}
