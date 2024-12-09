import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import JWT
import Gatekeeper

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Database
    app.databases.use(DatabaseConfigurationFactory.mysql(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "root", // à sécuriser par la suite
            password: Environment.get("DATABASE_PASSWORD") ?? "", // à sécuriser par la suite
            database: Environment.get("DATABASE_NAME") ?? "zakfit"
        ), as: .mysql)
    
    // CORS
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin : .all, // à restreindre par la suite
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin],
        cacheExpiration: 8
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    
    // Rate Limiter
    app.caches.use(.memory)
    app.gatekeeper.config = .init(maxRequests: 100, per: .minute)
    
    // Middlewares
    app.middleware.use(corsMiddleware)
    app.middleware.use(JWTAuthMiddleware(publicPaths: [
        (method: .POST, path: "/users/create"),
        (method: .POST, path: "/users/login")
    ]))
    app.middleware.use(GatekeeperMiddleware())

    // register routes
    try routes(app)
}
