//
//  Router.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    let api: API
    let mainRepo: PostsRepo

    init(api: API) {
        self.api = api
        self.mainRepo = PostsRepo(api: api)
    }

    enum DestinationRoute {
        case postDetails(Post)
        case main
    }

    @ViewBuilder
    func destination(route: DestinationRoute) -> some View {
        switch route {
        case .main:
            PostsView(repo: self.mainRepo)
                .environmentObject(self)
        case .postDetails(let post):
            PostDetailsView(repo: PostRepo(api: self.api, post: post))
        }
    }
}
