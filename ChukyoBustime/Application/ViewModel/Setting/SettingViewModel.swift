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
    }
    
    struct Output {
        let dismiss: Driver<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: SettingViewModel.Input) -> SettingViewModel.Output {
        return Output(dismiss: input.closeBarButtonDidTap.asDriver(onErrorDriveWith: .empty()))
    }
}
