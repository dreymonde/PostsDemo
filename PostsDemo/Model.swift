//
//  Model.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation

typealias User = API.User

struct Post: Codable, Hashable, Identifiable {
    typealias ID = API.Post.ID

    var id: ID
    var user: User
    var title: String
    var body: String
}

extension Post {
    init(postWithUser: API.PostWithUser) {
        self.init(
            id: postWithUser.id,
            user: postWithUser.author,
            title: postWithUser.post.title,
            body: postWithUser.post.body
        )
    }
}

extension User {
    var photoURL: URL? {
        API.userPhotoURL(userID: id)
    }
}

// MARK: - Mocks

extension User {
    static var mock1: User {
        User(id: .init(rawValue: 1),
             name: "Leanne Graham",
             username: "Bret",
             email: "bret@april.biz",
             address: .init(street: "Kulas Light",
                            suite: "Apt. 556",
                            city: "Gwenborough",
                            zipcode: "9299-121",
                            geo: .init(lat: "-37.3159", lng: "81.1496")),
             phone: "1-770-736-8031 x56642",
             website: "hilda.com",
             company: .init(name: "Romaguera",
                            catchPhrase: "We do stuff",
                            bs: "this-that-there")
        )
    }
}

extension Post {
    static func mock(_ id: Int) -> Post {
        Post(id: .init(rawValue: id),
             user: .mock1,
             title: "this is post 1",
             body: "Australia have grown into the contest over the past few minutes, just as Sweden looked to be turning the screw. There’s still no cohesion going forward, but they are at least seeing more of the ball after a long spell of Swedish dominance. There’s a welcome break in play for both coaches while Raso is attended to after having her hand trodden on by Rolfo.")
    }
}
