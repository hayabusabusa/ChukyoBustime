//
//  BusListModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/05/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

// MARK: - Interface

protocol BusListModel: AnyObject {
    func requestAuthorization() -> Single<Bool>
    func setNotification(at busTime: BusTime) -> Completable
}

// MARK: - Implementation

class BusListModelImpl: BusListModel {
    
    // MARK: Dependency
    
    private let userNotificationRepository: UserNotificationRepository
    
    // MARK: Initializer
    
    init(userNotificationRepository: UserNotificationRepository = UserNotificationRepositoryImpl()) {
        self.userNotificationRepository = userNotificationRepository
    }
    
    // MARK: UserNotification
    
    func requestAuthorization() -> Single<Bool> {
        return userNotificationRepository.requestAuthorization()
    }
    
    func setNotification(at busTime: BusTime) -> Completable {
        // NOTE: 一旦登録済みのものを全て削除
        userNotificationRepository.removeAllNotifications()
        return userNotificationRepository.setNotification(at: busTime.hour, minute: busTime.minute)
    }
}
