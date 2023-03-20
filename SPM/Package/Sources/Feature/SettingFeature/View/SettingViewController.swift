//
//  SettingViewController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Combine
import ServiceProtocol
import Shared
import SwiftUI
import UIKit

public final class SettingViewController: UIViewController {

    // MARK: Properties

    private let viewModel: SettingViewModelProtocol
    private var dataSource = SettingView.DataSource(sections: [])
    private var subscriptions = Set<AnyCancellable>()

    // MARK: Lifecycle

    public init(userDefaultsService: UserDefaultsServiceProtocol,
                router: SettingRouterProtocol) {
        let model = SettingModel(userDefaultsService: userDefaultsService)
        self.viewModel = SettingViewModel(model: model,
                                          router: router)
        super.init(nibName: nil, bundle: nil)
        router.start(with: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubviews()
        configureView()
        configureSubscriptions()

        viewModel.input.viewDidLoad()
    }
}

// MARK: - Configurations

private extension SettingViewController {
    func configureNavigation() {
        navigationItem.title = "設定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(didTapCloseButton))
    }

    func configureSubscriptions() {
        viewModel.output.sections
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sections in
                self?.dataSource.sections = sections
            })
            .store(in: &subscriptions)
    }

    func configureSubviews() {
        view.backgroundColor = .systemGroupedBackground
    }

    func configureView() {
        let rootView = SettingView(dataSource: dataSource)
        let hostingVC = UIHostingController(rootView: rootView)
        embed(hostingVC, to: view)
    }
}

// MARK: - Private

private extension SettingViewController {
    @objc func didTapCloseButton() {
        viewModel.input.didTapCloseButton()
    }
}

// MARK: - SettingViewDelegate

extension SettingViewController: SettingViewDelegate {
    func settingViewDidTapItemView(for item: SettingItem) {
        viewModel.input.didTapItemView(for: item)
    }
}
