//
//  MockPDFButtonsModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/24.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
@testable import ChukyoBustime

final class MockPDFButtonsModelImpl: PDFButtonsModel {
    
    func getPdfUrl() -> Single<PdfUrl> {
        return Single.just(Mock.pdfURL)
    }
}
