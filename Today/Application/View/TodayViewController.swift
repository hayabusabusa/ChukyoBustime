//
//  TodayViewController.swift
//  Today
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var parentButton: UIButton!
    @IBOutlet private weak var parentStackView: UIStackView!
    @IBOutlet private weak var collegeTimeLabel: UILabel!
    @IBOutlet private weak var stationTimeLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: TodayViewModel!
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParentStackViews()
        setupMessageLabel()
        bindViewModel()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

// MARK: - Setup

extension TodayViewController {
    
    private func setupParentStackViews() {
        parentStackView.alpha = 0
        lineView.alpha = 0
    }
    
    private func setupMessageLabel() {
        messageLabel.alpha = 0
    }
}

// MARK: - ViewModel

extension TodayViewController {
    
    private func bindViewModel() {
        let viewModel = TodayViewModel()
        self.viewModel = viewModel
        
        let input = TodayViewModel.Input(widgetDidTap: parentButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        
        output.isHiddenDriver
            .drive(onNext: { [weak self] isHidden in
                if isHidden {
                    self?.showMessageLabelAnimation()
                } else {
                    self?.showParentStackViewAnimation()
                }
            })
            .disposed(by: disposeBag)
        output.collegeDriver
            .drive(collegeTimeLabel.rx.text)
            .disposed(by: disposeBag)
        output.stationDriver
            .drive(stationTimeLabel.rx.text)
            .disposed(by: disposeBag)
        output.messageDriver
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
        output.openApplicationSignal
            .emit(onNext: { [weak self] in self?.openApplication() })
            .disposed(by: disposeBag)
    }
}

// MARK: - Animation

extension TodayViewController {
    
    private func showParentStackViewAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.parentStackView.alpha = 1
            self.lineView.alpha = 1
        }
    }
    
    private func showMessageLabelAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.messageLabel.alpha = 0.5
        }
    }
}

// MARK: Transition

extension TodayViewController {
    
    private func openApplication() {
        extensionContext?.open(Configurations.kApplicationUrlScheme, completionHandler: nil)
    }
}
