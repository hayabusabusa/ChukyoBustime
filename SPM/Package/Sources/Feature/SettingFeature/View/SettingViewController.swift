//
//  SettingViewController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Shared
import SwiftUI
import UIKit

public final class SettingViewController: UIViewController {

    // MARK: Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureSubviews()
        configureView()
    }
}

// MARK: - Configurations

private extension SettingViewController {
    func configureNavigation() {
        navigationItem.title = "設定"
    }

    func configureSubviews() {
        view.backgroundColor = .systemBackground
    }

    func configureView() {
        let rootView = SettingView(dataSource: SettingView.DataSource(sections: []))
        let hostingVC = UIHostingController(rootView: rootView)
        embed(hostingVC, to: view)
    }
}

// MARK: - SettingViewDelegate

extension SettingViewController: SettingViewDelegate {
    func settingViewDidTapItemView(for item: SettingItem) {
        print(item)
    }
}
