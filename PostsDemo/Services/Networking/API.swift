//
//  API.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation
import Combine

final class API {
    
    enum BaseURL {
        case typicode

        var url: URL {
            switch self {
            case .typicode:
                return URL(string: "https://jsonplaceholder.typicode.com/")!
            }
        }
        
        static let main = typicode
    }
    
    static let main = API(network: Network(urlSession: .shared, baseURL: BaseURL.main.url))
    
    let network: Network
    
    init(network: Network) {
        self.network = network
    }

    init(baseURL: BaseURL) {
        #if DEBUG
        self.network = .init(urlSession: .init(configuration: .ephemeral), baseURL: baseURL.url)
        #else
        self.network = .init(urlSession: .shared, baseURL: baseURL.url)
        #endif
    }
}

// MARK: - Posts

extension API {
    struct Post: Codable, Hashable {
        var id: ID
        var userId: API.User.ID
        var title: String
        var body: String

        struct ID: Identifier { var rawValue: Int }
    }

    func getPosts() -> AnyPublisher<[Post], Error> {
        network.httpGet([Post].self, path: "posts")
    }

    func getPost(withID id: Post.ID) -> AnyPublisher<Post, Error> {
        network.httpGet(Post.self, path: "posts/\(id.rawValue)")
    }
}

extension API.Post: Identifiable { }

// MARK: - User

extension API {
    struct User: Codable, Hashable {
        var id: ID
        var name: String
        var username: String
        var email: String
        var address: Address
        var phone: String
        var website: String
        var company: Company

        struct ID: Identifier { var rawValue: Int }

        struct Address: Codable, Hashable {
            var street: String
            var suite: String
            var city: String
            var zipcode: String
            var geo: Geo

            struct Geo: Codable, Hashable {
                var lat: String
                var lng: String
            }

            var localized: String {
                "\(street), \(suite), \(city), \(zipcode)"
            }
        }

        struct Company: Codable, Hashable {
            var name: String
            var catchPhrase: String
            var bs: String
        }
    }

    func getUser(withID id: User.ID) -> AnyPublisher<User, Error> {
        network.httpGet(User.self, path: "users/\(id.rawValue)")
    }
}

extension API.User: Identifiable { }

// MARK: - Posts & Users Joined

extension API {
    struct PostWithUser: Codable, Hashable {
        var post: Post
        var author: User
    }

    func getPostsWithUsers() -> AnyPublisher<[PostWithUser], Error> {
        getPosts()
            .flatMap(populatePosts)
            .eraseToAnyPublisher()
    }

    private func populatePosts(posts: [Post]) -> AnyPublisher<[PostWithUser], Error> {
        getUsersMap(posts: posts)
            .map { userMap in
                return posts.compactMap { post in
                    userMap[post.userId].map({ PostWithUser(post: post, author: $0) })
                }
            }
            .eraseToAnyPublisher()
    }

    private func getUser(post: Post) -> AnyPublisher<User, Error> {
        getUser(withID: post.userId)
            .eraseToAnyPublisher()
    }

    private func getUsersMap(posts: [Post]) -> AnyPublisher<[User.ID: User], Error> {
        posts
            .publisher
            .flatMap(getUser)
            .collect()
            .map(makeMap(from:))
            .eraseToAnyPublisher()
    }

    private func makeMap(from users: [User]) -> [User.ID: User] {
        // I don't like this approach, but
        // with simply using flatMap & collect,
        // the order of the posts array was not preserved
        return Dictionary(users.map({ (key: $0.id, value: $0) }), uniquingKeysWith: { $1 })
    }

    // MARK: Post with User

    func getPostWithUser(withID postId: Post.ID) -> AnyPublisher<PostWithUser, Error> {
        getPost(withID: postId)
            .flatMap(self.populatePost(post:))
            .eraseToAnyPublisher()
    }

    private func populatePost(post: Post) -> AnyPublisher<PostWithUser, Error> {
        getUser(post: post)
            .map({ PostWithUser(post: post, author: $0) })
            .eraseToAnyPublisher()
    }
}

extension API.PostWithUser: Identifiable {
    var id: API.Post.ID { post.id }
}

// MARK: - Photo URL

extension API {
    static func userPhotoURL(userID: User.ID) -> URL? {
        return URL(string: "https://source.unsplash.com/collection/542909/?sig=\(userID.rawValue)")
    }
}
