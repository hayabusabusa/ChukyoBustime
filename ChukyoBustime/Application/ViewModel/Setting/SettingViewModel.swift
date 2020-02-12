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
        // MARK: Input
        input.didSelectRow
            .emit(onNext: { row in
                print(row)
            })
            .disposed(by: disposeBag)
        
        return Output(settingsDriver: model.getSettings().asDriver(onErrorDriveWith: .empty()),
                      dismiss: input.closeBarButtonDidTap.asDriver(onErrorDriveWith: .empty()))
    }
}
