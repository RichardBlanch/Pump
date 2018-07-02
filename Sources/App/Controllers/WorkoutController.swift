//
//  WorkoutController.swift
//  App
//
//  Created by Richard Blanchard on 5/14/18.
//

import FluentMySQL
import Vapor
import Fluent
import PumpModels
import Pagination
import Crypto

struct NoAuthAbortError: AbortError {
    let identifier: String = "NoAuthAbortError"
    let status: HTTPResponseStatus = .networkAuthenticationRequired
    let headers: HTTPHeaders = HTTPHeaders()
    let reason: String = "Not Authorized"
}

struct WorkoutController: RouteCollection {
    func boot(router: Router) throws {
        let workoutRotes = baseRoute(from: router)
        let tokenAuthWorkoutRoutes = registerBearerAuth(for: workoutRotes)

        workoutRotes.get(use: allWorkouts)
        workoutRotes.get(Workout.parameter, "supersets", use: getSupersets)
        workoutRotes.get(Workout.parameter, use: getHandler)
        workoutRotes.put(Workout.parameter, use: updateHandler)
        workoutRotes.post(Workout.parameter, "superset", Superset.parameter, use: addSupersetHandler)
        workoutRotes.get(Workout.parameter, "payload", use: workoutPayload)
        workoutRotes.delete(Workout.parameter, use: deleteHandler)

        // Pagination
        workoutRotes.get("paginated", use: paginatedWorkouts)

        // Auth
        tokenAuthWorkoutRoutes.post(Workout.self, use: createWorkout)
    }

    private func registerBearerAuth(for routes: Router) -> Router {
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthGroup = routes.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        return tokenAuthGroup
    }

    // MARK: - Handlers

    private func paginatedWorkouts(_ req: Request) throws -> Future<Paginated<Workout>> {
         return try Workout.query(on: req).paginate(for: req)
    }

    private func allWorkouts(_ req: Request) throws -> Future<[Workout]> {
        return req.withPooledConnection(to: .pump) { conn in
            return Workout.query(on: req).all()
        }
    }

    func getHandler(_ req: Request) throws -> Future<Workout> {
        return req.withPooledConnection(to: .pump, closure: { connection in
            try req.parameters.next(Workout.self).map({ workout in
                return workout
            })
        })
    }

    func workoutPayload(_ req: Request) -> Future<WorkoutPayload> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            try req.parameters.next(Workout.self).flatMap({ workout in
                return try workout.workoutPayload(for: conn)
            })
        })
    }



    private func createWorkout(from req: Request, workout: Workout) throws -> Future<Workout> {
        return req.withPooledConnection(to: .pump) { conn in
            try req.requireAuthenticated(User.self)

            return workout.save(on: conn)
        }
    }

    func updateHandler(_ req: Request) throws -> Future<Workout> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try flatMap(to: Workout.self,
                               req.parameters.next(Workout.self),
                               req.content.decode(Workout.self)) {
                                workout, updatedWorkout in

                                let newWorkout = Workout(id: workout.id!, name: updatedWorkout.name, bodyPart: updatedWorkout.bodyPart, curatorID: updatedWorkout.curatorID)

                                return newWorkout.save(on: req)
            }
        })
    }

    func getSupersets(_ req: Request) throws -> Future<[Superset]> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try req.parameters.next(Workout.self)
                .flatMap(to: [Superset].self) { workout in
                    try workout.supersets.query(on: req).all()
            }
        })
    }

    private func addSupersetHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try flatMap(to: HTTPStatus.self, req.parameters.next(Workout.self), req.parameters.next(Superset.self), { workout, superset  in
                let pivot = try WorkoutSupersetPivot.init(workout.requireID(), superset.requireID())
                return pivot.save(on: conn).transform(to: .created)
            })
        })
    }

    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try req.parameters.next(Workout.self).delete(on: conn).transform(to: HTTPStatus.noContent)
        })
    }

    struct WorkoutCreateData: Content {
        let name: String
        let curatorID: UUID
        let bodyPart: String
    }
}

extension WorkoutController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "workout")
    }
}

