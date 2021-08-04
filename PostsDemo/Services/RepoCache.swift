//
//  RepoCache.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation
import Combine

enum SourcefulSource {
    case cache
    case latest
}

struct Sourceful<Value> {
    var value: Value
    var source: SourcefulSource
}

final class RepoCache<Value: Codable> {
    let cachesURL = FileManager.default.cachesDirectoryURL()
    let fileName: String

    var fileURL: URL {
        cachesURL.appendingPathComponent(fileName)
    }

    private let privateQueue = DispatchQueue(label: "repo-cahce")

    init(fileName: String) {
        self.fileName = fileName
    }

    private func read() -> AnyPublisher<Value, Error> {
        Future<Data, Error> { resolve in
            self.privateQueue.async {
                do {
                    let data = try Data(contentsOf: self.fileURL)
                    resolve(.success(data))
                } catch {
                    resolve(.failure(error))
                }
            }
        }
        .decode(type: Value.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }

    private func write(_ value: Value) {
        self.privateQueue.async {
            do {
                let data = try JSONEncoder().encode(value)
                try data.write(to: self.fileURL)
            } catch { }
        }
    }

    func connecting<P: Publisher>(to latest: P) -> AnyPublisher<Sourceful<Value>, Error> where P.Output == Value, P.Failure == Swift.Error {

        let latest: AnyPublisher<Sourceful<Value>, Error> = latest
            .map({ [weak self] value -> Value in
                self?.write(value)
                return value
            })
            .map({ Sourceful(value: $0, source: .latest) })
            .eraseToAnyPublisher()

        let cached: AnyPublisher<Sourceful<Value>, Error> = read()
            .map({ Sourceful(value: $0, source: .cache) })
            .catch({ _ in latest })
            .eraseToAnyPublisher()

        return cached.merge(with: latest)
            .eraseToAnyPublisher()
    }
}

fileprivate extension FileManager {
    func cachesDirectoryURL() -> URL {
        return urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}
