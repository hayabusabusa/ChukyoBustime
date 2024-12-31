//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/14.
//

import Dependencies
import Firebase
import FirebaseClient
import Foundation

extension FirebaseClient: @retroactive DependencyKey {
    public static var liveValue: FirebaseClient {
        live()
    }

    private static func live() -> Self {
        .init {
            FirebaseApp.configure()
        }
    }
}
