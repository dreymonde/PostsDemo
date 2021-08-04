//
//  PostsContainerView.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI
import SwiftUIRefresh

struct PostsContainerView: View {
    @ObservedObject var repo: PostsRepo
    @State var isPullToRefreshShowing: Bool = false

    var body: some View {
        switch repo.state {
        case .idle:
            Color.clear.onAppear(perform: fetch)
        case .loading(let existing):
            if let existing = existing {
                ZStack {
                    PostsView(posts: existing, isPullToRefreshShowing: .constant(true), onRefresh: { })
                        .opacity(0.2)
                    ProgressView()
                }
            } else {
                ProgressView()
            }
        case .loaded(let posts):
            PostsView(posts: posts, isPullToRefreshShowing: $isPullToRefreshShowing) {
                self.refresh()
            }
            .opacity(posts.source == .latest ? 1.0 : 0.2)
            .disabled(posts.source == .cache)
            .onAppear { self.isPullToRefreshShowing = false }
        case .failed(let error):
            Text(String(describing: error))
        }
    }

    func fetch() {
        repo.fetchPosts()
    }

    func refresh() {
        repo.fetchPosts(transitioningToLoading: true, useCache: false)
    }
}

struct PostsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PostsContainerView(repo: .main)
    }
}
