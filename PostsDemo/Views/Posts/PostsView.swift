//
//  PostsView.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI

struct PostsView: View {
    @EnvironmentObject var router: Router

    @ObservedObject var repo: PostsRepo
    @State var isPullToRefreshShowing: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                List(repo.state.existing.value) { post in
                    NavigationLink(
                        destination: router.destination(route: .postDetails(post)),
                        label: {
                            PostCompactView(post: post)
                        })
                }
                .listStyle(InsetGroupedListStyle())
                .pullToRefresh(isShowing: $isPullToRefreshShowing) {
                    self.repo.refresh()
                }
                .onReceive(repo.objectWillChange, perform: { _ in
                    self.isPullToRefreshShowing = false
                })
                .onAppear { self.repo.fetchPosts() }
                // this will show the source of the data
                // (memory / cache / server),
                // only in debug mode
                .debugSourceTitle(repoState: repo.state)
                .navigationTitle("Posts")
                .alert(repoState: $repo.state, retry: {
                    self.repo.refresh()
                })

                if repo.state.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct PostCompactView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                Text(post.user.name)
                    .font(.caption)
                Text(post.user.company.name)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(post.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
            Text(post.body)
                .font(.body)
                .lineLimit(1)
        }.padding(.vertical)
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PostCompactView(post: .mock(1))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
