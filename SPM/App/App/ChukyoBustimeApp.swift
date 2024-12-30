//
//  ChukyoBustimeApp.swift
//  App
//
//  Created by Shunya Yamada on 2024/12/30.
//

import AppFeature
import ComposableArchitecture
import SwiftUI

@main
struct ChukyoBustimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: appDelegate.store)
        }
    }
}
