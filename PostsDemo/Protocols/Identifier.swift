//
//  Identifier.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 02.08.2021.
//

import Foundation

protocol Identifier: FlatType, Hashable {
    init(rawValue: RawValue)
}
