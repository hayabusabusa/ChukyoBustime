//
//  BusListModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/05/16.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxRelay
import RxSwift

// MARK: - Interface

protocol BusListModel: AnyObject {
    /// Emits message that is not error.
    var messageStream: Observable<String> { get }
    
    /// Emits error message.
    var errorStream: Observable<String> { get }

    /// Set local notification at time passed as argument.
    func setNotification(at busTime: BusTime)
}

// MARK: - Implementation

class BusListModelImpl: BusListModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let errorRelay: PublishRelay<String>
    private let messageRelay: PublishRelay<String>
    private let userNotificationRepository: UserNotificationRepository
    
    let errorStream: Observable<String>
    let messageStream: Observable<String>
    
    // MARK: Initializer
    
    init(userNotificationRepository: UserNotificationRepository = UserNotificationRepositoryImpl()) {
        self.errorRelay = .init()
        self.messageRelay = .init()
        self.userNotificationRepository = userNotificationRepository
        
        errorStream = errorRelay.asObservable()
        messageStream = messageRelay.asObservable()
    }
    
    // MARK: UserNotification
    
    func setNotification(at busTime: BusTime) {
        // NOTE: 一旦登録済みのものを全て削除
        userNotificationRepository.removeAllNotifications()
        // NOTE: 認証状態を確認した後にローカル通知を設定する
        userNotificationRepository.requestAuthorization()
            .andThen(userNotificationRepository.setNotification(at: busTime.hour, minute: busTime.minute))
            .subscribe(onCompleted: { [weak self] in
                self?.messageRelay.accept(String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute))
            }, onError: { [weak self] error in
                let message = (error as CustomStringConvertible).description
                self?.errorRelay.accept(message)
            })
            .disposed(by: disposeBag)
    }
}
