//
//  SettingViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/07.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var viewModel: SettingViewModel!
    
    private var dataSource: [SettingSectionType] = [
        .config(rows: [
            .normal(title: "起動時に表示")]),
        .about(rows: [
            .normal(title: "バージョン"),
            .normal(title: "利用規約"),
            .normal(title: "リポジトリ")])]
    
    // MARK: Lifecycle
    
    static func instantiate() -> SettingViewController {
        return Storyboard.SettingViewController.instantiate(SettingViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        bindViewModel()
    }
}

// MARK: - Setup

extension SettingViewController {
    
    private func setupNavigation() {
        navigationItem.title = "設定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: nil, action: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.rowHeight = SettingCell.rowHeight
        tableView.register(SettingCell.nib, forCellReuseIdentifier: SettingCell.reuseIdentifier)
    }
}

// MARK: - ViewModel

extension SettingViewController {
    
    private func bindViewModel() {
        let viewModel = SettingViewModel()
        self.viewModel = viewModel
        
        let closeBarButton = navigationItem.rightBarButtonItem!
        let input = SettingViewModel.Input(closeBarButtonDidTap: closeBarButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        output.dismiss
            .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
    }
}

// MARK: - TableView dataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section].rows[indexPath.row] {
        case .normal(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                return UITableViewCell()
            }
            cell.setupCell(title: title)
            return cell
        }
    }
}
