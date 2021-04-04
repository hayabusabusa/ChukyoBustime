//
//  PDFButtonsModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift
import RxRelay

// MARK: - Interface

protocol PDFButtonsModel: AnyObject {
    /// Emits URL fetched from Firebase Remote Config.
    var pdfURLStream: Observable<URL> { get }
    
    /// Get Firebase Remote Config.
    func getPDFURL(of type: PDFURLType)
}

// MARK: - Implementation

class PDFButtonsModelImpl: PDFButtonsModel {
    
    // MARK: Properties
    
    private let remoteConfigProvider: RemoteConfigProviderProtocol
    
    private let disposeBag = DisposeBag()
    private let pdfURLRelay: PublishRelay<URL>
    
    let pdfURLStream: Observable<URL>
    
    // MARK: Initializer
    
    init(remoteConfigProvider: RemoteConfigProviderProtocol = RemoteConfigProvider.shared) {
        self.pdfURLRelay = .init()
        self.remoteConfigProvider = remoteConfigProvider
        
        pdfURLStream = pdfURLRelay.asObservable()
    }
    
    // MARK: Remote Config
    
    func getPDFURL(of type: PDFURLType) {
        remoteConfigProvider.getConfigValue(for: .pdfUrl, configType: RCPdfUrlEntity.self)
            .subscribe(onSuccess: { [weak self] entity in
                switch type {
                case .calendar:
                    guard let url = URL(string: entity.calendar) else {
                        return
                    }
                    self?.pdfURLRelay.accept(url)
                case .timeTable:
                    guard let url = URL(string: entity.timeTable) else {
                        return
                    }
                    self?.pdfURLRelay.accept(url)
                }
            })
            .disposed(by: disposeBag)
    }
}
