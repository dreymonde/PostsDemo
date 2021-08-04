//
//  PostsDemoApp.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import SwiftUI

@main
struct PostsDemoApp: App {
    let router = Router(api: .main)

    var body: some Scene {
        WindowGroup {
            router.destination(route: .main)
        }
    }
}
