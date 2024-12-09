//
//  Payload.swift
//  ZakFit_back
//
//  Created by Aurélien on 09/12/2024.
//

import Vapor
import JWT

struct Payload: JWTPayload, Authenticatable, Content {
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case userId = "uid"
    }

    var expiration: ExpirationClaim
    var userId: UUID

    func verify(using algorithm: some JWTAlgorithm) throws {
        try self.expiration.verifyNotExpired()
    }
}
