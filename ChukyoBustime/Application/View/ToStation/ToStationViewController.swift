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

final class ToStationViewController: BaseViewController, StateViewable {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var layoutDiagramView: UIView!
    @IBOutlet private weak var layoutCountdownView: UIView!
    @IBOutlet private weak var layoutPdfButtonsView: UIView!
    @IBOutlet private weak var layoutBusListView: UIView!
    
    // MARK: Properties
    
    let stateView: StateView = StateView(frame: .zero,
                                         image: UIImage(named: "img_operation_end"),
                                         title: "本日の運行は終了しました",
                                         content: "明日の運行カレンダーと時刻表は\n以下から確認できます")
    private var viewModel: ToStationViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> ToStationViewController {
        return Storyboard.ToStationViewController.instantiate(ToStationViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScrollView()
        setupStateView()
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
        // NOTE: Hide scroll view until fetching data from firestore.
        scrollView.alpha = 0
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
        let foregroundNotification = NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in () }
        let input = ToStationViewModel.Input(foregroundSignal: foregroundNotification.asSignal(onErrorSignalWith: .empty()),
                                             settingBarButtonDidTap: settingBarButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        let diagram = DiagramViewController.configure(with: output.children.diagramViewModel)
        embed(diagram, to: layoutDiagramView)
        let countdown = CountdownViewController.configure(with: output.children.countdownViewModel)
        embed(countdown, to: layoutCountdownView)
        let busList = BusListViewController.configure(with: output.children.busListViewModel)
        embed(busList, to: layoutBusListView)
        
        // NOTE: Scroll view animation and state view animation
        output.stateDriver
            .drive(onNext: { [weak self] state in
                self?.startScrollViewAnimation(isHidden: state == .none ? false : true)
                self?.stateView.setState(of: state)
            })
            .disposed(by: disposeBag)
        output.presentSettingSignal
            .emit(onNext: { [weak self] in self?.presentSetting() })
            .disposed(by: disposeBag)
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
}
