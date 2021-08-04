//
//  PostsView.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI

struct PostsView: View {
    let posts: Sourceful<[Post]>
    @Binding var isPullToRefreshShowing: Bool
    let onRefresh: () -> ()

    var body: some View {
        NavigationView {
            List(posts.value) { post in
                NavigationLink(
                    destination: PostDetailsView(post: post),
                    label: {
                        PostCompactView(post: post)
                    })
            }
            .pullToRefresh(isShowing: $isPullToRefreshShowing, onRefresh: onRefresh)
            .navigationTitle("Posts")
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
//            PostsView(posts: [.mock(1), .mock(2), .mock(3)], isPullToRefreshShowing: .init(get: { false }, set: { _ in }), onRefresh: { })
            PostCompactView(post: .mock(1))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
