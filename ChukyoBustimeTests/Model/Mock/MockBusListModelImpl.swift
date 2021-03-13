//
//  MockBusListModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/26.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
@testable import ChukyoBustime

final class MockBusListModelImpl: BusListModel {
    let isAuthorized: Bool
    let isErrorOccured: Bool
    
    init(isAuthorized: Bool = true, isErrorOccured: Bool = false) {
        self.isAuthorized = isAuthorized
        self.isErrorOccured = isErrorOccured
    }
    
    func requestAuthorization() -> Completable {
        return Completable.create { observer in
            self.isAuthorized
                ? observer(.completed)
                : observer(.error(MockError.somethingWentWrong))
            
            return Disposables.create()
        }
    }
    
    func setNotification(at busTime: BusTime) -> Completable {
        return Completable.create { observer in
            self.isErrorOccured
                ? observer(.error(MockError.somethingWentWrong))
                : observer(.completed)
            
            return Disposables.create()
        }
    }
}
