//
//  CountdownView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/17.
//

import ComposableArchitecture
import Shared
import SwiftUI
import SwiftDate

// MARK: - Reducer

@Reducer
public struct CountdownReducer {
    @ObservableState
    public struct State: Equatable {
        /// カウントダウンする時刻表のデータ.
        public var busTime: BusTime? = nil
        /// 行先.
        public var destination: BusDestination? = nil
        /// バス出発までのカウントダウン用の秒数.
        public var secondsUntilDeparture = 0

        public init(
            busTime: BusTime? = nil,
            destination: BusDestination? = nil,
            secondsUntilDeparture: Int = 0
        ) {
            self.busTime = busTime
            self.destination = destination
            self.secondsUntilDeparture = secondsUntilDeparture
        }
    }

    public enum Action {
        /// 親 `Reducer` で次発のバスが変更された時の `Action`.
        case busTimePopped
        /// 親 `Reducer` への通知用の `Action`.
        case delegate(Delegate)
        /// View の `task` 実行時の `Action`.
        case task
        /// タイマー動作中の `Action`.
        case timerTicked

        @CasePathable
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
    @Dependency(\.date) var dateGenerator

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .busTimePopped:
                guard let busTime = state.busTime else {
                    return .none
                }
                // 次発バスの出発時間までの秒数をカウントを計算し直す.
                let interval = intervalUntil(busTime: busTime)
                state.secondsUntilDeparture = interval
                return .none

            case .delegate:
                return .none

            case .task:
                // タイマーを開始させておく.
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

private extension CountdownReducer {
    /// 次発バスの出発時間までの秒数を返す.
    /// - Parameter busTime: 次発バスのデータ.
    /// - Returns: 次発バス出発までの秒数.
    func intervalUntil(busTime: BusTime) -> Int {
        let now = DateInRegion(
            dateGenerator.now,
            region: .current
        )
        let nowSecond = now.hour * 3600 + now.minute * 60 + now.minute
        return busTime.second - nowSecond
    }
}

// MARK: - View

/// カウントダウン部分の `View`.
public struct CountdownView: View {
    private let formatter = DateComponentsFormatter()

    @Perception.Bindable var store: StoreOf<CountdownReducer>

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                if let busTime = store.busTime {
                    // 運行のフラグがどれか立っていたら表示する.
                    if [busTime.isLast, busTime.isKaizu, busTime.isReturn].contains(true) {
                        HStack {
                            if busTime.isLast {
                                OutlinedText(text: "最終バス")
                            }
                            if busTime.isReturn {
                                OutlinedText(text: "折り返し")
                            }
                            if busTime.isKaizu {
                                OutlinedText(text: "貝津経由")
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .trailing
                        )
                    }

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

                    if let destination = store.destination {
                        HStack {
                            BusStopView(
                                timeText: String(
                                    format: "%i:%02i",
                                    busTime.hour,
                                    busTime.minute
                                ),
                                systemImageName: destination == .toCollege ? "building.2.fill" : "tram.fill",
                                destinationText: destination == .toCollege ? "大学発" : "浄水駅発"
                            )

                            Spacer()

                            BusStopView(
                                timeText: String(
                                    format: "%i:%02i",
                                    busTime.arrivalHour,
                                    busTime.arrivalMinute
                                ),
                                systemImageName: destination == .toCollege ? "tram.fill" : "building.2.fill",
                                destinationText: destination == .toCollege ? "浄水駅着" : "大学着"
                            )
                        }
                    }
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

    public init(store: StoreOf<CountdownReducer>) {
        self.store = store
    }
}

private extension CountdownView {
    /// 経過秒数を `HH:mm` のフォーマットに変換する.
    /// - Parameter secondsElapsed: 経過秒数.
    /// - Returns: `HH:mm` にフォーマットした文字列.
    func format(secondsElapsed: Int) -> String {
        formatter.unitsStyle = .positional
        // 1 時間以上の場合はフォーマットを `hh:mm:ss` に変える.
        formatter.allowedUnits = secondsElapsed >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(secondsElapsed)) ?? "00:00"
    }
}

// MARK: - Preview

#Preview {
    CountdownView(
        store: Store(
            initialState: CountdownReducer.State(
                busTime: .init(
                    hour: 23,
                    minute: 59,
                    second: 86340,
                    arrivalHour: 24,
                    arrivalMinute: 0,
                    arrivalSecond: 86400,
                    isReturn: false,
                    isLast: true,
                    isKaizu: true
                ),
                destination: .toCollege,
                secondsUntilDeparture: 600
            ),
            reducer: {
                CountdownReducer()
            }
        )
    )
    .frame(height: 200)
}
