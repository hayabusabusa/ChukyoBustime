//
//  PdfButtonsModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

// MARK: - Interface

protocol PdfButtonsModel: AnyObject {
    func getPdfUrl() -> Single<PdfUrl>
}

// MARK: - Implementation

class PdfButtonsModelImpl: PdfButtonsModel {
    
    // MARK: Dependency
    
    private let remoteConfigProvider: RemoteConfigProvider
    
    // MARK: Initializer
    
    init(remoteConfigProvider: RemoteConfigProvider = RemoteConfigProvider.shared) {
        self.remoteConfigProvider = remoteConfigProvider
    }
    
    // MARK: Remote Config
    
    func getPdfUrl() -> Single<PdfUrl> {
        return remoteConfigProvider
            .getConfigValue(for: .pdfUrl, configType: RCPdfUrlEntity.self)
            .translate(PdfUrlTranslator())
    }
}
