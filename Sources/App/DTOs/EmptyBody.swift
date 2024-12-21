//
//  Untitled.swift
//  ZakFit_back
//
//  Created by Aurélien on 21/12/2024.
//

import Vapor

struct EmptyBody: Content, AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        Response(status: .ok, body: .empty)
    }
}
