//
//  RootModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxRelay
import RxSwift

// MARK: - Interface

protocol RootModel: AnyObject {
    /// Emits void event when all configuration finished.
    var isCompletedStream: Observable<Void> { get }
    
    /// Fetch firebase remote config objects.
    func fetch()
}

// MARK: - Implementation

final class RootModelImpl: RootModel {
    
    // MARK: Property
    
    private let disposeBag = DisposeBag()
    private let isCompletedRelay: PublishRelay<Void>
    private let remoteConfigProvider: RemoteConfigProviderProtocol
    
    let isCompletedStream: Observable<Void>
    
    // MARK: Initializer
    
    init(remoteConfigProvider: RemoteConfigProviderProtocol = RemoteConfigProvider.shared) {
        self.isCompletedRelay = .init()
        self.remoteConfigProvider = remoteConfigProvider
        
        isCompletedStream = isCompletedRelay.asObservable()
    }
    
    // MARK: Remote Config
    
    func fetch() {
        remoteConfigProvider.fetchAndActivate()
            .subscribe(onCompleted: { [weak self] in
                self?.isCompletedRelay.accept(())
            }, onError: { [weak self] error in
                // NOTE: 必要があればエラーを表示する
                print(error)
                self?.isCompletedRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
}
