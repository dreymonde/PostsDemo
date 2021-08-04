//
//  FlatType.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation

protocol FlatType: RawRepresentable, Codable {
}

extension FlatType where RawValue: Codable {
    init(from decoder: Swift.Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        if let value = Self.init(rawValue: rawValue) {
            self = value
        } else {
            throw RawValueCodableError.wrongRawValue
        }
    }

    func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

enum RawValueCodableError: Error {
    case wrongRawValue
}
