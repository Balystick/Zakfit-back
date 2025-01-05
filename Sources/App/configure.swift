import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
import JWT
import Gatekeeper

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Database
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "root", // à sécuriser par la suite
        password: Environment.get("DATABASE_PASSWORD") ?? "", // à sécuriser par la suite
        database: Environment.get("DATABASE_NAME") ?? "zakfit"
    ), as: .mysql)
    
    // JWT
    guard let secret = Environment.get("SECRET_KEY") else {
        fatalError("JWT secret is not set in environment variables")
    }
    let hmacKey = HMACKey(from: Data(secret.utf8))
    await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)
    
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
    app.gatekeeper.config = .init(maxRequests: 1000, per: .minute)
    
    // Middlewares
    app.middleware.use(corsMiddleware)
    app.middleware.use(JWTAuthMiddleware(publicPaths: [
        (method: .POST, path: "/user/create"),
        (method: .POST, path: "/user/login")
    ]))
    app.middleware.use(GatekeeperMiddleware())
    
    // Controllers
    try app.register(collection: UserController())
    try app.register(collection: UserWeightsController())
    try app.register(collection: MealsController())
    try app.register(collection: GoalsController())
    try app.register(collection: ActivityController())
}
