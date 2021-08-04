//
//  Combine+Extensions.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import Combine
import Foundation

extension Publisher {
    #if DEBUG
    func debugModifier<T>(_ modifier: (Self) -> T) -> T {
        modifier(self)
    }
    #else
    func debugModifier<T>(_ modifier: (Self) -> T) -> Self {
        self
    }
    #endif
}

extension Publisher {
    func debugDelay<S: Scheduler>(for interval: S.SchedulerTimeType.Stride, scheduler: S) -> Publishers.Delay<Self, S> {
        debugModifier { pub in
            pub.delay(for: interval, scheduler: scheduler)
        }
    }
}
