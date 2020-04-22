//
//  SettingViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/07.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    
    // MARK: Dependency
    
    private let model: SettingModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: SettingModel = SettingModelImpl()) {
        self.model = model
    }
}

extension SettingViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let closeBarButtonDidTap: Signal<Void>
        let didSelectRow: Signal<SettingSectionType.SettingCellType>
    }
    
    struct Output {
        let settingsDriver: Driver<[SettingSectionType]>
        let dismiss: Driver<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: SettingViewModel.Input) -> SettingViewModel.Output {
        let settingsRelay: BehaviorRelay<[SettingSectionType]> = .init(value: [])
        let reloadRelay: PublishRelay<Void> = .init()
        
        reloadRelay.asSignal()
            .map { [weak self] in self?.model.getSettings() ?? [] }
            .emit(onNext: { settingsRelay.accept($0) })
            .disposed(by: disposeBag)
        
        // NOTE: Initial load.
        reloadRelay.accept(())
        
        // NOTE: On tap table view cell
        input.didSelectRow
            .emit(onNext: { [weak self] row in
                switch row {
                case.tabSetting(let current):
                    let new = current == TabBarItem.toStation.title ? TabBarItem.toCollege : TabBarItem.toStation
                    self?.model.saveTabSetting(tabBarItem: new)
                    reloadRelay.accept(()) // Reload table view
                case .agreement: print("Agreement")
                case .repository: print("Repository")
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        return Output(settingsDriver: settingsRelay.asDriver(),
                      dismiss: input.closeBarButtonDidTap.asDriver(onErrorDriveWith: .empty()))
    }
}
