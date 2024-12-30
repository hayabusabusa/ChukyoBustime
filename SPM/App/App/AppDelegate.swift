//
//  AppDelegate.swift
//  App
//
//  Created by Shunya Yamada on 2022/11/02.
//

import _AppFeature
import ComposableArchitecture
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store(initialState: AppReducer.State()) {
        AppReducer()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        store.send(.appDelegate(.didFinishLaunching))
        return true
    }
}

