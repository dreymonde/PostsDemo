//
//  RepoCache.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation
import Combine

final class RepoCache<Value: Codable> {
    let cachesURL = FileManager.default.cachesDirectoryURL()
    let fileURL: URL

    private let serialQueue = DispatchQueue(label: "repo-cache")

    init(fileName: String) {
        self.fileURL = cachesURL.appendingPathComponent(fileName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "tmp")
    }

    func connecting<P: Publisher>(to latest: P, useCache: Bool) -> AnyPublisher<Sourceful<Value>, Error> where P.Output == Value, P.Failure == Error {

        let latest: AnyPublisher<Sourceful<Value>, Error> = latest
            .map({ [weak self] value -> Value in
                self?.write(value)
                return value
            })
            .map({ Sourceful.latest($0) })
            .eraseToAnyPublisher()

        let cached: AnyPublisher<Sourceful<Value>, Error> = read()
            .map({ Sourceful.cache($0) })
            .catch({ _ in latest })
            .eraseToAnyPublisher()

        let resolved = useCache ? cached.merge(with: latest).eraseToAnyPublisher() : latest

        return resolved
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension RepoCache {
    private func read() -> AnyPublisher<Value, Error> {
        Future<Data, Error> { resolve in
            self.serialQueue.async {
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
        self.serialQueue.async {
            do {
                let data = try JSONEncoder().encode(value)
                try data.write(to: self.fileURL)
            } catch { }
        }
    }
}

fileprivate extension FileManager {
    func cachesDirectoryURL() -> URL {
        return urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}
