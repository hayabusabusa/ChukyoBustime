//
//  ToDestinationViewModel.swift
//  
//
//  Created by Shunya Yamada on 2023/03/20.
//

import Combine
import Foundation
import Shared

// MARK: - Protocol

protocol ToDestinationViewModelInput {
    /// 画面初回表示時.
    func viewDidLoad() async
    /// ナビゲーションバーの設定ボタンタップ時.
    func didTapSettingButton()
}

protocol ToDestinationViewModelOutput {
    /// バスの行き先.
    var destination: BusDestination { get }
    /// ロード中かどうかのフラグ.
    var isLoading: AnyPublisher<Bool, Never> { get }
}

protocol ToDestinationViewModelProtocol {
    var input: ToDestinationViewModelInput { get }
    var output: ToDestinationViewModelOutput { get }
}

// MARK: - ViewModel

@MainActor
final class ToDestinationViewModel {
    private let model: ToDestinationModelProtocol
    private let router: ToDestinationRouterProtocol

    init(model: ToDestinationModelProtocol,
         router: ToDestinationRouterProtocol) {
        self.model = model
        self.router = router
    }
}

// MARK: - Input

extension ToDestinationViewModel: ToDestinationViewModelInput {
    func viewDidLoad() async {
        await model.fetchBusTimes()
    }

    func didTapSettingButton() {
        router.transitionToSettings()
    }
}

// MARK: - Output

extension ToDestinationViewModel: ToDestinationViewModelOutput {
    var destination: BusDestination {
        model.destination
    }

    var isLoading: AnyPublisher<Bool, Never> {
        model.isLoading
    }
}

extension ToDestinationViewModel: ToDestinationViewModelProtocol {
    var input: ToDestinationViewModelInput { self }
    var output: ToDestinationViewModelOutput { self }
}
