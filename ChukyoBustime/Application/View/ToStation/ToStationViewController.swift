//
//  ToStationViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import Infra
import RxSwift

final class ToStationViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    @IBOutlet private weak var layoutCountdownView: UIView!
    @IBOutlet private weak var layoutPdfButtonsView: UIView!
    @IBOutlet private weak var layoutBusListView: UIView!
    
    // MARK: Properties
    
    private var viewModel: ToStationViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScrollView()
        setupChildren()
        bindViewModel()
    }
}

// MARK: - Setup

extension ToStationViewController {
    
    private func setupNavigation() {
        navigationItem.title = "浄水駅行き"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_setting"), style: .plain, target: nil, action: nil)
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
    }
    
    private func setupChildren() {
        let pdfButtons = PdfButtonsViewController.configure()
        embed(pdfButtons, to: layoutPdfButtonsView)
    }
}

// MARK: - ViewModel

extension ToStationViewController {
    
    private func bindViewModel() {
        let viewModel = ToStationViewModel()
        self.viewModel = viewModel
        
        let settingBarButton = navigationItem.rightBarButtonItem!
        let input = ToStationViewModel.Input(settingBarButtonDidTap: settingBarButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        let diagram = DiagramViewController.configure(with: output.children.diagramViewModel)
        embed(diagram, to: layoutDiagramView)
        let countdown = CountdownViewController.configure(with: output.children.countdownViewModel)
        embed(countdown, to: layoutCountdownView)
        let busList = BusListViewController.configure(with: output.children.busListViewModel)
        embed(busList, to: layoutBusListView)
        
        output.presentSetting
            .drive(onNext: { [weak self] in self?.presentSetting() })
            .disposed(by: disposeBag)
    }
}

// MARK: - Transition

extension ToStationViewController {
    
    private func presentSetting() {
        let vc = NavigationController(rootViewController: SettingViewController.instantiate())
        present(vc, animated: true, completion: nil)
    }
}
