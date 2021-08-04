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
        case .loading:
            ProgressView()
        case .loaded(let posts):
            PostsView(posts: posts, isPullToRefreshShowing: $isPullToRefreshShowing) {
                self.refresh()
            }
        case .failed(let error):
            Text(String(describing: error))
        }
    }

    func fetch() {
        repo.fetchPosts()
    }

    func refresh() {
        repo.fetchPosts(transitioningToLoading: true)
    }
}

struct PostsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PostsContainerView(repo: .main)
    }
}
