import FluentMySQL
import Vapor

extension DatabaseIdentifier {
    static var mysql: DatabaseIdentifier<MySQLDatabase> {
        return .init("Pump")
    }
}

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(FluentMySQLProvider())
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    var middlewares = MiddlewareConfig()
    
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    var databases = DatabasesConfig()
    // Step 3
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "golden", password: "password", database: "Pump")
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .pump)

    services.register(databases)

    var migrations = MigrationConfig()
    Workout.defaultDatabase = DatabaseIdentifier<MySQLDatabase>.pump as DatabaseIdentifier<MySQLDatabase> 
    migrations.add(migration: Curator.self, database: .pump)
    migrations.add(migration: Workout.self, database: .pump)
    migrations.add(model: Superset.self, database: .pump)
    migrations.add(model: WorkoutSupersetPivot.self, database: .pump)
    services.register(migrations)

}

extension DatabaseIdentifier{
    static var pump: DatabaseIdentifier<MySQLDatabase> {
        return .init("Pump")
    }
}


