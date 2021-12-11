//
//  MockToCollegeModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
@testable import ChukyoBustime

final class MockToCollegeModelImpl: ToCollegeModel {
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
                        ? .failure(MockError.somethingWentWrong)
                        : .success((self.busDate, self.busTimes)))
            
            return Disposables.create()
        }
    }
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.create { [unowned self] observer in
            observer(self.isErrorOccured
                        ? .failure(MockError.somethingWentWrong)
                        : .success(Stub.pdfURL))
            
            return Disposables.create()
        }
    }
}
