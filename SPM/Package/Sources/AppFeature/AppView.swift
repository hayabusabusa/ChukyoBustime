//
//  AppView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/30.
//

import ComposableArchitecture
import Shared
import SwiftUI
import ToDestinationFeature

// MARK: - Reducer

@Reducer
public struct AppReducer {
    @ObservableState
    public struct State: Equatable {
        /// `AppDelegate` の状態.
        public var appDelegate = AppDelegateReducer.State()

        public init(appDelegate: AppDelegateReducer.State = AppDelegateReducer.State()) {
            self.appDelegate = appDelegate
        }
    }

    public enum Action {
        /// `AppDelegate` の各種デリゲートを受け取るアクション.
        case appDelegate(AppDelegateReducer.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.appDelegate, action: \.appDelegate) {
            AppDelegateReducer()
        }
        Reduce { _, _ in
            return .none
        }
    }

    public init() {}
}

// MARK: - View

public struct AppView: View {
    @Perception.Bindable public var store: StoreOf<AppReducer>

    public var body: some View {
        MainTabView(
            store: Store(
                initialState: MainTabReducer.State(),
                reducer: {
                    MainTabReducer()
                }
            )
        )
    }

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
}

// MARK: - Preview

#Preview {
    AppView(
        store: Store(
            initialState: AppReducer.State(),
            reducer: {
                AppReducer()
            }
        )
    )
}
