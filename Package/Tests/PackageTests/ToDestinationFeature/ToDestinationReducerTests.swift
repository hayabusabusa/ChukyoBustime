//
//  ToDestinationReducerTests.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/02.
//

import ComposableArchitecture
import Foundation
import Shared
import Testing
@testable import ToDestinationFeature

@MainActor
struct ToDestinationReducerTests {
    @Test
    func busListButtonTapped() async {
        // 現在時刻から 30 分後のデータで確認する.
        let store = TestStore(
            initialState: ToDestinationReducer.State(
                busTimes: [
                    BusTime(
                        hour: 12,
                        minute: 30,
                        second: 45000,
                        arrivalHour: 13,
                        arrivalMinute: 00,
                        arrivalSecond: 46800,
                        isReturn: false,
                        isLast: false,
                        isKaizu: false
                    )
                ],
                busDestination: .toStation
            )
        ) {
            ToDestinationReducer()
        } withDependencies: {
            $0.date.now = {
                // 現在時刻を `2025/01/01 12:00` で固定する.
                .testValue
            }()
            $0.userNotificationClient.authorize = {
                // 何もしない.
            }
            $0.userNotificationClient.addNotification = { @Sendable _ in
                // 何もしない.
            }
            $0.userNotificationClient.removeAllNotifications = {
                // 何もしない.
            }
        }

        await store.send(.busListButtonTapped(0))
        await store.receive(\.notificationResponse.success) {
            $0.destination = .alert(
                AlertState {
                    TextState("")
                } message: {
                    TextState("12:30 の5分前に\n通知が来るように設定しました。")
                }
            )
        }
    }

    @Test
    func busListButtonTappedOverFiveMinute() async {
        // 現在時刻から 1 分後のデータで確認する.
        let store = TestStore(
            initialState: ToDestinationReducer.State(
                busTimes: [
                    BusTime(
                        hour: 12,
                        minute: 1,
                        second: 43260,
                        arrivalHour: 13,
                        arrivalMinute: 00,
                        arrivalSecond: 46800,
                        isReturn: false,
                        isLast: false,
                        isKaizu: false
                    )
                ],
                busDestination: .toStation
            )
        ) {
            ToDestinationReducer()
        } withDependencies: {
            $0.date.now = {
                // 現在時刻を `2025/01/01 12:00` で固定する.
                .testValue
            }()
            $0.userNotificationClient.authorize = {
                // 何もしない.
            }
            $0.userNotificationClient.addNotification = { @Sendable _ in
                // 何もしない.
            }
            $0.userNotificationClient.removeAllNotifications = {
                // 何もしない.
            }
        }

        await store.send(.busListButtonTapped(0)) {
            $0.destination = .alert(
                AlertState {
                    TextState("エラー")
                } message: {
                    TextState("すでに5分前の時間を過ぎています")
                }
            )
        }
    }
}
