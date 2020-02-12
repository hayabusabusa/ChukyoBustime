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
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
}

extension SettingViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let closeBarButtonDidTap: Signal<Void>
        let didSelectRow: Signal<SettingSectionType.SettingCellType>
    }
    
    struct Output {
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
        
        return Output(dismiss: input.closeBarButtonDidTap.asDriver(onErrorDriveWith: .empty()))
    }
}
