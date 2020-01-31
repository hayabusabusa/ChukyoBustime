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
    
    static func configure(with destination: Destination, busTimesDriver: Driver<[BusTime]>) -> CountdownViewController {
        let vc = Storyboard.CountdownViewController.instantiate(CountdownViewController.self)
        vc.viewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(destination: destination,
                                                                                    busTimesDriver: busTimesDriver))
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func bindView() {
        setupViews(with: viewModel.dependency.destination)
    }
}
