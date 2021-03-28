//
//  PdfButtonsViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol PdfButtonsViewModelInputs {
    /// Call when the calendar button is tapped.
    func calendarButtonTapped()
    
    /// Call when the time table button is tapped.
    func timeTableButtonTapped()
}

protocol PdfButtonsViewModelOutputs {
    /// Emits a URL that should be used to present `SFSafariViewController`.
    var presentSafari: Signal<URL> { get }
}

protocol PdfButtonsViewModelType {
    var input: PdfButtonsViewModelInputs { get }
    var output: PdfButtonsViewModelOutputs { get }
}

// MARK: - ViewModel

final class PdfButtonsViewModel: PdfButtonsViewModelInputs, PdfButtonsViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: PDFButtonsModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    private let presentSafariRelay: PublishRelay<URL>
    
    // MARK: Outputs
    
    let presentSafari: Signal<URL>
    
    // MARK: Initializer
    
    init(model: PDFButtonsModel = PDFButtonsModelImpl()) {
        self.model = model
        self.presentSafariRelay = .init()
        
        presentSafari = presentSafariRelay.asSignal()
    }
    
    // MARK: Inputs
    
    func calendarButtonTapped() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.calendar) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
    
    func timeTableButtonTapped() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.timeTable) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
}

extension PdfButtonsViewModel: PdfButtonsViewModelType {
    var input: PdfButtonsViewModelInputs { return self }
    var output: PdfButtonsViewModelOutputs { return self }
}
