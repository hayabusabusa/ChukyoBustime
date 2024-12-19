//
//  CountdownView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/17.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Reducer

@Reducer
public struct ContdownReducer {
    @ObservableState
    public struct State: Equatable {
        /// バス出発までのカウントダウン用の秒数.
        public var secondsUntilDeparture = 0

        public init(secondsUntilDeparture: Int = 0) {
            self.secondsUntilDeparture = secondsUntilDeparture
        }
    }

    public enum Action {
        /// 親 `Reducer` への通知用の `Action`.
        case delegate(Delegate)
        /// View の `task` 実行時の `Action`.
        case task
        /// タイマー動作中の `Action`.
        case timerTicked

        public enum Delegate {
            /// タイマーのカウントが `0` になった時の `Action`.
            case isTimeRunningUp
        }
    }

    private enum CancelID {
        /// タイマー用のキャンセル ID.
        case timer
    }

    @Dependency(\.continuousClock) var clock

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case .task:
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(
                    id: CancelID.timer,
                    cancelInFlight: true
                )

            case .timerTicked:
                state.secondsUntilDeparture -= 1
                // カウントが完了したら親 Reducer に通知する.
                if state.secondsUntilDeparture <= 0 {
                    return .send(.delegate(.isTimeRunningUp))
                }

                return .none
            }
        }
    }

    public init() {}
}

// MARK: - View

/// カウントダウン部分の `View`.
public struct CountdownView: View {
    private let formatter = DateComponentsFormatter()

    @Perception.Bindable var store: StoreOf<ContdownReducer>

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                HStack {
                    OutlinedText(text: "最終バス")
                    OutlinedText(text: "折り返し")
                    OutlinedText(text: "貝津経由")
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .trailing
                )

                Spacer()

                Group {
                    Text("出発まであと")
                        .font(.system(size: 12))
                    Text(format(secondsElapsed: store.state.secondsUntilDeparture))
                        .font(
                            Font(
                                UIFont.monospacedDigitSystemFont(
                                    ofSize: 40,
                                    weight: .bold
                                )
                            )
                        )
                }

                Spacer()

                HStack {
                    BusStopView(
                        timeText: "00:00",
                        systemImageName: "tram.fill",
                        destinationText: "大学発"
                    )

                    Spacer()

                    BusStopView(
                        timeText: "00:00",
                        systemImageName: "tram.fill",
                        destinationText: "浄水駅着"
                    )
                }
            }
            .padding(
                EdgeInsets(
                    top: 12,
                    leading: 16,
                    bottom: 12,
                    trailing: 16
                )
            )
            .background(Color(.secondarySystemGroupedBackground))
            .task {
                store.send(.task)
            }
        }
    }

    public init(store: StoreOf<ContdownReducer>) {
        self.store = store
    }
}

private extension CountdownView {
    /// 経過秒数を `HH:mm` のフォーマットに変換する.
    /// - Parameter secondsElapsed: 経過秒数.
    /// - Returns: `HH:mm` にフォーマットした文字列.
    func format(secondsElapsed: Int) -> String {
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(secondsElapsed)) ?? "00:00"
    }
}

// MARK: - Preview

#Preview {
    CountdownView(
        store: Store(
            initialState: ContdownReducer.State(
                secondsUntilDeparture: 60
            ),
            reducer: {
                ContdownReducer()
            }
        )
    )
    .frame(height: 200)
}
