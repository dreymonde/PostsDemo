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
        case loading
        case loaded(Sourceful<[Post]>)
        case failed(Error)
    }

    @Published var state: State = .idle

    func fetchPosts(transitioningToLoading: Bool = true) {
        if transitioningToLoading {
            state = .loading
        }

        let apiCall = api.getPostsWithUsers()
            .map({ $0.map(Post.init(postWithUser:)) })

        cache.connecting(to: apiCall)
            .map({ State.loaded($0) })
            .catch({ Just(State.failed($0)) })
            .assign(to: &$state)
    }
}
