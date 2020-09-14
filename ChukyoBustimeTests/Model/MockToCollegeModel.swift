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

final class MockToCollegeModel: ToCollegeModel {
    
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return Single.just((busDate: BusDate(diagramName: "TEST"),
                            busTimes: [
                                BusTime(hour: 8, minute: 0, second: 0, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 0, isReturn: false, isLast: false, isKaizu: false),
                                BusTime(hour: 8, minute: 10, second: 0, arrivalHour: 8, arrivalMinute: 20, arrivalSecond: 0, isReturn: false, isLast: false, isKaizu: true)]))
    }
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.just(PdfUrl(calendar: "TEST", timeTable: "TEST"))
    }
}
