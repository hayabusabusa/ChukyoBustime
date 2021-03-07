//
//  ToStationViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxCocoa

final class ToStationViewController: BaseViewController, StateViewable {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    @IBOutlet private weak var layoutCountdownView: UIView!
    @IBOutlet private weak var layoutPdfButtonsView: UIView!
    @IBOutlet private weak var layoutBusListView: UIView!
    
    // MARK: Properties
    
    let stateView: StateView = StateView(of: .toStation)
    
    private var viewModel: ToStationViewModelType!
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScrollView()
        setupStateView()
        setupStateViewHandler()
        setupChildViewContoller()
        bindViewModel()
        bindView()
        
        viewModel.input.viewDidLoad()
    }
    
    @objc private func barButtonItemTapped() {
        viewModel.input.settingButtonTapped()
    }
    
    @objc private func handleWillEnterForegroundNotification() {
        viewModel.input.willEnterForeground()
    }
}

// MARK: - Setup

extension ToStationViewController {
    
    private func setupNavigation() {
        navigationItem.title = "浄水駅行き"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_setting"), style: .plain, target: self, action: #selector(barButtonItemTapped))
    }
    
    private func setupScrollView() {
        // NOTE: Hide scroll view until fetching data from firestore.
        scrollView.alpha = 0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
    }
    
    private func setupStateViewHandler() {
        stateView.onTapCalendarButton = { [weak self] in
            self?.viewModel?.input.calendarButtonTapped()
        }
        stateView.onTapTimeTableButton = { [weak self] in
            self?.viewModel?.input.timeTableButtonTapped()
        }
    }
    
    private func setupChildViewContoller() {
        let pdfButtons = PdfButtonsViewController.configure()
        embed(pdfButtons, to: layoutPdfButtonsView)
    }
}

// MARK: - ViewModel

extension ToStationViewController {
    
    private func bindViewModel() {
        viewModel = ToStationViewModel()
        
        // NOTE: Scroll view animation and state view animation
        viewModel.output.state
            .drive(onNext: { [weak self] state in
                self?.startScrollViewAnimation(isHidden: state == .none ? false : true)
                self?.stateView.setState(of: state)
            })
            .disposed(by: disposeBag)
        viewModel.output.presentSetting
            .emit(onNext: { [weak self] in self?.presentSetting() })
            .disposed(by: disposeBag)
        viewModel.output.presentSafari
            .emit(onNext: { [weak self] url in self?.presentSafari(with: url) })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        let diagramViewController = DiagramViewController.configure(with: viewModel.output.childViewModels.diagramViewModel)
        embed(diagramViewController, to: layoutDiagramView)
        let countdownViewController = CountdownViewController.configure(with: viewModel.output.childViewModels.countdownViewModel)
        embed(countdownViewController, to: layoutCountdownView)
        let busListViewController = BusListViewController.configure(with: viewModel.output.childViewModels.busListViewModel)
        embed(busListViewController, to: layoutBusListView)
    }
}

// MARK: - Animation

extension ToStationViewController {
    
    private func startScrollViewAnimation(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.scrollView.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: - Transition

extension ToStationViewController {
    
    private func presentSetting() {
        let vc = NavigationController(rootViewController: SettingViewController.instantiate())
        present(vc, animated: true, completion: nil)
    }
    
    private func presentSafari(with url: URL) {
        let vc = SafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
