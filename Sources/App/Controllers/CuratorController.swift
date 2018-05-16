import FluentMySQL
import Vapor
import Fluent

struct CuratorController: RouteCollection {
    func boot(router: Router) throws {
        let curatorRoutes = self.baseRoute(from: router)

        curatorRoutes.get(use: allCurators)
        curatorRoutes.post(Curator.self, use: createCurator)
    }

    // MARK: - Handlers

    private func allCurators(_ req: Request) throws -> Future<[Curator]> {
        return req.withPooledConnection(to: .pump) { conn in
             return Curator.query(on: conn).all()
        }
    }

    private func createCurator(from req: Request, curator: Curator) throws -> Future<Curator> {
        return req.withPooledConnection(to: .pump) { conn in
            return curator.save(on: conn)
        }
    }
}

extension CuratorController: Routeable {
    func baseRoute(from router: Router) -> Router {
        return router.grouped("api", "curators")
    }
}
