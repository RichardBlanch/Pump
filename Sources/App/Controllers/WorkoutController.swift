//
//  WorkoutController.swift
//  App
//
//  Created by Richard Blanchard on 5/14/18.
//

import FluentMySQL
import Vapor
import Fluent

struct WorkoutController: RouteCollection {
    func boot(router: Router) throws {
        let workoutRotes = self.baseRoute(from: router)

        workoutRotes.get(use: allWorkouts)
        workoutRotes.get(Workout.parameter, "supersets", use: getSupersets)
        workoutRotes.post(Workout.self, use: createWorkout)
        workoutRotes.put(Workout.parameter, use: updateHandler)
        workoutRotes.post(Workout.parameter, "superset", Superset.parameter, use: addSupersetHandler)
    }

    // MARK: - Handlers

    private func allWorkouts(_ req: Request) throws -> Future<[Workout]> {
        return req.withPooledConnection(to: .pump) { conn in
            return Workout.query(on: conn).all()
        }
    }

    private func createWorkout(from req: Request, workout: Workout) throws -> Future<Workout> {
        return req.withPooledConnection(to: .pump) { conn in
            return workout.save(on: conn)
        }
    }

    func updateHandler(_ req: Request) throws -> Future<Workout> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return try flatMap(to: Workout.self,
                               req.parameters.next(Workout.self),
                               req.content.decode(Workout.self)) {
                                workout, updatedWorkout in

                                workout.name = updatedWorkout.name
                                workout.bodyPart = updatedWorkout.bodyPart
                                workout.curatorID = updatedWorkout.curatorID
                                return workout.save(on: req)
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
}

extension WorkoutController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "workout")
    }
}

