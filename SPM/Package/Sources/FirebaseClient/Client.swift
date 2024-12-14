//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/14.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct FirebaseClient {
    /// `Firebase` の初期化を行う.
    public var configure: @Sendable () -> Void
}

// MARK: - Dependency

extension FirebaseClient: TestDependencyKey {
    public static var previewValue: FirebaseClient {
        .init {
            // 何もしない.
        }
    }

    public static var testValue: FirebaseClient = Self.init()
}

extension DependencyValues {
    public var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}
