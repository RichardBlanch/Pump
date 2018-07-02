import FluentMySQL
import Vapor
import Fluent
import PumpModels

struct CuratorController: RouteCollection {
    func boot(router: Router) throws {
        let curatorRoutes = self.baseRoute(from: router)

        curatorRoutes.get(use: allCurators)
        curatorRoutes.get("first", use: firstCurator)
        curatorRoutes.put(Curator.parameter, use: updateCurator)
        curatorRoutes.post(Curator.self, use: createCurator)
    }

    // MARK: - Handlers

    private func allCurators(_ req: Request) throws -> Future<[Curator]> {
        return req.withPooledConnection(to: .pump) { conn in
             return Curator.query(on: conn).all()
        }
    }

    private func firstCurator(_ req: Request) throws -> Future<Curator> {
        return req.withPooledConnection(to: .pump, closure: { conn in
            return Curator.query(on: conn).first().map({ cur in
                guard let cur = cur else { abort() }
                return cur
            })
        })
    }

    func updateCurator(_ req: Request) throws -> Future<Curator> {
        return try flatMap(to: Curator.self,
                           req.parameters.next(Curator.self),
                           req.content.decode(Curator.self)) {
                            curator, updatedCurator in

                            var curatorToSave = curator
                            curatorToSave.name = updatedCurator.name ?? curator.name
                            curatorToSave.image = updatedCurator.image ?? curator.image

                            return curatorToSave.save(on: req)
        }
    }

    private func createCurator(from req: Request, curator: Curator) throws -> Future<Curator> {
        return req.withPooledConnection(to: .pump) { conn in
            return curator.save(on: conn)
        }
    }
}


// MARK: - Routeable

extension CuratorController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "curators")
    }
}
