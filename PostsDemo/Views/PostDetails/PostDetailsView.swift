//
//  PostDetailsView.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI
import NukeUI

struct PostDetailsView: View {
    let post: Post

    var body: some View {
        ScrollView {
            UserBlockView(user: post.user)
                .padding()
            PostBlockView(post: post)
                .padding()
        }
        .padding(.top, 1)
        .navigationTitle("Post")
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
                Link(user.address.localized, destination: LinkService.gmapsURL(geo: user.address.geo))
                Link(user.phone, destination: LinkService.callPhoneURL(user: user))
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
        PostDetailsView(post: .mock(1))
    }
}
