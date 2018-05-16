import Vapor
import Fluent

protocol Routeable {
    func baseRoute(from router: Router) -> Router
}
