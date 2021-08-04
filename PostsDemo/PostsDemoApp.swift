//
//  PostsDemoApp.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI

@main
struct PostsDemoApp: App {
    var body: some Scene {
        WindowGroup {
            PostsContainerView(repo: PostsRepo.main)
        }
    }
}
