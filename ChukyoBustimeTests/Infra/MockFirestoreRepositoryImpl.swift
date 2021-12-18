//
//  MockFirestoreRepositoryImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/12/18.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

struct MockFirestoreRepositoryImpl: FirestoreRepository {
    
    let busDate: BusDateEntity
    let busTimes: [BusTimeEntity]
    var isErrorOccured: Bool = false
    
    func getBusTimes(at date: Date, destination: BusDestination) -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])> {
        if isErrorOccured {
            return Single.error(MockError.somethingWentWrong)
        } else {
            return Single.just((busDate: busDate, busTimes: busTimes))
        }
    }
}
