//
//  PdfUrlTranslator.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra

struct PdfUrlTranslator: Translator {
    typealias Input = RCPdfUrlEntity
    typealias Output = PdfUrl
    
    func translate(_ input: RCPdfUrlEntity) throws -> PdfUrl {
        return PdfUrl(calendar: input.calendar,
                      timeTable: input.timeTable)
    }
}
