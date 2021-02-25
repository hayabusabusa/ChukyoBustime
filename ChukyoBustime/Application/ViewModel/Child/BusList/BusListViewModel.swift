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

// MARK: - Protocols

protocol BusListViewModelInputs {
    /// Call when the ok alert action tapped.
    func confirmAlertOKTapped(busTime: BusTime)
}

protocol BusListViewModelOutputs {
    /// Emits an error that should be presented with alert controller.
    var error: Signal<String> { get }
    
    /// Emits a message that should be presented with alert controller.
    var message: Signal<String> { get }
    
    /// Return destination enum value.
    var destination: Destination { get }
    
    /// Emits a tuple value of bus time should be show on custom view.
    var busList: Driver<(first: BusTime?, second: BusTime?, third: BusTime?)> { get }
}

protocol BusListViewModelType {
    var input: BusListViewModelInputs { get }
    var output: BusListViewModelOutputs { get }
}

// MARK: - ViewModel

final class BusListViewModel: BusListViewModelInputs, BusListViewModelOutputs {
    
    // MARK: Dependency
    
    struct Dependency {
        let destination: Destination
        let busTimesDriver: Driver<[BusTime]>
        let model: BusListModel
    }
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    private let errorRelay: PublishRelay<String>
    private let messageRelay: PublishRelay<String>
    private let busListRelay: BehaviorRelay<(first: BusTime?, second: BusTime?, third: BusTime?)>
    
    let error: Signal<String>
    let message: Signal<String>
    let destination: Destination
    let busList: Driver<(first: BusTime?, second: BusTime?, third: BusTime?)>
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.errorRelay = .init()
        self.messageRelay = .init()
        self.busListRelay = .init(value: (first: nil, second: nil, third: nil))
        
        error = errorRelay.asSignal()
        message = messageRelay.asSignal()
        destination = dependency.destination
        busList = busListRelay.asDriver()
        
        // NOTE: バス一覧から3件取り出して、表示のために変換して流す
        dependency.busTimesDriver
            .translate(with: BusListViewableTranslator())
            .drive(busListRelay)
            .disposed(by: disposeBag)
    }
    
    // MARK: Inputs
    
    func confirmAlertOKTapped(busTime: BusTime) {
        dependency.model.requestAuthorization()
            .flatMapCompletable { [weak self] isAuthorized -> Completable in
                guard let self = self else { return .empty() }
                
                if isAuthorized {
                    return self.dependency.model.setNotification(at: busTime)
                }
                
                // NOTE: 通知が許可されていない場合はメッセージを表示する
                self.messageRelay.accept("バスがくる5分前に\n通知が来るように設定できます。\nまずは通知の表示を許可してください。")
                return .empty()
            }.subscribe(onCompleted: { [weak self] in
                self?.messageRelay.accept(String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute))
            }, onError: { [weak self] error in
                self?.errorRelay.accept("エラーが発生しました")
            })
            .disposed(by: disposeBag)
    }
}

extension BusListViewModel: BusListViewModelType {
    var input: BusListViewModelInputs { return self }
    var output: BusListViewModelOutputs { return self }
}
