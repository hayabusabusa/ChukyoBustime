//
//  SettingReducerTests.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/01.
//

import ComposableArchitecture
import SharedView
import XCTest
@testable import SettingFeature

@MainActor
final class SettingReducerTests: XCTestCase {
    func testAboutButtonTapped() async {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        }

        await store.send(.aboutButtonTapped) {
            $0.destination = .safariView(
                SafariReducer.State(
                    url: URL(
                        string: "https://chukyo-bustime-app.web.app"
                    )!
                )
            )
        }
    }

    func testDisclaimerButtonTapped() async {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        }

        await store.send(.disclaimerButtonTapped) {
            $0.destination = .safariView(
                SafariReducer.State(
                    url: URL(
                        string: "https://chukyo-bustime-app.web.app/#/precautions"
                    )!
                )
            )
        }
    }

    func testTask() async {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        } withDependencies: {
            $0.userDefaultsClient.integer = { _ in
                0
            }
        }

        await store.send(.task) {
            // `version` は `Bundle.main` に依存しているため本来と違う値で比較する.
            $0.version = "16.0"
            $0.initialTab = 0
        }
    }

    func testPrivacyPolicyButtonTapped() async {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        }

        await store.send(.privacyPolicyButtonTapped) {
            $0.destination = .safariView(
                SafariReducer.State(
                    url: URL(
                        string: "https://chukyo-bustime-app.web.app/#/privacy-policy"
                    )!
                )
            )
        }
    }

    func testToggleInitialTabButtonTapped() async {
        let store = TestStore(initialState: SettingReducer.State()) {
            SettingReducer()
        } withDependencies: {
            $0.userDefaultsClient.setInteger = { _, _ in
                // 何もしない.
            }
            $0.userDefaultsClient.integer = { _ in
                0
            }
        }

        await store.send(.toggleInitialTabButtonTapped) {
            $0.initialTab = 1
            $0.destination = .alert(
                AlertState {
                    TextState("設定完了")
                } message: {
                    TextState("起動時に表示する画面を\n大学行き の画面に設定しました。")
                }
            )
        }
    }
}
