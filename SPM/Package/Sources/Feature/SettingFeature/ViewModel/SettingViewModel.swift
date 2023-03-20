//
//  SettingViewModel.swift
//  
//
//  Created by Shunya Yamada on 2023/03/20.
//

import Combine
import Foundation
import Shared

// MARK: Protocol

protocol SettingViewModelInput {
    /// 画面初回表示時.
    func viewDidLoad()
    /// リストの項目タップ時.
    func didTapItemView(for item: SettingItem)
    /// ナビゲージョンバーの閉じるボタンタップ時.
    func didTapCloseButton()
}

protocol SettingViewModelOutput {
    /// 画面に表示するデータ.
    var dataSource: AnyPublisher<SettingView.DataSource, Never> { get }
}

protocol SettingViewModelProtocol {
    var input: SettingViewModelInput { get }
    var output: SettingViewModelOutput { get }
}

// MARK: - ViewModel

final class SettingViewModel {
    private let model: SettingModelProtocol
    private let router: SettingRouterProtocol
    private let dataSourceSubject: CurrentValueSubject<SettingView.DataSource, Never>

    init(model: SettingModelProtocol,
         router: SettingRouterProtocol) {
        self.model = model
        self.router = router
        self.dataSourceSubject = CurrentValueSubject<SettingView.DataSource, Never>(SettingView.DataSource(sections: []))
    }
}

// MARK: - Input

extension SettingViewModel: SettingViewModelInput {
    func viewDidLoad() {
        let version = model.version ?? ""
        let initialTab = model.initialTab ?? 0

        let sections = [
            SettingSection(title: "アプリの設定",
                           items: [
                            .tabSetting(setting: initialTab == 0 ? "浄水駅行き" : "大学行き")
                           ]),
            SettingSection(title: "このアプリについて",
                           items: [
                            .version(version: version),
                            .about,
                            .disclaimer,
                            .privacyPolicy
                           ])
        ]
        dataSourceSubject.send(SettingView.DataSource(sections: sections))
    }

    func didTapItemView(for item: SettingItem) {
        
    }

    func didTapCloseButton() {
        router.dismiss()
    }
}

// MARK: - Output

extension SettingViewModel: SettingViewModelOutput {
    var dataSource: AnyPublisher<SettingView.DataSource, Never> {
        dataSourceSubject.eraseToAnyPublisher()
    }
}

extension SettingViewModel: SettingViewModelProtocol {
    var input: SettingViewModelInput { self }
    var output: SettingViewModelOutput { self }
}
