//
//  WorkoutSetController.swift
//  App
//
//  Created by Richard Blanchard on 6/25/18.
//

import FluentMySQL
import Vapor
import Fluent
import PumpModels

struct WorkoutSetController: RouteCollection {
    func boot(router: Router) throws {
        let setRouter = self.setRouter(from: router)

        setRouter.get(use: getAllSets)
        setRouter.post(WorkoutSet.self, use: createSet)
    }

    private func setRouter(from parentRouter: Router) -> Router {
        return baseRoute(from: parentRouter)
    }

    private func createSet(from req: Request, set: WorkoutSet) throws -> Future<WorkoutSet> {
        return req.withPooledConnection(to: .pump) { conn in
            return set.save(on: conn)
        }
    }

    private func getAllSets(_ req: Request) throws -> Future<[WorkoutSet]> {
        return req.withPooledConnection(to: .pump) { conn in
            return WorkoutSet.query(on: conn).all()
        }
    }
}


// MARK: - Routeable

extension WorkoutSetController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "sets")
    }
}
