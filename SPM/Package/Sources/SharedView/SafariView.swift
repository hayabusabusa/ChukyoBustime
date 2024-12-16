//
//  SafariView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/17.
//

import ComposableArchitecture
import SafariServices
import SwiftUI

// MARK: - Reducer

/// `SFSafariViewController` を表示する画面の `Reducer`.
@Reducer
public struct SafariReducer {
    @ObservableState
    public struct State: Equatable {
        /// `SFSafariViewController` で表示する URL.
        public var url: URL

        public init(url: URL) {
            self.url = url
        }
    }

    public init() {}
}

// MARK: - View

/// `SFSafariViewController` を表示する View.
///
/// - note: `fullScreenCover` モディファイアで表示すること.
public struct SafariView: View {
    @Perception.Bindable public var store: StoreOf<SafariReducer>

    public var body: some View {
        WithPerceptionTracking {
            WrappedSFSafariViewController(
                url: store.url
            )
        }
        .ignoresSafeArea()
    }

    public init(store: StoreOf<SafariReducer>) {
        self.store = store
    }
}

/// `SFSafariViewController` をラップして SwiftUI で表示できるようにした View.
private struct WrappedSFSafariViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController

    /// 表示する `URL`.
    var url: URL
    /// `SFSafariViewController` 初期化時に渡す `Configuration`.
    var configuration: SFSafariViewController.Configuration?

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController: SFSafariViewController
        if let configuration {
            safariViewController = SFSafariViewController(
                url: url,
                configuration: configuration
            )
        } else {
            safariViewController = SFSafariViewController(url: url)
        }
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    SafariView(
        store: Store(
            initialState: SafariReducer.State(
                url: URL(string: "https://www.google.co.jp/")!
            ),
            reducer: { SafariReducer() }
        )
    )
}
