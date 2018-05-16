
import Vapor

class RouteContainer {
    // MARK: - Singleton
    static let shared = RouteContainer()

    private var routes: [RouteCollection] = []

    func addRoute(_ route: RouteCollection) {
        routes.append(route)
    }

    func registerRoutes(for router: Router) {
        for routeCollection in routes {
            try? router.register(collection: routeCollection)
        }
    }
}
