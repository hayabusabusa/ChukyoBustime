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
        bindViewModel()
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
        firstBusListView.setupView(number: 1, centerIcon: UIImage(named: "ic_hyphen"), departurePoint: departurePoint, arrivalPoint: arrivalPoint)
        secondBusListView.setupView(number: 2, centerIcon: UIImage(named: "ic_hyphen"), departurePoint: departurePoint, arrivalPoint: arrivalPoint)
        thirdBusListView.setupView(number: 3, centerIcon: UIImage(named: "ic_hyphen"), departurePoint: departurePoint, arrivalPoint: arrivalPoint)
    }
}

// MARK: - Update

extension BusListViewController {
    
    private func updateBusList(first: BusTime?, second: BusTime?, third: BusTime?) {
        // TODO: この辺りTabelViewにしてしまえばもう少しうまく書けるかもしれない
        if let first = first {
            let arrivalSecond = first.second + 900
            firstBusListView.show(departureTime: String(format: "%i:%02i", first.hour, first.minute),
                                  arrivalTime: String(format: "%i:%02i", arrivalSecond / 3600, arrivalSecond / 60 % 60))
        } else {
            firstBusListView.hide()
        }
        if let second = second {
            let arrivalSecond = second.second + 900
            secondBusListView.show(departureTime: String(format: "%i:%02i", second.hour, second.minute),
                                   arrivalTime: String(format: "%i:%02i", arrivalSecond / 3600, arrivalSecond / 60 % 60))
        } else {
            secondBusListView.hide()
        }
        if let third = third {
            let arrivalSecond = third.second + 900
            thirdBusListView.show(departureTime: String(format: "%i:%02i", third.hour, third.minute),
                                  arrivalTime: String(format: "%i:%02i", arrivalSecond / 3600, arrivalSecond / 60 % 60))
        } else {
            thirdBusListView.hide()
        }
    }
}

// MARK: - ViewModel

extension BusListViewController {
    
    private func bindViewModel() {
        let input = BusListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.busListDriver
            .drive(onNext: { [weak self] busList in
                self?.updateBusList(first: busList.first, second: busList.second, third: busList.third)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        setupBusListViews(with: viewModel.dependency.destination)
    }
}
