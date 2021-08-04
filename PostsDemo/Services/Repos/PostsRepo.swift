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

    typealias State = GuaranteedRepoState<Sourceful<[Post]>>

    let api: API

    init(api: API) {
        self.api = api
    }

    let cache = RepoCache<[Post]>(fileName: "all-posts")
    @Published var state: State = .loaded(.memory([]))

    func fetchPosts(transitionToLoading: Bool = true, useCache: Bool = true) {
        if transitionToLoading {
            state = .loading(current: state.existing)
        }

        let apiCall = api.getPostsWithUsers()
            .map({ $0.map(Post.init(postWithUser:)) })

        cache.connecting(to: apiCall, useCache: useCache)
            .map({ State.loaded($0) })
            .catch({ Just(State.failed($0, dismissed: false, current: self.state.existing)) })
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

    func refresh() {
        fetchPosts(transitionToLoading: false, useCache: false)
    }
}
