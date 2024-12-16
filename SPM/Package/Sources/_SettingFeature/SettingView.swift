//
//  SettingView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/15.
//

import ComposableArchitecture
import SharedView
import SwiftUI
import UserDefaultsClient

// MARK: - Reducer

@Reducer
public struct SettingReducer {
    @Reducer(state: .equatable)
    public enum Destination {
        /// アラートを表示する.
        case alert(AlertState<Alert>)
        /// 外部 Web ページを表示する.
        case safariView(SafariReducer)

        @CasePathable
        public enum Alert {
            /// 初回起動時に開くタブのアラート.
            case toggleInitialTab
        }
    }

    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        /// 初回起動時に開くタブ.
        public var initialTab: Int = 0
        /// アプリのバージョン.
        public var version: String = ""

        public init(
            destination: Destination.State? = nil,
            initialTab: Int = 0,
            version: String = ""
        ) {
            self.destination = destination
            self.initialTab = initialTab
            self.version = version
        }
    }

    public enum Action {
        /// このアプリについての項目タップ時の Action.
        case aboutButtonTapped
        /// 閉じるボタンタップ時の Action.
        case dismissButtonTapped
        /// 画面遷移の Action.
        case destination(PresentationAction<Destination.Action>)
        /// 利用規約の項目タップ時の Action.
        case disclaimerButtonTapped
        /// View 側の `.task` 実行時の Action.
        case task
        /// プライバシーポリシーの項目タップ時の Action.
        case privacyPolicyButtonTapped
        /// 起動時に表示する項目タップ時の Action.
        case toggleInitialTabButtonTapped
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .aboutButtonTapped:
                guard let url = URL(string: "https://chukyo-bustime-app.web.app") else {
                    return .none
                }
                state.destination = .safariView(
                    SafariReducer.State(url: url)
                )
                return .none

            case .dismissButtonTapped:
                return .run { _ in
                    await dismiss()
                }

            case .destination:
                return .none

            case .disclaimerButtonTapped:
                guard let url = URL(string: "https://chukyo-bustime-app.web.app/#/precautions") else {
                    return .none
                }
                state.destination = .safariView(
                    SafariReducer.State(url: url)
                )
                return .none

            case .task:
                // 値がない場合は初期値として `0` を設定する.
                let initialTab = userDefaultsClient.initialTab ?? 0
                // 基本的には `Bundle` からバージョンを取れるものとする.
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"

                state.version = version
                state.initialTab = initialTab
                return .none

            case .privacyPolicyButtonTapped:
                guard let url = URL(string: "https://chukyo-bustime-app.web.app/#/privacy-policy") else {
                    return .none
                }
                state.destination = .safariView(
                    SafariReducer.State(url: url)
                )
                return .none

            case .toggleInitialTabButtonTapped:
                let toggledInitialTab = state.initialTab == 0 ? 1 : 0
                let toggledInitialTabText = toggledInitialTab == 0 ? "浄水駅行き" : "大学行き"
                // 変更後の値を保存.
                userDefaultsClient.setInitialTab(toggledInitialTab)
                state.initialTab = toggledInitialTab
                state.destination = .alert(
                    AlertState {
                        TextState("設定完了")
                    } message: {
                        TextState("起動時に表示する画面を\n\(toggledInitialTabText) の画面に設定しました。")
                    }
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
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
                        store.send(.toggleInitialTabButtonTapped)
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
                        store.send(.aboutButtonTapped)
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
                        store.send(.disclaimerButtonTapped)
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
                        store.send(.privacyPolicyButtonTapped)
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
            .task {
                store.send(.task)
            }
            .fullScreenCover(
                item: $store.scope(
                    state: \.destination?.safariView,
                    action: \.destination.safariView
                )
            ) { store in
                SafariView(store: store)
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        store.send(.dismissButtonTapped)
                    }
                }
            }
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
    NavigationStack {
        SettingView(
            store: Store(
                initialState: SettingReducer.State(),
                reducer: {
                    SettingReducer()
                }
            )
        )
    }
}
