//
//  CountdownViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxCocoa

final class CountdownViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var isLastButton: UIButton!
    @IBOutlet private weak var isReturnButton: UIButton!
    @IBOutlet private weak var isKaizuButton: UIButton!
    @IBOutlet private weak var countdownLabel: UILabel!
    @IBOutlet private weak var departureTimeLabel: UILabel!
    @IBOutlet private weak var departureImageView: UIImageView!
    @IBOutlet private weak var departurePointLabel: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var arrivalImageView: UIImageView!
    @IBOutlet private weak var arrivalPointLabel: UILabel!
    
    // MARK: Properties
    
    private var viewModel: CountdownViewModel!
    
    // MARK: Lifecycle
    
    static func configure(with viewModel: CountdownViewModel) -> CountdownViewController {
        let vc = Storyboard.CountdownViewController.instantiate(CountdownViewController.self)
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
    }
}

// MARK: Setup

extension CountdownViewController {
    
    private func setupViews(with destination: Destination) {
        switch destination {
        case .college:
            departureImageView.image = UIImage(named: "ic_train")
            departurePointLabel.text = "浄水駅発"
            arrivalImageView.image = UIImage(named: "ic_school")
            arrivalPointLabel.text = "大学着"
        case .station:
            departureImageView.image = UIImage(named: "ic_school")
            departurePointLabel.text = "大学発"
            arrivalImageView.image = UIImage(named: "ic_train")
            arrivalPointLabel.text = "浄水駅着"
        }
    }
}

// MARK: ViewModel

extension CountdownViewController {
    
    private func bindViewModel() {
        viewModel.output.isHideLastButton
            .drive(isLastButton.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.output.isHideReturnButton
            .drive(isReturnButton.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.output.isHideKaizuButton
            .drive(isKaizuButton.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.output.timer
            .drive(countdownLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.departureTime
            .drive(departureTimeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.arrivalTime
            .drive(arrivalTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        setupViews(with: viewModel.dependency.destination)
    }
}
