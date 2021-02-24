//
//  MockPDFButtonsModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/24.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
@testable import ChukyoBustime

final class MockPDFButtonsModelImpl: PdfButtonsModel {
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.just(PdfUrl(calendar: "http://example.com", timeTable: "http://example.org"))
    }
}
