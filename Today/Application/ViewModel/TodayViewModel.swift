//
//  TodayViewModel.swift
//  Today
//
//  Created by 山田隼也 on 2020/03/18.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TodayViewModel {
    
    // MARK: Dependency
    
    private let model: TodayModel
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: TodayModel = TodayModelImpl()) {
        self.model = model
    }
}

extension TodayViewModel {
    
    // MARK: I/O
    
    struct Input {
        let widgetDidTap: Signal<Void>
    }
    
    struct Output {
        let isHiddenDriver: Driver<Bool>
        let collegeDriver: Driver<String>
        let stationDriver: Driver<String>
        let messageDriver: Driver<String?>
        let openApplicationSignal: Signal<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(_ input: TodayViewModel.Input) -> TodayViewModel.Output {
        let isHiddenRelay: BehaviorRelay<Bool> = .init(value: true)
        let collegeRelay: BehaviorRelay<String> = .init(value: "")
        let stationRelay: BehaviorRelay<String> = .init(value: "")
        let messageRealy: BehaviorRelay<String?> = .init(value: nil)
        
        // Model
        let now = Date()
        model.loadCache(at: now)
            .subscribe(onSuccess: { caches in
                let isHidden = caches.college == nil && caches.station == nil
                isHiddenRelay.accept(isHidden)
                messageRealy.accept(isHidden ? "データがありません。\nアプリを起動してデータを取得してください。" : nil)
                
                collegeRelay.accept(caches.college ?? "-")
                stationRelay.accept(caches.station ?? "-")
            }, onError: { error in
                print(error)
                messageRealy.accept("エラーが発生しました。")
            })
            .disposed(by: disposeBag)
        
        return Output(isHiddenDriver: isHiddenRelay.asDriver(),
                      collegeDriver: collegeRelay.asDriver(),
                      stationDriver: stationRelay.asDriver(),
                      messageDriver: messageRealy.asDriver(),
                      openApplicationSignal: input.widgetDidTap)
    }
}
