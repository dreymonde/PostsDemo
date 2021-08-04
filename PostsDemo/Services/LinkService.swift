//
//  LinkService.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation

enum LinkService {

    static func emailURL(user: User) -> URL {
        return URL(string: "mailto:\(user.email)")!
    }

    static func gmapsURL(geo: User.Address.Geo) -> URL {
        return URL(string: "https://www.google.com/maps/search/?api=1&query=\(geo.lat),\(geo.lng)")!
    }

    static func callPhoneURL(user: User) -> URL {
        let cleanPhoneNumber = user.phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let urlString = "telprompt://\(cleanPhoneNumber)"
        return URL(string: urlString)!
    }
}
