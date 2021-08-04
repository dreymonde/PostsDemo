//
//  RepoState.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import Foundation

enum RepoState<Value> {
    case idle
    case loading(Value?)
    case loaded(Value)
    case failed(Error)

    var existing: Value? {
        switch self {
        case .loading(let value):
            return value
        case .loaded(let value):
            return value
        case .idle, .failed:
            return nil
        }
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}

enum GuaranteedRepoState<Value> {
    case loading(current: Value)
    case loaded(Value)
    case failed(Error, dismissed: Bool, current: Value)

    var existing: Value {
        switch self {
        case .loading(let value):
            return value
        case .loaded(let value):
            return value
        case .failed(_, _, let value):
            return value
        }
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var hasUndismissedError: Bool {
        get {
            if case .failed(_, let dismissed, _) = self {
                return !dismissed
            }
            return false
        }
        set {
            if newValue == false {
                self.dismissError()
            }
        }
    }

    var error: String? {
        if case .failed(let error, _, _) = self {
            return error.localizedDescription
        }
        return nil
    }

    mutating func dismissError() {
        if case .failed(let error, _, let current) = self {
            self = .failed(error, dismissed: true, current: current)
        }
    }
}
