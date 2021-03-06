//
//  MockToStationModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/06.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import SwiftDate
@testable import ChukyoBustime

final class MockToStationModelImpl: ToStationModel {
    let busDate: BusDate
    let busTimes: [BusTime]
    let isErrorOccured: Bool
    
    init(busDate: BusDate, busTimes: [BusTime], isErrorOccured: Bool = false) {
        self.busDate = busDate
        self.busTimes = busTimes
        self.isErrorOccured = isErrorOccured
    }

    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return Single.create { [unowned self] observer in
            observer(self.isErrorOccured
                        ? .success((self.busDate, self.busTimes))
                        : .failure(MockError.somethingWentWrong))
            
            return Disposables.create()
        }
    }
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.create { [unowned self] observer in
            observer(self.isErrorOccured
                        ? .success(Mock.pdfURL)
                        : .failure(MockError.somethingWentWrong))
            
            return Disposables.create()
        }
    }
}
