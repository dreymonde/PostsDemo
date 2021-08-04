//
//  PostDetailsView.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI
import NukeUI
import SwiftUIRefresh

struct PostDetailsView: View {
    @StateObject var repo: PostRepo
    @State var isPullToRefreshShowing: Bool = false

    var body: some View {
        List {
            UserBlockView(user: repo.state.existing.value.user)
                .padding()
                .buttonStyle(PlainButtonStyle())
            PostBlockView(post: repo.state.existing.value)
                .padding()
                .buttonStyle(PlainButtonStyle())
        }
        .pullToRefresh(isShowing: $isPullToRefreshShowing, onRefresh: {
            self.repo.refresh()
        })
        .onReceive(repo.objectWillChange, perform: { _ in
            self.isPullToRefreshShowing = false
        })
        // this will show the source of the data
        // (memory / cache / server),
        // only in debug mode
        .debugSourceTitle(repoState: repo.state)
        .navigationTitle("Post")
        .opacity(repo.state.existing.source.isLatest ? 1.0 : 0.7)
        .onAppear { repo.fetchPost() }
        .alert(repoState: $repo.state, retry: {
            self.repo.refresh()
        })
    }
}

struct UserBlockView: View {

    let user: User

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            LazyImage(source: user.photoURL)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.body)
                    .fontWeight(.semibold)
                Link(user.email, destination: LinkService.emailURL(user: user))
                    .foregroundColor(.blue)
                Link(user.address.localized, destination: LinkService.gmapsURL(geo: user.address.geo))
                    .foregroundColor(.blue)
                Link(user.phone, destination: LinkService.callPhoneURL(user: user))
                    .foregroundColor(.blue)
                Text(user.company.name)
            }
            Spacer()
        }
    }
}

struct PostBlockView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title)
                .font(.title2)
                .fontWeight(.bold)
            Text(post.body)
        }
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsView(repo: .init(api: .main, post: .mock(1)))
    }
}
