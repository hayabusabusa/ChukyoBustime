//
//  SettingView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/15.
//

import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

// MARK: - Reducer

@Reducer
public struct SettingReducer {
    @ObservableState
    public struct State: Equatable {
        /// 初回起動時に開くタブ.
        public var initialTab: Int = 0
        /// アプリのバージョン.
        public var version: String?

        public init(
            initialTab: Int = 0,
            version: String? = nil
        ) {
            self.initialTab = initialTab
            self.version = version
        }
    }

    public enum Action {
        /// View 側の `.task` 実行時の Action.
        case task
    }

    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                // 値がない場合は初期値として `0` を設定する.
                let initialTab = userDefaultsClient.initialTab ?? 0
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

                state.version = version
                state.initialTab = initialTab
                return .none
            }
        }
    }

    public init() {}
}

// MARK: - View

public struct SettingView: View {
    @Perception.Bindable var store: StoreOf<SettingReducer>

    public var body: some View {
        WithPerceptionTracking {
            Text("Setting")
        }
    }

    public init(store: StoreOf<SettingReducer>) {
        self.store = store
    }
}
