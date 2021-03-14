//
//  MockBusListModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/26.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
import RxRelay
@testable import ChukyoBustime

final class MockBusListModelImpl: BusListModel {
    private let isAuthorized: Bool
    private let isErrorOccured: Bool
    
    private let errorRelay: PublishRelay<String>
    let errorStream: Observable<String>
    
    private let messageRelay: PublishRelay<String>
    let messageStream: Observable<String>
    
    
    init(isAuthorized: Bool = true, isErrorOccured: Bool = false) {
        self.isAuthorized = isAuthorized
        self.isErrorOccured = isErrorOccured
        self.errorRelay = .init()
        self.messageRelay = .init()
        
        errorStream = errorRelay.asObservable()
        messageStream = messageRelay.asObservable()
    }
    
    func setNotification(at busTime: BusTime) {
        if !isAuthorized || isErrorOccured {
            errorRelay.accept(MockError.somethingWentWrong.description)
            return
        }
        
        messageRelay.accept(String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute))
    }
}
