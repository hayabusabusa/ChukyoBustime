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
    
    private var dataSource: [SettingSectionType] = [SettingSectionType]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = SettingCell.rowHeight
        tableView.register(SettingCell.nib, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        tableView.register(SettingLabelCell.nib, forCellReuseIdentifier: SettingLabelCell.reuseIdentifier)
        tableView.register(SettingItemCell.nib, forCellReuseIdentifier: SettingItemCell.reuseIdentifier)
    }
}

// MARK: - ViewModel

extension SettingViewController {
    
    private func bindViewModel() {
        let viewModel = SettingViewModel()
        self.viewModel = viewModel
        
        let closeBarButton = navigationItem.rightBarButtonItem!
        let didSelecteRow = tableView.rx.itemSelected
            .map { [weak self] indexPath in self?.dataSource[indexPath.section].rows[indexPath.row] }
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())
        let input = SettingViewModel.Input(closeBarButtonDidTap: closeBarButton.rx.tap.asSignal(),
                                           didSelectRow: didSelecteRow)
        let output = viewModel.transform(input: input)
        
        output.settingsDriver
            .drive(onNext: { [weak self] settings in self?.dataSource = settings })
            .disposed(by: disposeBag)
        output.messageSignal
            .emit(onNext: { [weak self] message in self?.presentAlertController(title: "", message: message) })
            .disposed(by: disposeBag)
        output.presentSafariSignal
            .emit(onNext: { [weak self] url in self?.presentSafari(url: url) })
            .disposed(by: disposeBag)
        output.dismissSignal
            .emit(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
    }
}

// MARK: - Transition

extension SettingViewController {
    
    private func presentSafari(url: URL) {
        let vc = SafariViewController(url: url)
        present(vc, animated: true, completion: nil)
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
        case .tabSetting(let setting):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.reuseIdentifier, for: indexPath) as? SettingItemCell else {
                return UITableViewCell()
            }
            cell.setupCell(title: "起動時に表示", item: setting, selectionStyle: .default)
            return cell
        case .version(let version):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingLabelCell.reuseIdentifier, for: indexPath) as? SettingLabelCell else {
                return UITableViewCell()
            }
            cell.setupCell(title: "バージョン", content: version)
            return cell
        case .app:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                return UITableViewCell()
            }
            cell.setupCell(title: "このアプリについて")
            return cell
        case .precations:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath) as? SettingCell else {
                return UITableViewCell()
            }
            cell.setupCell(title: "利用上の注意")
            return cell
        }
    }
}

// MARK: - TableView delegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
