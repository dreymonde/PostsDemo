//
//  PostRepo.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import Foundation
import Combine

final class PostRepo: ObservableObject {

    typealias State = GuaranteedRepoState<Sourceful<Post>>

    let api: API
    let postId: Post.ID

    init(api: API, post: Post) {
        self.api = api
        self.postId = post.id
        self._state = .init(initialValue: State.loaded(.memory(post)))
    }

    lazy var cache = RepoCache<Post>(fileName: "post-\(self.postId.rawValue)")
    @Published var state: State

    func fetchPost(transitionToLoading: Bool = true, useCache: Bool = true) {
        if transitionToLoading {
            state = .loading(current: state.existing)
        }

        let apiCall = api.getPostWithUser(withID: postId)
            .map(Post.init(postWithUser:))

        cache.connecting(to: apiCall, useCache: useCache)
            .map({ State.loaded($0) })
            .catch({ Just(State.failed($0, dismissed: false, current: self.state.existing)) })
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }

    func refresh() {
        fetchPost(transitionToLoading: false, useCache: false)
    }

    deinit {
        print("deinit")
    }
}
