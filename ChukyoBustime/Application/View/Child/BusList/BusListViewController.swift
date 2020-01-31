//
//  BusListViewController.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxCocoa

final class BusListViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var firstBusListView: BusListView!
    @IBOutlet private weak var secondBusListView: BusListView!
    @IBOutlet private weak var thirdBusListView: BusListView!
    
    // MARK: Properties
    
    private var viewModel: BusListViewModel!
    
    // MARK: Lifecycle
    
    static func configure(with destination: Destination, busTimesDriver: Driver<[BusTime]>) -> BusListViewController {
        let vc = Storyboard.BusListViewController.instantiate(BusListViewController.self)
        vc.viewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: destination,
                                                                                busTimesDriver: busTimesDriver))
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    // MARK: IBAction
}

// MARK: - Setup

extension BusListViewController {
    
    func setupBusListViews(with destination: Destination) {
        let departurePoint: String
        let arrivalPoint: String
        switch destination {
        case .college:
            departurePoint = "浄水駅発"
            arrivalPoint = "大学着"
        case .station:
            departurePoint = "大学発"
            arrivalPoint = "浄水駅着"
        }
        firstBusListView.setupView(number: 1, departurePoint: departurePoint, arrivalPoint: arrivalPoint)
        secondBusListView.setupView(number: 2, departurePoint: departurePoint, arrivalPoint: arrivalPoint)
        thirdBusListView.setupView(number: 3, departurePoint: departurePoint, arrivalPoint: arrivalPoint)
    }
}

// MARK: - ViewModel

extension BusListViewController {
    
    private func bindView() {
        setupBusListViews(with: viewModel.dependency.destination)
    }
}
