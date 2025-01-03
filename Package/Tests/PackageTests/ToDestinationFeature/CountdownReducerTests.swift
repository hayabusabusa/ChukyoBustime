//
//  CountdownReducerTests.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/01.
//

import ComposableArchitecture
import Foundation
import Shared
import Testing
@testable import ToDestinationFeature

@MainActor
struct CountdownReducerTests {
    @Test
    func busTimePopped() async {
        // 出発時刻を `2025/01/01 12:01` にしたデータで確認する.
        let store = TestStore(
            initialState: CountdownReducer.State(
                busTime: BusTime(
                    hour: 12,
                    minute: 1,
                    second: 43260,
                    arrivalHour: 12,
                    arrivalMinute: 30,
                    arrivalSecond: 45000,
                    isReturn: false,
                    isLast: false,
                    isKaizu: false
                ),
                destination: .toStation
            )
        ) {
            CountdownReducer()
        } withDependencies: {
            $0.date.now = {
                // 現在時刻を `2025/01/01 12:00` で固定する.
                .testValue
            }()
        }

        await store.send(.busTimePopped) {
            $0.secondsUntilDeparture = 60
        }
    }

    @Test
    func task() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: CountdownReducer.State(
                secondsUntilDeparture: 2
            )
        ) {
            CountdownReducer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        // `for await` で `AsyncStream` になっているため `Task` を保持する.
        let task = await store.send(.task)

        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTicked) {
            $0.secondsUntilDeparture = 1
        }

        // 保持したタイマーの `Task` をキャンセルする.
        await task.cancel()
        // タイマーの `Task` キャンセル後にイベントを受け取っても処理されないことを確認.
        await clock.advance(by: .seconds(1))
    }

    @Test
    func timerTicked() async {
        let store = TestStore(
            initialState: CountdownReducer.State(
                secondsUntilDeparture: 2
            )
        ) {
            CountdownReducer()
        }

        await store.send(.timerTicked) {
            $0.secondsUntilDeparture = 1
        }
        await store.send(.timerTicked) {
            $0.secondsUntilDeparture = 0
        }
        // タイマーのカウントが完了した場合のイベントを受け取れるか確認.
        await store.receive(\.delegate.isTimeRunningUp)
    }
}
