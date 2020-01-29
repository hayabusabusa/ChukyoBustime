//
//  PrototypeViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import Infra
import RxSwift
import RxCocoa
import SwiftDate

final class PrototypeViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stackTextView: UITextView!
    
    // MARK: Properties
    
    struct BusTimes: Decodable {
        let times: [BusTime]
    }
    private var busTimes: [BusTime]!
    private let json = """
    {
        "times":
        [
            {
                "hour": 16,
                "minute": 4,
                "isLast": false,
                "isReturn": false
            },
            {
                "hour": 16,
                "minute": 5,
                "isLast": false,
                "isReturn": false
            },
            {
                "hour": 16,
                "minute": 6,
                "isLast": false,
                "isReturn": false
            },
            {
                "hour": 16,
                "minute": 7,
                "isLast": false,
                "isReturn": false
            },
            {
                "hour": 16,
                "minute": 8,
                "isLast": false,
                "isReturn": false
            }
        ]
    }
    """.data(using: .utf8)!
    
    private let timeRelay: BehaviorRelay<Int> = .init(value: 0)
    private let stackRelay: BehaviorRelay<String> = .init(value: "START")
    private let isValidRelay: BehaviorRelay<Bool> = .init(value: true)
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    static func instantiate() -> PrototypeViewController {
        return Storyboard.PrototypeViewController.instantiate(PrototypeViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBusTimes()
        setupLabel()
        setupTextView()
        setupTimer()
    }
}

// MARK: - Setup

extension PrototypeViewController {
    
    private func setupBusTimes() {
        busTimes = try! JSONDecoder().decode(BusTimes.self, from: json).times
    }
    
    private func setupLabel() {
        timeRelay.map { String(format: "%02i:%02i", $0 / 60, $0 % 60) }
        .debug()
        .bind(to: timeLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func setupTextView() {
        stackRelay
            .bind(to: stackTextView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTimer() {
        isValidRelay
            .distinctUntilChanged()
            .flatMapLatest { $0 ? Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) : .empty() }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.timeRelay.accept(self.timeRelay.value - 1)
            })
            .disposed(by: disposeBag)
        timeRelay
            .share(replay: 1, scope: .forever)
            .filter { $0 <= 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.updateBusTimesArray()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateBusTimesArray() {
        if let first = busTimes.first {
            // Update TextView
            stackRelay.accept(stackRelay.value + " < \(first.hour):\(first.minute)" )
            
            // Remove First
            busTimes.removeFirst()
            
            // Update Timer to next busTime
            if let next = busTimes.first {
                timeRelay.accept(Int(interval(of: next)))
            }
        } else {
            timeLabel.text = "終了しました"
            isValidRelay.accept(false)
            stackRelay.accept(stackRelay.value + " < END")
        }
    }
}

// MARK: - Util

extension PrototypeViewController {
    
    private func interval(of busTime: BusTime) -> Int64 {
        let dateInRegionOfToday = DateInRegion(Date(), region: .current)
        let dateInRegionOfBusTime = DateInRegion(year: dateInRegionOfToday.year,
                                                 month: dateInRegionOfToday.month,
                                                 day: dateInRegionOfToday.day,
                                                 hour: busTime.hour,
                                                 minute: busTime.minute,
                                                 second: 0,
                                                 nanosecond: 0,
                                                 region: .current)
        return dateInRegionOfToday.getInterval(toDate: dateInRegionOfBusTime, component: .second)
    }
}
