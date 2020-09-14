//
//  MockToCollegeModel.swift
//  ChukyoBustimeTests
//
//  Created by 山田隼也 on 2020/09/14.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
@testable import ChukyoBustime

final class MockToCollegeModelImpl: ToCollegeModel {
    
    private let busTimes: [BusTime]
    
    init(busTimes: [BusTime]) {
        self.busTimes = busTimes
    }
    
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return Single.just((busDate: BusDate(diagramName: "TEST"),
                            busTimes: busTimes))
    }
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.just(PdfUrl(calendar: "TEST", timeTable: "TEST"))
    }
}
