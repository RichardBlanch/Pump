import FluentMySQL
import Vapor
import PumpModels
import Authentication

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

    let mysqlConfig = databaseConfig()
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .pump)

    services.register(databases)
    try services.register(AuthenticationProvider())

    var migrations = MigrationConfig()
    Workout.defaultDatabase = DatabaseIdentifier<MySQLDatabase>.pump as DatabaseIdentifier<MySQLDatabase>
    Curator.defaultDatabase = DatabaseIdentifier<MySQLDatabase>.pump as DatabaseIdentifier<MySQLDatabase>

    migrations.add(migration: Curator.self, database: .pump)
    migrations.add(model: User.self, database: .pump)
    migrations.add(migration: Workout.self, database: .pump)
    migrations.add(model: Superset.self, database: .pump)
    migrations.add(model: WorkoutSupersetPivot.self, database: .pump)
    migrations.add(model: WorkoutSet.self, database: .pump)

    migrations.add(model: Token.self, database: .pump)
    services.register(migrations)
}

private func databaseConfig() -> MySQLDatabaseConfig {
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "golden"
    let databaseName = Environment.get("DATABASE_DB") ?? "Pump"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"

     return MySQLDatabaseConfig(hostname: username, port: 3306, username: username, password: password, database: databaseName)
}

extension DatabaseIdentifier{
    static var pump: DatabaseIdentifier<MySQLDatabase> {
        return .init("Pump")
    }
}


