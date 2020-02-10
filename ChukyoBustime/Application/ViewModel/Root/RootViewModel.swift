//
//  RootViewModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RootViewModel {
    
    // MARK: Dependency
    
    private let model: RootModel
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: RootModel = RootModelImpl()) {
        self.model = model
    }
}

extension RootViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let viewDidAppear: Signal<Void>
    }
    
    struct Output {
        let replaceRootToTabBar: Driver<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: RootViewModel.Input) -> RootViewModel.Output {
        let replaceRootToTabBarRelay: PublishRelay<Void> = .init()
        
        input.viewDidAppear
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
                // NOTE: Activate Firebase Remote Config values.
                self.model.fetchAndActivate()
                    .subscribe(onCompleted: {
                        replaceRootToTabBarRelay.accept(())
                    }, onError: { error in
                        // TODO: Error handling.
                        print(error)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(replaceRootToTabBar: replaceRootToTabBarRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
