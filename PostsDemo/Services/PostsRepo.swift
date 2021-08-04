//
//  PostsRepo.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation
import Combine
import SwiftUI

final class PostsRepo: ObservableObject {

    let api: API

    static let main = PostsRepo(api: .main)

    init(api: API) {
        self.api = api
    }

    let cache = RepoCache<[Post]>(fileName: "all-posts")

    enum State {
        case idle
        case loading(Sourceful<[Post]>?)
        case loaded(Sourceful<[Post]>)
        case failed(Error)

        var existing: Sourceful<[Post]>? {
            switch self {
            case .loading(let posts):
                return posts
            case .loaded(let posts):
                return posts
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

    @Published var state: State = .idle

    func fetchPosts(transitioningToLoading: Bool = true, useCache: Bool = true) {
        if transitioningToLoading {
            state = .loading(state.existing)
        }

        let apiCall = api.getPostsWithUsers()
            .map({ $0.map(Post.init(postWithUser:)) })

        let finalCall: AnyPublisher<Sourceful<[Post]>, Error> = useCache ?
            cache.connecting(to: apiCall) :
            apiCall.map({ Sourceful(value: $0, source: .latest) }).eraseToAnyPublisher()

        finalCall
            .map({ State.loaded($0) })
            .catch({ Just(State.failed($0)) })
            .assign(to: &$state)
    }
}
