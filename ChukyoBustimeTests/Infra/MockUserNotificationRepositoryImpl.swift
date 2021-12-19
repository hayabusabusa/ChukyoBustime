//
//  MockUserNotificationRepositoryImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/14.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
import Infra

struct MockUserNotificationRepositoryImpl: UserNotificationRepository {
    let isErrorOccured: Bool
    
    init(isErrorOccured: Bool = false) {
        self.isErrorOccured = isErrorOccured
    }
    
    func requestAuthorization() -> Completable {
        return Completable.create { observer in
            observer(self.isErrorOccured
                        ? .error(MockError.somethingWentWrong)
                        : .completed)
            return Disposables.create()
        }
    }
    
    func setNotification(at hour: Int, minute: Int) -> Completable {
        return Completable.create { observer in
            observer(self.isErrorOccured
                        ? .error(MockError.somethingWentWrong)
                        : .completed)
            return Disposables.create()
        }
    }
    
    func removeAllNotifications() {
        // Do noting.
    }
}
