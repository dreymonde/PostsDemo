//
//  Sourceful.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import Foundation

enum SourcefulSource {
    case memory
    case cache
    case latest

    var isLatest: Bool {
        self == .latest
    }

    var debugDescription: String {
        switch self {
        case .memory:
            return "Memory"
        case .cache:
            return "Cache / DB"
        case .latest:
            return "Server"
        }
    }
}

struct Sourceful<Value> {
    var value: Value
    var source: SourcefulSource

    static func memory(_ value: Value) -> Sourceful<Value> {
        Sourceful(value: value, source: .memory)
    }

    static func cache(_ value: Value) -> Sourceful<Value> {
        Sourceful(value: value, source: .cache)
    }

    static func latest(_ value: Value) -> Sourceful<Value> {
        Sourceful(value: value, source: .latest)
    }
}
