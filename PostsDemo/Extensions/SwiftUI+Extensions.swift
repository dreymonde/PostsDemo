//
//  SwiftUI+Extensions.swift
//  PostsDemo
//
//  Created by Oleg Dreyman on 04.08.2021.
//

import SwiftUI

extension View {
    func alert<RepoValue>(repoState: Binding<GuaranteedRepoState<RepoValue>>, retry: @escaping () -> ()) -> some View {
        alert(isPresented: repoState.hasUndismissedError) {
            Alert(
                title: Text(repoState.wrappedValue.error ?? "An error occured"),
                message: Text("Do you want to retry?"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .default(Text("Retry")) {
                    retry()
                })
        }

    }
}

extension View {
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
        #if DEBUG
        return modifier(self)
        #else
        return self
        #endif
    }

    func debugSourceTitle<Value>(repoState: GuaranteedRepoState<Sourceful<Value>>) -> some View {
        debugModifier({ $0.navigationTitle(repoState.existing.source.debugDescription) })
    }
}
