//
//  SupersetController.swift
//  App
//
//  Created by Richard Blanchard on 5/15/18.
//

import FluentMySQL
import Vapor
import Fluent

struct SupersetController: RouteCollection {
    func boot(router: Router) throws {
        let superSetRoute = self.baseRoute(from: router)

        superSetRoute.get(use: getAllSupersets)
        superSetRoute.post(Superset.self, use: createSuperset)

        // Workout routes
        superSetRoute.get(Superset.parameter, "workouts", use: getWorkouts)
    }

    private func getAllSupersets(_ request: Request) throws -> Future<[Superset]> {
        return request.withPooledConnection(to: .pump, closure: { conn in
            return conn.query(Superset.self).all()
        })
    }

    private func getHandler(_ req: Request) throws -> Future<Superset> {
        return try req.parameters.next(Superset.self)
    }

    private func createSuperset(from request: Request, superset: Superset) throws -> Future<Superset> {
        return request.withPooledConnection(to: .pump, closure: { conn in
            superset.save(on: conn)
        })
    }

    // MARK: - Workouts

    private func getWorkouts(_ req: Request) throws -> Future<[Workout]> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try req.parameters.next(Superset.self)
                .flatMap(to: [Workout].self) { superset in
                    try superset.workouts.query(on: req).all()
            }
        })
    }
}

extension SupersetController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "superset")
    }
}
