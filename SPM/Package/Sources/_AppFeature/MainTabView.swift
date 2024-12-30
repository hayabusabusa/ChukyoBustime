//
//  MainTabView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/30.
//

import ComposableArchitecture
import Shared
import SwiftUI
import _ToDestinationFeature

// MARK: - Reducer

@Reducer
public struct MainTabReducer {
    @ObservableState
    public struct State: Equatable {
        /// 選択中のタブ.
        public var selectedTab: Int = 0
        /// 浄水駅行きのタブに表示する画面の状態.
        public var toStationTab = ToDestinationReducer.State(busDestination: .toStation)
        /// 大学行きのタブに表示する画面の状態.
        public var toCollegeTab = ToDestinationReducer.State(busDestination: .toCollege)

        public init(
            selectedTab: Int = 0,
            toStationTab: ToDestinationReducer.State = ToDestinationReducer.State(busDestination: .toStation),
            toCollegeTab: ToDestinationReducer.State = ToDestinationReducer.State(busDestination: .toCollege)
        ) {
            self.selectedTab = selectedTab
            self.toStationTab = toStationTab
            self.toCollegeTab = toCollegeTab
        }
    }

    public enum Action {
        /// 選択中のタブ変更時の `Action`.
        case tabChanged(Int)
        /// 浄水駅行きのタブに表示する画面の `Action`.
        case toStationTab(ToDestinationReducer.Action)
        /// 大学行きのタブに表示する画面の `Action`.
        case toCollegeTab(ToDestinationReducer.Action)
    }

    public enum Tab {
        /// 浄水駅行きのタブ.
        case toStation
        /// 大学行きのタブ.
        case toCollege
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.toStationTab, action: \.toStationTab) {
            ToDestinationReducer()
        }
        Scope(state: \.toCollegeTab, action: \.toCollegeTab) {
            ToDestinationReducer()
        }
        Reduce { state, action in
            switch action {
            case let .tabChanged(index):
                state.selectedTab = index
                return .none

            case .toStationTab:
                return .none

            case .toCollegeTab:
                return .none
            }
        }
    }

    public init() {}
}

// MARK: - View

public struct MainTabView: View {
    @Perception.Bindable public var store: StoreOf<MainTabReducer>

    public var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab.sending(\.tabChanged)) {
                NavigationStack {
                    ToDestinationView(
                        store: store.scope(
                            state: \.toStationTab,
                            action: \.toStationTab
                        )
                    )
                }
                .tabItem {
                    Label(
                        "浄水駅行き",
                        systemImage: "tram.fill"
                    )
                }

                NavigationStack {
                    ToDestinationView(
                        store: store.scope(
                            state: \.toCollegeTab,
                            action: \.toCollegeTab
                        )
                    )
                }
                .tabItem {
                    Label(
                        "大学行き",
                        systemImage: "building.2.fill"
                    )
                }
            }
        }
    }

    public init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }
}

// MARK: - Preview

#Preview {
    MainTabView(
        store: Store(
            initialState: MainTabReducer.State(),
            reducer: {
                MainTabReducer()
            }
        )
    )
}
