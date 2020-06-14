//
//  BusListViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class BusListViewModel {
    
    // MARK: Dependency
    
    typealias Dependency = (destination: Destination, busTimesDriver: Driver<[BusTime]>, model: BusListModel)
    
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension BusListViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let confirmAlertOkDidTap: Signal<BusTime>
    }
    
    struct Output {
        let busListDriver: Driver<(first: BusTime?, second: BusTime?, third: BusTime?)>
        let messageSignal: Signal<String>
        let errorSignal: Signal<String>
    }
    
    // MARK: Transform I/O
    
    func transform(input: BusListViewModel.Input) -> BusListViewModel.Output {
        let busListRelay: BehaviorRelay<(first: BusTime?, second: BusTime?, third: BusTime?)> = .init(value: (first: nil, second: nil, third: nil))
        let messageRelay: PublishRelay<String> = .init()
        let errorRelay: PublishRelay<String> = .init()
        
        dependency.busTimesDriver
            .translate(with: BusListViewableTranslator())
            .drive(busListRelay)
            .disposed(by: disposeBag)
        
        // NOTE: アラートの OK をタップしたタイミングで通知を設定.
        input.confirmAlertOkDidTap
            .emit(onNext: { [weak self] busTime in
                guard let model = self?.dependency.model,
                    let disposeBag = self?.disposeBag else { return }

                // NOTE: Subscribe in Subscribe...
                model.requestAuthorization()
                    .flatMapCompletable { isAuthorized -> Completable in
                        if isAuthorized {
                            return model.setNotification(at: busTime)
                        } else {
                            messageRelay.accept("バスがくる5分前に\n通知が来るように設定できます。\nまずは通知の表示を許可してください。")
                            return Completable.empty()
                        }
                    }
                    .subscribe(onCompleted: {
                        messageRelay.accept(String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute))
                    }, onError: { error in
                        errorRelay.accept("エラーが発生しました\n\(error)")
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(busListDriver: busListRelay.asDriver(),
                      messageSignal: messageRelay.asSignal(),
                      errorSignal: errorRelay.asSignal())
    }
}
