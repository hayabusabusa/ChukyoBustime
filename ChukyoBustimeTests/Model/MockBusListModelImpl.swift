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
    
    init(isAuthorized: Bool, isErrorOccured: Bool) {
        self.isAuthorized = isAuthorized
        self.isErrorOccured = isErrorOccured
    }
    
    func requestAuthorization() -> Single<Bool> {
        return Single.just(isAuthorized)
    }
    
    func setNotification(at busTime: BusTime) -> Completable {
        return Completable.create { observer in
            self.isErrorOccured
                ? observer(.completed)
                : observer(.error(MockError.somethingWentWrong))
            
            return Disposables.create()
        }
    }
}
