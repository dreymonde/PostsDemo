//
//  APITests.swift
//  PostsDemoTests
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import XCTest
@testable import PostsDemo

class APITests: XCTestCase {

    let api = API(network: .init(urlSession: .init(configuration: .ephemeral), baseURL: API.BaseURL.main.url))

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPostsParsed() throws {
        let allPosts = try devAwait(api.getPosts())
        dump(allPosts)
        XCTAssertTrue(!allPosts.isEmpty)

        XCTAssertEqual(allPosts, try encodeAndDecode(allPosts))
    }

    func testGetUserParsed() throws {
        // will fail if parsing fails
        let user1 = try devAwait(api.getUser(withID: .init(rawValue: 2)))
        dump(user1)

        XCTAssertEqual(user1, try encodeAndDecode(user1))
    }

    func testGetPostParsed() throws {
        let post1 = try devAwait(api.getPost(withID: .init(rawValue: 1)))
        dump(post1)

        XCTAssertEqual(post1, try encodeAndDecode(post1))
    }

    func testGetPopulatedPosts() throws {
        let allPosts = try devAwait(api.getPosts())

        let allPopulatedPosts = try devAwait(api.getPostsWithUsers())
        dump(allPosts)

        XCTAssertEqual(allPosts.count, allPopulatedPosts.count)
        XCTAssertEqual(allPosts, allPopulatedPosts.map(\.post))
        XCTAssertEqual(allPopulatedPosts, try encodeAndDecode(allPopulatedPosts))
    }

    func testUserPhotoURL() throws {
        let imageURL = API.userPhotoURL(userID: .init(rawValue: 5))
        XCTAssertEqual(imageURL, URL(string: "https://source.unsplash.com/collection/542909/?sig=5"))
    }
}

extension APITests {
    func encodeAndDecode<T: Codable>(_ value: T) throws -> T {
        let encoded = try JSONEncoder().encode(value)
        return try JSONDecoder().decode(T.self, from: encoded)
    }
}
