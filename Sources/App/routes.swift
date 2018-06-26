import Vapor

/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    let routeContainer = RouteContainer.shared

    routeContainer.addRoute(CuratorController())
    routeContainer.addRoute(WorkoutController())
    routeContainer.addRoute(SupersetController())
    routeContainer.addRoute(WorkoutSetController())


    routeContainer.registerRoutes(for: router)
}
