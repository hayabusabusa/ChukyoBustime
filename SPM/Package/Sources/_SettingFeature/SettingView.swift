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
        public var version: String = ""

        public init(
            initialTab: Int = 0,
            version: String = ""
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
                // 基本的には `Bundle` からバージョンを取れるものとする.
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"

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
            List {
                Section(
                    header: Text("アプリの設定")
                ) {
                    Button {
                        // TODO: アラートで切り替え
                    } label: {
                        HStack {
                            Text("起動時に表示")
                                .foregroundColor(
                                    Color(UIColor.label)
                                )
                            Spacer()
                            Text(store.state.initialTabText)
                                .foregroundColor(.blue)
                        }
                    }
                }

                Section(
                    header: Text("このアプリについて")
                ) {
                    HStack {
                        Text("バージョン")
                            .foregroundColor(
                                Color(UIColor.label)
                            )
                        Spacer()
                        Text(store.state.version)
                            .foregroundColor(.gray)
                    }

                    Button {
                        // TODO: WebView を表示
                    } label: {
                        HStack {
                            Text("このアプリについて")
                                .foregroundColor(
                                    Color(UIColor.label)
                                )
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(
                                    Color(UIColor.systemGray2)
                                )
                        }
                    }

                    Button {
                        // TODO: WebView を表示
                    } label: {
                        HStack {
                            Text("利用上の注意")
                                .foregroundColor(
                                    Color(UIColor.label)
                                )
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(
                                    Color(UIColor.systemGray2)
                                )
                        }
                    }

                    Button {
                        // TODO: WebView を表示
                    } label: {
                        HStack {
                            Text("プライバシーポリシー")
                                .foregroundColor(
                                    Color(UIColor.label)
                                )
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(
                                    Color(UIColor.systemGray2)
                                )
                        }
                    }
                }
            }
        }
        .task {
            store.send(.task)
        }
    }

    public init(store: StoreOf<SettingReducer>) {
        self.store = store
    }
}

extension SettingReducer.State {
    /// アプリ起動時に開くタブの名称.
    fileprivate var initialTabText: String {
        initialTab == 0 ? "浄水駅行き" : "大学行き"
    }
}

// MARK: - Preview

#Preview {
    SettingView(
        store: Store(
            initialState: SettingReducer.State(),
            reducer: {
                SettingReducer()
            }
        )
    )
}
