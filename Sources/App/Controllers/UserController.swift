//
//  UserController.swift
//  App
//
//  Created by Richard Blanchard on 6/30/18.
//

import FluentMySQL
import Vapor
import Fluent
import PumpModels
import Crypto


struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let userRouter = baseRoute(from: router)

        userRouter.get(use: allUsers)
        userRouter.post(User.self, use: createUser)
        userRouter.get(User.parameter, use: getUser)

        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let basicAuthGroup = userRouter.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)

    }

    private func allUsers(_ req: Request) throws -> Future<[User.Public]> {
        return req.withPooledConnection(to: .pump) { conn in
            return User.query(on: conn).decode(User.Public.self).all()
        }
    }

    private func createUser(_ req: Request, user: User) -> Future<User.Public> {
        return req.withPooledConnection(to: .pump) { conn in
            guard let password = user.password else { throw Abort(.unauthorized) }

            let hashedPassword = try BCrypt.hash(password)
            var newUser = user
            newUser.password = hashedPassword
            let savedUser = newUser.save(on: conn)

            return savedUser.convertToPublicUser(from: savedUser)
        }
    }

    private func getUser(_ req: Request) -> Future<User.Public> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            let futureUser = try req.parameters.next(User.self)
            return futureUser.convertToPublicUser(from: futureUser)
        })
    }

    private func loginHandler(_ req: Request) throws -> Future<Token> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            let user = try req.requireAuthenticated(User.self)
            let token = try Token.generate(for: user)
            return token.save(on: conn)
        })
    }
}

// MARK: - Routeable

extension UserController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "users")
    }
}
